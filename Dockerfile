FROM redis:7.0.11-alpine

COPY redis.conf /usr/local/etc/redis/redis.conf

VOLUME /data

EXPOSE 6379

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
