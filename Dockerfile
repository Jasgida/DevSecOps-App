FROM python:3.11-alpine3.22

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache py3-pip curl && \
    apk add --no-cache --virtual .build-deps build-base gcc musl-dev linux-headers && \
    apk update && apk upgrade sqlite-libs && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install setuptools>=78.1.1 && \
    apk del .build-deps

COPY . .

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app.app:app"]
