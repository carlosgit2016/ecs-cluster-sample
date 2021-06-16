FROM python:3.8

ENV GLOUD_PROJECT eld-efs-sandbox-5576df8f
ENV GOOGLE_APPLICATION_CREDENTIALS /app/google-insane-key.json

WORKDIR /app

COPY google-insane-key.json .
COPY publisher/publisher.py .
COPY publisher/requirements.txt .

RUN apt-get update && \
    pip install -r requirements.txt

# The EXPOSE instruction does not actually publish the port. It functions as a type of documentation between the person who builds the image and the person who runs the container, about which ports are intended to be published
EXPOSE 6895
CMD ["python","publisher.py"]