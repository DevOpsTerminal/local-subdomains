# Local Development with Subdomains using Traefik and vcap.me

This project sets up a local development environment with multiple subdomains using Traefik as a reverse proxy and vcap.me for local domain resolution.

## Features

- Local development with subdomains (e.g., app1.vcap.me, app2.vcap.me)
- Easy switching between development and production environments
- Automatic SSL certificate management (when configured for production)
- Simple Makefile commands for common tasks

## Prerequisites

- Docker and Docker Compose installed
- Make utility (usually pre-installed on Linux/macOS)

## Getting Started

1. Clone this repository
2. Start the development environment:
   ```bash
   make dev
   ```
3. Access your services at:
   - http://app1.vcap.me
   - http://app2.vcap.me

## Environment Management

- `make dev` - Start development environment (uses .env.dev)
- `make prod` - Start production environment (uses .env.prod)
- `make stop` - Stop all services
- `make status` - Check service status

## Configuration

- `.env.dev` - Development environment variables
- `.env.prod` - Production environment variables
- `docker-compose.yml` - Main Docker Compose configuration

## Adding New Services

1. Add a new service to `docker-compose.yml`
2. Add the appropriate Traefik labels for routing
3. Update the environment files with the new domain
4. Restart the services

## Testing with Ansible

This project includes Ansible tests to verify the subdomain configuration. The tests check if all configured subdomains are accessible and return the expected HTTP status code.

### Prerequisites

- Ansible 2.9 or later
- Python 3.6 or later

### Running Tests

1. Install the test dependencies:
   ```bash
   pip install -r tests/ansible/requirements.txt
   ```

2. Make sure your services are running:
   ```bash
   make dev
   ```

3. Run the Ansible tests:
   ```bash
   cd tests/ansible
   ansible-playbook playbook.yml
   ```

### Test Configuration

You can modify the test configuration in `tests/ansible/playbook.yml`:

```yaml
vars:
  test_domains:
    - "app1.vcap.me"
    - "app2.vcap.me"
  expected_status: 200
```

## Troubleshooting

### Domain Resolution Issues

If domains don't resolve, try these solutions:

1. **For vcap.me/localhost resolution issues**:
   - Ensure your `/etc/hosts` includes:
     ```
     127.0.0.1 app1.vcap.me app2.vcap.me
     ```

2. **DNS Rebinding Protection**:
   If your network blocks resolving domains like vcap.me:
   - Check your router settings for "DNS rebinding protection" and disable it if needed
   - Try using alternative DNS servers like Cloudflare (1.1.1.1) or Google DNS (8.8.8.8)
   - Configure a custom domain with a wildcard A record pointing to 127.0.0.1

3. **Service Logs**:
   ```bash
   docker-compose logs <service_name>
   ```

## Recommended Approach

For the best development experience, we recommend using `localtest.me` with environment variables because:

✅ **No docker-compose.yml modifications needed** - All changes are in `.env` files  
✅ **No hosts file editing required** - localtest.me works out of the box  
✅ **Identical domain structure** - Use the same URL structure across environments  
✅ **Quick setup** - Just update the `.env` file  
✅ **Subdomain support** - Wildcard subdomains work automatically

### Usage Example:

```bash
# Development
cp .env.dev .env
docker-compose up -d

# Production  
cp .env.prod .env
docker-compose up -d
```

This approach offers maximum flexibility with minimal configuration complexity and requires no modifications to the main `docker-compose.yml` file.