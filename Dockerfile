FROM ubuntu
MAINTAINER BJWRD "brad.whitcomb97@gmail.com" # Change the name and email address accordingly
RUN apt-get update \
    && apt-get install -y python3 \
    && apt-get install -y python3-pip \
    && pip install flask

#Copy the app.py file from the current folder to /opt inside the container
COPY app.py /opt/app.py

ENTRYPOINT FLASK_APP=/opt/app.py flask run --host=0.0.0.0 --port=8080
