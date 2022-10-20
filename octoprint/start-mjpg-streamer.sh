#!/bin/sh

# TODO: Add in some configuration options?
export LD_LIBRARY_PATH=/usr/local/lib/mjpg-streamer
mjpg_streamer -i "input_uvc.so" -o "output_http.so"

