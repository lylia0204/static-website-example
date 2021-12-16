FROM ubuntu
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install nginx
RUN git clone https://github.com/diranetafen/static-website-example.git /var/www/html/
#ADD ./static-website-example  /var/www/html
EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
