FROM postgres:12.3-alpine

COPY assets/full_restore.sql  /docker-entrypoint-initdb.d/

ENV POSTGRES_USER MAC350_2020
ENV POSTGRES_PASSWORD MAC350_2020

EXPOSE 5432
