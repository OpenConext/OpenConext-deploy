# S3 Role

This role sets up an S3-compatible object storage cluster using SeaweedFS.

## Overview

The role implements a distributed SeaweedFS cluster with the following components:

- Master server for coordination
- Multiple volume servers for storage
- Filer servers for file metadata and directory structure
- S3 API gateway
- Nginx proxy for routing and authentication
- Management API for administration

## Requirements

- Docker and Docker Compose must be installed on the target machine
- Python with docker and docker-compose modules for Ansible

## Configuration

### Main Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `s3_base_dir` | Base directory for S3 installation | `/opt/s3` |
| `s3_config_dir` | Directory for configuration files | `/opt/s3/config` |
| `s3_data_dir` | Directory for data storage | `/opt/s3/data` |
| `s3_log_dir` | Directory for log files | `/opt/s3/logs` |
| `s3_host_address` | Host address for the S3 service | `localhost` |
| `s3_domain_name` | Domain name for the S3 service | `s3.example.com` |
| `s3_admin_key` | AWS access key for the admin user | `AKIAIOSFODNN7EXAMPLE` |
| `s3_admin_secret` | AWS secret key for the admin user | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `s3_auth_user` | Username for HTTP Basic Auth | `admin` |
| `s3_auth_password` | Password for HTTP Basic Auth | `password` |
| `s3_region_name` | AWS region name | `us-east-1` |
| `s3_docker_network_name` | Docker network name | `seaweedfs_network` |
| `s3_volume_count` | Number of volume servers | `3` |
| `s3_filer_count` | Number of filer servers | `1` |

### Resource Limits

| Variable | Description | Default |
|----------|-------------|---------|
| `s3_master_memory_limit` | Memory limit for master server | `1G` |
| `s3_master_cpu_limit` | CPU limit for master server | `1.0` |
| `s3_volume_memory_limit` | Memory limit for volume servers | `1G` |
| `s3_volume_cpu_limit` | CPU limit for volume servers | `1.0` |
| `s3_filer_memory_limit` | Memory limit for filer servers | `1G` |
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
