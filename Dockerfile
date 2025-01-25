FROM nginx

RUN rm -f /var/log/nginx/access.log /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log && \
    chmod 644 /var/log/nginx/*.log

RUN apt update && \
    apt install vim -y
