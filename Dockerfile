FROM ubuntu
RUN apt-get update -y
RUN apt-get install -y nginx
RUN git clone https://github.com/diranetafen/static-website-example.git /var/www/html/
#ADD ./static-website-example  /var/www/html
EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
