'''
    Example of a subscriber application
'''

from google.cloud import pubsub_v1

subscription_name = 'projects/insane_project/subscriptions/insane-subscription'

def callback(message):
    print(message)
    message.ack()

with pubsub_v1.SubscriberClient() as subscriber:
    future = subscriber.subscribe(subscription_name, callback)
    
    try:
        future.result()
    except future.exception as base:
        print(base)
    except Exception as ex:
        print(ex)
    finally:
        future.cancel()