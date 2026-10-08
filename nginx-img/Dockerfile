FROM debian:stable-slim

RUN apt-get update && apt-get install -y nginx
RUN echo "<h1>Bienvenue sur le Nginx docker de Najib</h1>" > /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
