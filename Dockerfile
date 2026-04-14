# Multi-stage build untuk Flask dashboard Muse 2

# Stage 1: Base image dengan Python
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements-docker.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements-docker.txt

# Copy aplikasi
COPY app.py .
COPY templates/ templates/
COPY muse_connect.py .
COPY analyze_data.py .

# Create data directories
RUN mkdir -p /app/muse_data
RUN mkdir -p /app/apk_downloads

# Expose port 9009
EXPOSE 9009

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:9009/')" || exit 1

# Run Flask app
CMD ["python", "app.py"]
