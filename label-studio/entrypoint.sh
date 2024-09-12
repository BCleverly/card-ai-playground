#!/bin/bash

# Start Label Studio
label-studio start &

# Wait for Label Studio to start
echo "Waiting for Label Studio to start..."
until curl -s http://localhost:8080/health > /dev/null; do
    sleep 5
done
echo "Label Studio is up and running."

# Function to get or create auth token
get_or_create_token() {
    local username="$LABEL_STUDIO_USERNAME"
    local password="$LABEL_STUDIO_PASSWORD"

    # Try to get the token
    local token=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"username\":\"$username\",\"password\":\"$password\"}" http://localhost:8080/api/auth/login/ | grep -o '"token":"[^"]*' | grep -o '[^"]*$')

    if [ -z "$token" ]; then
        echo "Failed to retrieve token. Attempting to create a new user..."
        # Create a new user if login fails
        curl -s -X POST -H "Content-Type: application/json" -d "{\"email\":\"$username\",\"password\":\"$password\"}" http://localhost:8080/api/auth/signup/
        
        # Try to get the token again
        token=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"username\":\"$username\",\"password\":\"$password\"}" http://localhost:8080/api/auth/login/ | grep -o '"token":"[^"]*' | grep -o '[^"]*$')
    fi

    echo "$token"
}

# Get or create the auth token
AUTH_TOKEN=$(get_or_create_token)

if [ -z "$AUTH_TOKEN" ]; then
    echo "Failed to obtain authentication token. Exiting."
    exit 1
fi

echo "Authentication token obtained successfully."

# Check if a project exists
PROJECT_COUNT=$(curl -s -H "Authorization: Token $AUTH_TOKEN" http://localhost:8080/api/projects/ | grep -c '"id":')

if [ $PROJECT_COUNT -eq 0 ]; then
    echo "No projects found. Creating a default project..."
    curl -X POST -H "Content-Type: application/json" -H "Authorization: Token $AUTH_TOKEN" -d '{"title":"Default Project","description":"This is a default project created on startup."}' http://localhost:8080/api/projects/
    echo "Default project created."
else
    echo "Projects already exist. Skipping default project creation."
fi

# Keep the container running
wait
