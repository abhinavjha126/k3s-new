#!/bin/bash
set -e
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.21.5+k3s1" K3S_TOKEN="k3scentral" sh -s - --cluster-init  \
--node-ip="10.100.0.10" \
--node-label="device.k3s.redcarpetup.com/roles=master" \
--node-name="ip-10-100-0-10" \
--tls-san="10.100.0.10" \
--tls-san="ip-10-100-0-10" \
--flannel-backend=none \
--disable-network-policy \