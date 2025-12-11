
FROM postgres:18


# You can save the database by saving /var/lib/postgresql with a mount or 
# a volume

# If a volume isn't used to retrieve the database (and its password)
# you have to initialize the password by providing POSTGRES_PASSWORD

ENV POSTGRES_USER=tora
ENV POSTGRES_DB=default

EXPOSE 5432