import logging
import random
import json
import time
import os
from paho.mqtt import client as mqtt_client
from databasemanager import write_to_db


FIRST_RECONNECT_DELAY = 1
RECONNECT_RATE = 2
MAX_RECONNECT_COUNT = 12
MAX_RECONNECT_DELAY = 60

logger = logging.getLogger(__name__)


db_file = "/home/tpf/.binctl/data/bins.db"
log_file = "/home/tpf/.binctl/log/data-logger.log"

broker = "localhost"
port = 1883
topic = "/binctl"
client_id = f"python-mqtt-{random.randint(0,1000)}"

def on_mqtt_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker")
        client.subscribe(topic)
    else:
        print("Failed to connect, return code %d\n", rc)

def on_mqtt_disconnect(client, userdata, rc):
    logging.info("Disconnected with return code: %s", rc)
    reconnect_count = 0
    reconnect_delay = FIRST_RECONNECT_DELAY

    while reconnect_count < MAX_RECONNECT_COUNT:
        logging.info("Reconnecting in %d seconds...", reconnect_delay)
        time.sleep(reconnect_delay)

        try:
            client.reconnect()
            logging.info("Reconnected successfully")
            return
        except Exception as err:
            logging.error("%s. Reconnect failed. Retrying...", err)

        reconnect_delay *= RECONNECT_RATE
        reconnect_delay = min(reconnect_delay, MAX_RECONNECT_DELAY)
        reconnect_count += 1
        logging.info("Reconnect failed after %s attempts. Exiting...", reconnect_count);


def on_mqtt_message(client, userdata, msg):
    message = msg.payload.decode()
    print(f"Received `{message}` from `{msg.topic}` topic")
    json_obj = json.loads(message)
    bin_id = json_obj["id"]
    bin_weight = json_obj["weight"]
    write_to_db(db_file, bin_id, bin_weight)

def main():
    logging.basicConfig(filename=log_file, level=logging.INFO)
    logger.info("started")

    client = mqtt_client.Client(client_id)
    client.on_connect = on_mqtt_connect
    client.on_message = on_mqtt_message
    client.on_disconnect = on_mqtt_disconnect

    client.connect(broker, port)

    client.loop_forever()

if __name__ == '__main__':
    main()
