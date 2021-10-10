# ubi8-php-builder

[![Container Image on Quay](https://img.shields.io/badge/Container%20Image-Quay.io-orange)](https://quay.io/polyglotsystems/ubi8-php-builder) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/PolyglotSystems/ubi8-php-builder/Build%20PHP%20UBI%20Container?label=Container%20Build&style=flat-square) ![GitHub](https://img.shields.io/github/license/PolyglotSystems/ubi8-php)-builder ![GitHub release (latest by date)](https://img.shields.io/github/v/release/PolyglotSystems/ubi8-php-builder)

A PHP builder container based on RHEL UBI 8.

This container image is available on Quay and should be a drop-in builder image for PHP based applications which can then be slimlined into other PHP runtime images.

## Pulling the Container

```bash
podman pull quay.io/polyglotsystems/ubi8-php-builder:latest
# or
docker pull quay.io/polyglotsystems/ubi8-php-builder:latest
```

## Tags

- `main`, `:latest`, `:7.4`, `:7.4.6`, `:v7.4.6`

## Using this Container as a Base

```docker
FROM quay.io/polyglotsystems/ubi8-php-builder:latest

COPY ./my-php-app /var/www/html
# Add extra builder files
# COPY builder-root/ /
# Add Git checksum for referencing
# COPY .git/refs/heads/main /var/www/html/storage/.gitchecksum
```

## Using this Container via Podman

```bash
sudo podman run --name ubi8-php-builder --rm -p 8080:8080 -v ./my-php-app:/var/www/html quay.io/polyglotsystems/ubi8-php-builder:latest /var/www/html/my-build-script.sh
```

# Licenses

- The Red Hat Universal Base Image is covered by [its own EULA](https://www.redhat.com/licenses/EULA_Red_Hat_Universal_Base_Image_English_20190422.pdf)
- PHP is covered by [its own license](https://www.php.net/license/) as well
- Custom authored work in this repository is otherwise covered by the MIT license found in the file `LICENSE`