
FROM ubuntu
RUN apt-get update -y
RUN apt-get install -y nginx
COPY ../static-website-example  /var/www/html
EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
