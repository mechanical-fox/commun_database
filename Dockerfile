
FROM postgres:18

ENV POSTGRES_USER=tora
ENV POSTGRES_DB=default
# Variable to set in the computer building the image : POSTGRES_PASSWORD
# VOLUME to save the database: /var/lib/postgresql

# Documentation of the port used
EXPOSE 5432