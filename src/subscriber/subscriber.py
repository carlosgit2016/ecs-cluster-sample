'''
    Example of a subscriber application
'''

from google.cloud import pubsub_v1

subscription_name = 'projects/eld-efs-sandbox-5576df8f/subscriptions/insane-subscription'

def callback(message):
    print({
        'message': str(message)
    })
    message.ack()

with pubsub_v1.SubscriberClient() as subscriber:
    future = subscriber.subscribe(subscription_name, callback)
    
    try:
        future.result()
    except Exception as ex:
        subscriber.cancel()
