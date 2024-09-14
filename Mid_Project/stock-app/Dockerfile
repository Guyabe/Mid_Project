# Use Python 3.10-slim as base image for smaller size
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Install necessary dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code into the container
COPY . .

# Expose Flask app port and Prometheus metrics port
EXPOSE 5001 8000

# Create the logs directory
RUN mkdir -p /app/logs

# Command to run the Flask app
CMD ["python", "app.py"]
