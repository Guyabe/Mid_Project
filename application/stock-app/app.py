from flask import Flask, render_template, request
import yfinance as yf
import numpy as np
from sklearn.linear_model import LinearRegression
from prometheus_client import start_http_server, Gauge, Counter
import logging
import os
import threading
import time
from pymongo import MongoClient
import sys

# Flask app setup
app = Flask(__name__)

# Ensure logs directory exists
log_dir = 'logs'
if not os.path.exists(log_dir):
    os.makedirs(log_dir)

# Configure logging to write to 'logs/stock-app.log'
log_file = os.path.join(log_dir, 'stock-app.log')
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    filemode='a'  # Append mode, ensures new logs are added to existing log file
)

# MongoDB client setup
# The MongoDB URI is fetched dynamically from the environment variable
mongo_uri = os.getenv("MONGO_URI", "mongodb://root:password@localhost:27017/")
client = MongoClient(mongo_uri)
db = client.stock_app_db  # Use or create a database
stocks_collection = db.stocks  # Use or create a collection

# Prometheus metrics
current_stock_value = Gauge('current_stock_value', 'Current value of a stock', ['stock'])
predicted_stock_value = Gauge('predicted_stock_value', 'Predicted value of a stock', ['stock'])
request_counter = Counter('webapp_request_count', 'Total number of requests to the web app')


@app.route('/', methods=['GET', 'POST'])
def index():
    predicted_value = None
    stock_ticker = None

    if request.method == 'POST':
        stock_ticker = request.form['stock']
        predicted_value = get_stock_data(stock_ticker)

        # Increment the request counter
        request_counter.inc()

        # Log the searched stock
        logging.info(f'Stock searched: {stock_ticker}')

        # Save the stock data to MongoDB
        stocks_collection.insert_one({
            "stock": stock_ticker,
            "data": predicted_value
        })

    # List of stocks to pull
    stock_list = ['INTC', 'AAPL', 'GOOGL', 'AMZN', 'MSFT', 'TSLA', 'META', 'NFLX', 'NVDA', 'BABA']
    stock_predictions = {ticker: get_stock_data(ticker) for ticker in stock_list}

    return render_template('index.html', predicted_value=predicted_value, stock_ticker=stock_ticker,
                           stock_predictions=stock_predictions)


@app.route('/metrics')
def metrics():
    from prometheus_client import generate_latest
    return generate_latest()


def get_stock_data(ticker):
    try:
        stock_data = yf.download(ticker, period='5d', interval='1d', progress=False)
        if len(stock_data) < 2:
            return {"yesterday": "N/A", "today": "N/A",
                    "predicted_tomorrow": {"value": "N/A", "sign": "", "color": "black"}}

        prices = stock_data['Close'].values[-2:]
        X = np.array([1, 2]).reshape(-1, 1)
        y = prices
        model = LinearRegression()
        model.fit(X, y)
        predicted_price = model.predict(np.array([[3]]))[0]

        sign = "+" if predicted_price > prices[1] else "-"
        color = "green" if predicted_price > prices[1] else "red"

        # Set Prometheus metrics
        current_stock_value.labels(ticker).set(prices[1])
        predicted_stock_value.labels(ticker).set(predicted_price)

        return {
            "yesterday": round(prices[0], 2),
            "today": round(prices[1], 2),
            "predicted_tomorrow": {
                "value": round(predicted_price, 2),
                "sign": sign,
                "color": color
            }
        }
    except Exception as e:
        logging.error(f"Error fetching data for {ticker}: {e}")
        return {
            "yesterday": "N/A",
            "today": "N/A",
            "predicted_tomorrow": {
                "value": "N/A",
                "sign": "",
                "color": "black"
            }
        }


def get_stock_prediction(ticker):
    """
    A helper function to return only the predicted stock price.
    """
    try:
        stock_data = yf.download(ticker, period='5d', interval='1d', progress=False)
        if len(stock_data) < 2:
            return None

        prices = stock_data['Close'].values[-2:]
        X = np.array([1, 2]).reshape(-1, 1)
        y = prices
        model = LinearRegression()
        model.fit(X, y)
        predicted_price = model.predict(np.array([[3]]))[0]

        return round(predicted_price, 2)
    except Exception as e:
        logging.error(f"Error predicting stock for {ticker}: {e}")
        return None


def get_recommendation():
    """
    Calculates and returns the stock with the highest predicted price.
    """
    stock_list = ['INTC', 'AAPL', 'GOOGL', 'AMZN', 'MSFT', 'TSLA', 'META', 'NFLX', 'NVDA', 'BABA']
    best_stock = None
    highest_predicted_price = -float('inf')

    for ticker in stock_list:
        predicted_price = get_stock_prediction(ticker)
        if predicted_price is not None and predicted_price > highest_predicted_price:
            highest_predicted_price = predicted_price
            best_stock = ticker

    if best_stock:
        return f"The best stock to buy is {best_stock} with a predicted price of ${highest_predicted_price}"
    else:
        return "No valid stock data available for recommendation."


def update_metrics_periodically():
    stock_list = ['INTC', 'AAPL', 'GOOGL', 'AMZN', 'MSFT', 'TSLA', 'META', 'NFLX', 'NVDA', 'BABA']
    while True:
        for ticker in stock_list:
            get_stock_data(ticker)
        time.sleep(30)


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == "-provide_recommendation":
        # Print out the stock recommendation based on predicted prices
        print(get_recommendation())
    else:
        # Start Prometheus metrics server
        start_http_server(8000)

        # Start background thread to update metrics every 30 seconds
        metrics_thread = threading.Thread(target=update_metrics_periodically)
        metrics_thread.daemon = True  # Daemon thread will shut down when the main program exits
        metrics_thread.start()

        # Start Flask web server
        app.run(host='0.0.0.0', port=5001)
