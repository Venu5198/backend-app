FROM python:3.11-slim

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Ensure logs are flushed immediately
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies (minimal)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app app

# Create non-root user
RUN useradd -m appuser
USER appuser

EXPOSE 8080

# Run as module, not file
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
