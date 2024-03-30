#!/bin/bash
set -e
sudo pkill -SIGHUP dockerd || true