#!/usr/bin/env python3

import paho.mqtt.client as paho
import os
import sys

# Use environment variables from the Balena dashboard or any other source to inform the script.
broker = os.environ["MQTT_BROKER"]
port = int(os.environ["MQTT_BROKER_PORT"])
espurna_name = os.environ["ESPURNA_RELAY_NAME"]
# Create client object
client = paho.Client("Octobalena")
# Establish connection
client.connect(broker,port)
# Publish the MQTT message, second argument of client.publish() is the value of the message.
try:
  if sys.argv[1] == "on":
    client.publish(espurna_name+"/relay/0/set","1")
    print("Turned printed on")
  elif sys.argv[1] == "off":
    client.publish(espurna_name+"/relay/0/set","0")
    print("Turned printer off")
  else:
    print("invalid or no argument(s) provided, valid arguments are 'on' or 'off'")
except IndexError:
  print("invalid or no argument(s) provided, valid arguments are 'on' or 'off'")
