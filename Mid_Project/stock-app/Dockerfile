# Use Python 3.10 as base image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code into the container
COPY .. .

# Expose the app's port (default Flask port)
EXPOSE 5001 8000

# Command to run the Flask app
CMD ["python", "app.py"]
