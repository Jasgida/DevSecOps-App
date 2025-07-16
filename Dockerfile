# Dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY app/requirements.txt .

# Install dependencies including pytest
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir pytest

COPY app/ .

CMD ["python", "app.py"]

