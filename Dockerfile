FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_ENV production

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application
COPY . .

# Create necessary directories
RUN mkdir -p uploads logs
RUN chmod 777 uploads logs

# Run as non-root user
RUN useradd -m myuser
USER myuser

# Expose port
EXPOSE $PORT

# Start the application
CMD gunicorn --workers=4 --threads=2 --timeout 120 --bind 0.0.0.0:$PORT wsgi:app