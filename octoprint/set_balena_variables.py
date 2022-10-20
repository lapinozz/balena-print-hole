#!/usr/bin/env python3

import yaml
import os

with open('./config.yaml', 'r+') as f:
    data = yaml.load(f, Loader=yaml.FullLoader)
    data["plugins"]["mqtt"]["broker"]["url"] = os.environ["MQTT_BROKER"]
    f.seek(0)
    f.write(yaml.dump(data, default_flow_style=False))
    f.truncate()
