FROM python:3.8

ENV GLOUD_PROJECT eld-efs-sandbox-5576df8f

WORKDIR /app

COPY publisher.py .
COPY requirements.txt .

RUN apt-get update && \
    pip install -r requirements.txt

EXPOSE 6895
CMD ["python","publisher.py"]