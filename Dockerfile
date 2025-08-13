# =========================
# 1. Base Image
# =========================
FROM python:3.12

# Prevents Python from writing .pyc files and enables stdout/stderr logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies and build tools for SQLite
RUN apt-get update && apt-get remove -y libsqlite3-0 libsqlite3-dev libopenexr-3-1-30 libopenexr-dev && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    wget \
    tcl-dev \
    libxml2=2.9.14+dfsg-1.3~deb12u3 \
    && rm -rf /var/lib/apt/lists/*

# Download, compile, and install SQLite 3.50.4
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
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# =========================
# 3. Copy Application Code
# =========================
COPY . .
RUN chown -R appuser:appuser /app

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
