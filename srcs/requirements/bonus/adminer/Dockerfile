FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    php php-mysqli \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
COPY adminer.php /var/www/html/index.php

EXPOSE 8081

CMD ["php", "-S", "0.0.0.0:8081", "-t", "/var/www/html"]