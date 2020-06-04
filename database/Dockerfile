FROM postgres:12.3-alpine

COPY schema.sql  /docker-entrypoint-initdb.d/1-schema.sql
COPY procedures/insert_user.sql  /docker-entrypoint-initdb.d/2-insert_user.sql
COPY procedures/insert_user_tutorcpf.sql  /docker-entrypoint-initdb.d/3-insert_user_tutorcpf.sql
COPY procedures/insert_profile.sql  /docker-entrypoint-initdb.d/4-insert_profile.sql
COPY procedures/add_profile_to_user.sql  /docker-entrypoint-initdb.d/5-add_profile_to_user.sql
COPY procedures/insert_service.sql  /docker-entrypoint-initdb.d/6-insert_service.sql
COPY procedures/add_service_to_profile.sql  /docker-entrypoint-initdb.d/7-add_service_to_profile.sql

ENV POSTGRES_USER MAC350_2020
ENV POSTGRES_PASSWORD MAC350_2020

EXPOSE 5432
