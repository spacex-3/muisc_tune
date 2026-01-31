FROM python:3.11-slim

WORKDIR /app

# Install curl for healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY *.py ./
COPY .env.example .env.example

# Create directories for persistent data
# /app/config - for .env file (optional, can use env vars instead)
# /app/cache - for audio cache, server cache, user data, credits log
RUN mkdir -p /app/config /app/cache /app/cache/audio

# Environment variables (can be overridden at runtime)
ENV TUNEHUB_API_KEY=""
ENV SERVER_HOST="0.0.0.0"
ENV SERVER_PORT="4040"
ENV SUBSONIC_USER="admin"
ENV SUBSONIC_PASSWORD="admin"
ENV DEFAULT_QUALITY="flac"
ENV AUDIO_CACHE_MAX_SIZE="10737418240"

# Data paths (for Docker volume mapping)
ENV CONFIG_DIR="/app/config"
ENV CACHE_DIR="/app/cache"

# Expose port
EXPOSE 4040

# Volumes for persistent data
VOLUME ["/app/config", "/app/cache"]

# Run the server
CMD ["python", "server.py"]
