FROM python:3.8

ENV GLOUD_PROJECT eld-efs-sandbox-5576df8f
ENV GOOGLE_APPLICATION_CREDENTIALS /app/google-insane-key.json

WORKDIR /app

COPY google-insane-key.json .
COPY subscriber/subscriber.py .
COPY subscriber/requirements.txt .

RUN apt-get update && \
    pip install -r requirements.txt

EXPOSE 6895
CMD ["python","subscriber.py"]