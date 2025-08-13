FROM python:3.12

# Prevents Python from writing .pyc files and enables stdout/stderr logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies and build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    wget \
    tcl-dev \
    libxml2 \
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

# Remove unnecessary packages after SQLite installation
RUN apt-get update && apt-get remove -y libsqlite3-dev libopenexr-3-1-30 libopenexr-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user and set permissions early
RUN useradd -m appuser && \
    mkdir -p /app /app/.pytest_cache && \
    chown -R appuser:appuser /app

# Set working directory and switch to non-root user
WORKDIR /app
USER appuser

# Install Python dependencies
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copy application code and fix permissions
COPY --chown=appuser:appuser . .
RUN chmod -R u+rw /app

# Expose port and start app
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.main:app"]
