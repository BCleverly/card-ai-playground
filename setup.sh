#!/bin/bash

if [ ! -f .env ]; then
    cp .env.example .env
    echo ".env file created. Please update it with your specific configuration."
else
    echo ".env file already exists."
fi
