#!/bin/bash
sudo docker ps --format "{{.ID}} {{.Image}}" | grep "aphrodite" | awk '{print $1}' | xargs sudo docker stop

