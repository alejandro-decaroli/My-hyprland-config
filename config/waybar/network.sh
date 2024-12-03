#!/bin/bash

if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "󰤨 Connected"  # Connected icon
else
    echo "󰤭 Disconnected"  # Disconnected icon
fi

