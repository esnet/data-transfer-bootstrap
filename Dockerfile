FROM python:3.9-slim-bullseye

RUN apt-get update \
    && apt-get install -y supervisor \
    && apt-get clean

EXPOSE 80

COPY entrypoint.sh /

# merge files from user mount points and start nginx on port 80 via supervisord as the CMD
CMD /entrypoint.sh