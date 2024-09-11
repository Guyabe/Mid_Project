from flask import Flask, render_template, request
import yfinance as yf
import numpy as np
from sklearn.linear_model import LinearRegression
from prometheus_client import start_http_server, Gauge

app = Flask(__name__)

# Prometheus metrics
current_stock_value = Gauge('current_stock_value', 'Current value of a stock', ['stock'])
predicted_stock_value = Gauge('predicted_stock_value', 'Predicted value of a stock', ['stock'])


@app.route('/', methods=['GET', 'POST'])
def index():
    predicted_value = None
    stock_ticker = None

    if request.method == 'POST':
        stock_ticker = request.form['stock']
        predicted_value = get_stock_data(stock_ticker)

    stock_list = ['INTC', 'AAPL', 'GOOGL', 'AMZN', 'MSFT', 'TSLA', 'FB', 'NFLX', 'NVDA', 'BABA']
    stock_predictions = {ticker: get_stock_data(ticker) for ticker in stock_list}

    return render_template('index.html', predicted_value=predicted_value, stock_ticker=stock_ticker,
                           stock_predictions=stock_predictions)


@app.route('/metrics')
def metrics():
    from prometheus_client import generate_latest
    return generate_latest()


def get_stock_data(ticker):
    try:
        stock_data = yf.download(ticker, period='5d', interval='1d')
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
        return {
            "yesterday": "N/A",
            "today": "N/A",
            "predicted_tomorrow": {
                "value": "N/A",
                "sign": "",
                "color": "black"
            }
        }


if __name__ == '__main__':
    start_http_server(8000)
    app.run(host='0.0.0.0', port=5001)