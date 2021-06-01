'''
    Example of a publisher application
'''

import datetime
import uuid
from google.cloud import pubsub_v1
import flask
from flask import request


topic_name = 'projects/eld-efs-sandbox-5576df8f/topics/insane-topic'

def publish_topic(message=b'Hello World', **kwargs):

    publisher = pubsub_v1.PublisherClient()

    future = publisher.publish(topic_name, message, date=datetime.datetime.now().isoformat(), id=str(uuid.uuid4()))

    try:
        n = future.result()
        return f'Topic published: {n}'
    except Exception as ex:
        print(ex)
        publisher.cancel()

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/publish', methods=['POST'])
def publish():
    result = publish_topic()
    return flask.jsonify({ 'message': result }) 

app.run(port=6895)