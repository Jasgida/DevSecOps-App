# =========================
# 1. Base Image
# =========================
FROM python:3.11 AS base

# Prevents Python from writing .pyc files and enables stdout/stderr logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies and build tools for SQLite
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    wget \
    tcl-dev \
    && rm -rf /var/lib/apt/lists/*

# Download, compile, and install updated SQLite (3.50.4) to fix CVE-2025-6965
RUN wget https://www.sqlite.org/2025/sqlite-autoconf-3500400.tar.gz && \
    tar xvfz sqlite-autoconf-3500400.tar.gz && \
    cd sqlite-autoconf-3500400 && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    rm -rf sqlite-autoconf-3500400 sqlite-autoconf-3500400.tar.gz

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

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.main:app"]
