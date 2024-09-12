#!/bin/bash

# Check if .env file exists, if not create it from .env.example
if [ ! -f .env ]; then
    cp .env.example .env
    echo ".env file created. Please update it with your specific configuration."
else
    echo ".env file already exists."
fi

# Function to prompt for GitHub repository URL
prompt_for_repo() {
    read -p "Enter the GitHub repository URL for your web application: " repo_url
    echo $repo_url
}

# Check if web/src folder exists
if [ ! -d "web/src" ]; then
    mkdir -p web/src
    echo "web/src folder created."
fi

# Check if web/src folder is empty
if [ -z "$(ls -A web/src)" ]; then
    echo "web/src folder is empty."
    repo_url=$(prompt_for_repo)
    
    if [ -n "$repo_url" ]; then
        echo "Cloning repository into web/src folder..."
        git clone $repo_url web/src
        if [ $? -eq 0 ]; then
            echo "Repository cloned successfully."
            
            # Check if public folder exists in the cloned repository
            if [ ! -d "web/src/public" ]; then
                echo "Warning: public folder not found in the cloned repository."
                echo "Make sure your web application has a public folder with an index.php file."
            fi
        else
            echo "Failed to clone repository. Please check the URL and try again."
        fi
    else
        echo "No repository URL provided. web/src folder will remain empty."
    fi
else
    echo "web/src folder is not empty. Skipping repository clone."
fi

# Ensure nginx folder exists
mkdir -p nginx

# Create or update nginx/default.conf
cat > nginx/default.conf <<EOL
server {
    listen 80;
    index index.php index.html;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/html/public;

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass web:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
        gzip_static on;
    }
}
EOL

echo "Nginx configuration created/updated."

# Additional setup steps can be added here

echo "Setup complete."
