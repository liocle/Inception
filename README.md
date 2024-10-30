# Inception

## Overview

Welcome to my Inception project repository! This project, completed as part of my studies at Hive Helsinki, focuses on designing and deploying a self-hosted, containerized infrastructure. Using Docker Compose on an Oracle Cloud-hosted virtual machine, this setup includes a fully functional WordPress site, secured with NGINX, and supported by MariaDB. Each component is configured for performance, isolation, and reliability.

## Project Structure

The project leverages Docker to create a small, isolated infrastructure with the following components:

- **NGINX**: Serves as the only entry point, handling HTTPS requests over TLS v1.2 or v1.3.
- **WordPress + PHP-FPM**: A containerized WordPress instance, optimized for performance, without a web server included to ensure modularity.
- **MariaDB**: Provides the database backend for WordPress, stored in a dedicated Docker volume.
- **Volumes**: Persistent storage for WordPress files and the MariaDB database.
- **Docker Network**: A private network ensuring secure communication between services.

## Features

- **Containerization with Docker Compose**: Each service runs in its dedicated container, designed with Alpine Linux for lightweight efficiency.
- **Security and Stability**: TLS-secured entry via NGINX, configured to restart containers automatically in case of failure.


## Prerequisites

- **Docker & Docker Compose**: Ensure Docker and Docker Compose are installed on your system.
- **Domain Name**: Point your domain name to your VM’s public IP address.
- **Environment Variables**: Set environment variables in a `.env` file for credentials and configurations (details below).

## Getting Started
1. Clone the repository
2. Configure environment variables (a dummy one is included for reference)
3. Build and run
     Use the `Makefile` to build the containers , it will create and start all services defined in the docker-compose.yml
5. Access the application
     `https://localhost:443`

## Repository Structure
```Plain text
.
├── Makefile            # Automates the build and setup process
├── docker-compose.yml  # Defines services, networks, and volumes
├── .env                # Template for environment variables
└── srcs
    ├── nginx           # NGINX configuration
    ├── wordpress       # WordPress configuration
    └── mariadb         # MariaDB configuration
```
## Project Details

- **NGINX**: Configured to serve traffic only over HTTPS with TLS v1.2 or v1.3.
- **WordPress**: Running with PHP-FPM, it is stored on a persistent volume to ensure data durability.
- **MariaDB**: A separate container with a dedicated volume to store the WordPress database, ensuring data persistence and reliability.
- **Restart Policies**: Containers are set to restart automatically, ensuring uptime and resilience in case of errors.

## Deployment

The Inception project is deployed on an Oracle Cloud virtual machine with a custom domain, providing a live, accessible demonstration of the setup. This configuration, leveraged as my  [portfolio](https://portfolio.clerc.fi), is manually set up and managed without automated deployment processes.

## Future Enhancements

Potential improvements include:

- **Redis Caching**: Adding Redis to improve WordPress performance.
- **FTP Server**: Setting up an FTP server for direct access to WordPress files.
- **Automated Deployment**: Implementing automation for the deployment process on Oracle Cloud.

### Sample Automated Workflow

1. **Provision Infrastructure**: Use Terraform to automate resource provisioning.
2. **Configuration Management**: Automate instance and container setup with Ansible playbooks.
3. **CI/CD Pipeline**: Set up a CI/CD pipeline using GitHub Actions for streamlined deployment and updates.
4. **Container Deployment**: Deploy services using Docker Compose.





