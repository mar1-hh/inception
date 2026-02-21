FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-available/default

COPY index.html /var/www/html/index.html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]