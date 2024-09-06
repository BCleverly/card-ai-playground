# Card Manager

This project is a card management system using PHP, Nginx, PostgreSQL, and MinIO.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

Follow these steps to set up and run the project:

1. Clone the repository:
   ```
   git clone https://github.com/your-username/card-manager.git
   cd card-manager
   ```

2. Make the setup script executable:
   ```
   chmod +x setup.sh
   ```

3. Run the setup script to create your `.env` file:
   ```
   ./setup.sh
   ```

4. Open the `.env` file and update the environment variables with your specific configuration:
   ```
   nano .env
   ```
   Ensure you set appropriate values for:
   - `POSTGRES_USER`
   - `POSTGRES_PASSWORD`
   - `POSTGRES_MULTIPLE_DATABASES`
   - `MINIO_ROOT_USER`
   - `MINIO_ROOT_PASSWORD`

5. Build and start the Docker containers:
   ```
   docker-compose up -d --build
   ```

6. Access the applications:
   - Web application: http://localhost
   - MinIO console: http://localhost:9001
   - Label Studio: http://localhost:8080

## Project Structure

- `web/`: Contains the PHP application code
- `nginx/`: Nginx configuration
- `postgres-init/`: PostgreSQL initialization scripts
- `docker-compose.yml`: Defines the multi-container Docker application
- `setup.sh`: Script to initialize the `.env` file

## Development

To make changes to the project:

1. Modify the code in the `web/src` directory
2. Rebuild and restart the containers:
   ```
   docker-compose down
   docker-compose up -d --build
   ```

## Troubleshooting

If you encounter any issues:

1. Check the Docker logs:
   ```
   docker-compose logs
   ```
2. Ensure all required ports are available (80, 5432, 9000, 9001)
3. Verify that your `.env` file is correctly configured

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
