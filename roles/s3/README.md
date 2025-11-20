# S3 Role

This role sets up an S3-compatible object storage cluster using SeaweedFS, integrated with the OpenConext environment.

## Overview

The role implements a distributed SeaweedFS cluster with the following components:

- Multiple master servers for high availability and coordination
- Multiple volume servers for distributed storage
- Filer server for file metadata and directory structure
- S3 API gateway for S3-compatible access

All services are deployed as Docker containers and integrated with the existing loadbalancer network.

## Requirements

- Docker must be installed on the target machine (handled by the docker role dependency)
- Python with docker module for Ansible

## Configuration

### Main Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `s3_base_dir` | Base directory for S3 installation | `/opt/openconext/seaweedfs` |
| `s3_config_dir` | Directory for configuration files | `{{ s3_base_dir }}/config` |
| `s3_data_dir` | Directory for data storage | `{{ s3_base_dir }}/data` |
| `s3_access_key` | S3 access key for the admin user | `admin` |
| `s3_secret_key` | S3 secret key for the admin user | Generated random string |
| `s3_readonly_access_key` | S3 access key for read-only user | `readonly` |
| `s3_readonly_secret_key` | S3 secret key for read-only user | Generated random string |
| `s3_cors_origin` | CORS origin allowed for S3 API | `*` |
| `s3_filer_domain` | Domain name for the filer service | `filer.{{ base_domain }}` |
| `s3_api_domain` | Domain name for the S3 API service | `s3.{{ base_domain }}` |

## Integration with OpenConext

The S3 role integrates with the existing OpenConext deployment by:

1. Using the same loadbalancer network for container networking
2. Using Traefik for routing requests to the appropriate containers
3. Following the same pattern for container management as other OpenConext roles
4. Sharing the base domain configuration for consistent URL patterns
| `s3_filer_cpu_limit` | CPU limit for filer servers | `1.0` |
| `s3_api_memory_limit` | Memory limit for API server | `512M` |
| `s3_api_cpu_limit` | CPU limit for API server | `0.5` |
| `s3_proxy_memory_limit` | Memory limit for Nginx proxy | `256M` |
| `s3_proxy_cpu_limit` | CPU limit for Nginx proxy | `0.2` |

### S3 Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `s3_address_style` | S3 addressing style | `path-style` |
| `s3_signature_version` | S3 signature version | `v4` |
| `s3_disable_bucket_policies` | Disable bucket policies | `false` |
| `s3_enable_head_dir_object` | Enable HeadDirObject API | `false` |
| `s3_enable_cors` | Enable CORS support | `true` |
| `s3_include_etag` | Include ETag in responses | `true` |
| `s3_multipart_upload_limits_mib` | Maximum multipart uploads in memory | `10000` |
| `s3_max_body_size` | Maximum upload size in Nginx | `500M` |

## Usage

Include the role in your playbook:

```yaml
- hosts: s3_servers
  roles:
    - role: s3
      vars:
        s3_host_address: "s3.example.com"
        s3_admin_key: "your-access-key"
        s3_admin_secret: "your-secret-key"
```

## Accessing the S3 Service

After deployment, the following services will be available:

- S3 API endpoint: http://s3_host_address/
- Master admin UI: http://s3_host_address/master/
- Filer admin UI: http://s3_host_address/filer/
- Volume admin UIs: http://s3_host_address/volume1/, http://s3_host_address/volume2/, etc.
- Management API: http://s3_host_address/api/

Admin UIs require authentication using the configured `s3_auth_user` and `s3_auth_password`.

## Using with AWS S3 CLI

Example configuration:

```bash
aws configure set aws_access_key_id <your-access-key>
aws configure set aws_secret_access_key <your-secret-key>
aws configure set default.region <your-region>
aws configure set default.s3.addressing_style path
aws --endpoint-url=http://s3_host_address s3 ls
```

## License

This role is based on the [SeaWeedFS-HA-Demo](https://github.com/HarryKodden/SeaWeedFS-HA-Demo) repository.
