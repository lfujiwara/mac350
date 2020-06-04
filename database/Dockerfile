FROM postgres:12.3-alpine

COPY dump/restore.sql  /docker-entrypoint-initdb.d/restore.sql

ENV POSTGRES_USER MAC350_2020
ENV POSTGRES_PASSWORD MAC350_2020

EXPOSE 5432
