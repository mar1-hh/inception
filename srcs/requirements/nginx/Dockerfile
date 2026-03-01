FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nginx openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# RUN apt-get update && apt-get install -y netcat-openbsd \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN rm -f /etc/nginx/nginx.conf && rm -rf /etc/nginx/conf.d/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
 -newkey rsa:2048 \
 -keyout /etc/nginx/ssl/nginx.key \
 -out /etc/nginx/ssl/nginx.crt \
 -subj "/C=MA/ST=Morocco/L=Tetouan/O=1337/OU=student/CN=msaadaou.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]