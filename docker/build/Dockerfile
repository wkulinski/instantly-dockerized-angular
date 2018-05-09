FROM nginx:1.13-alpine

RUN apk add --update nginx
RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*

ADD nginx.conf /etc/nginx/
ADD angular.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/conf.d/default.conf

RUN adduser -D -g '' -G www-data www-data

WORKDIR /var/www/angular

COPY --chown=www-data:www-data . .

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
