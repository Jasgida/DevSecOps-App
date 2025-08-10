# =========================
# 1. Base Image
# =========================
FROM python:3.11-slim AS base

# Prevents Python from writing .pyc files and enables stdout/stderr logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# =========================
# 2. Install Dependencies
# =========================
WORKDIR /app

# Install dependencies first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# =========================
# 3. Copy Application Code
# =========================
COPY . .

# =========================
# 4. Run as Non-Root User
# =========================
RUN useradd -m appuser
USER appuser

# =========================
# 5. Expose Port & Start App
# =========================
EXPOSE 5000

CMD ["python", "app/main.py"]
