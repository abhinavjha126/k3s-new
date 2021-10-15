resource "aws_instance" "master" {
  provider = aws
  ami      = var.ami_image
  key_name = aws_key_pair.ssh_key.key_name
  instance_type = var.master_instance_type
  subnet_id = aws_subnet.master_subnets.0.id
  vpc_security_group_ids = [aws_security_group.main.id]
  private_ip = "10.100.0.10"
  #user_data = data.template_file.user_data_master.rendered
  user_data = "${data.template_cloudinit_config.master_config.rendered}"

  root_block_device {
    volume_type = var.master_root_volume_type
    volume_size = var.master_root_volume_size
    delete_on_termination = "true"
  }

  tags = merge(
    {
      Name        = "master0"
      Project     = var.project
      Environment = var.prod_env
      ManagedBy   = "terraform"
    }
  )
}


#data "template_file" "user_data_master_begin" {
#  template = file("cloud-init-master-begin")
#  vars = {
#    ip_address = var.kube_master_ip_address
#    k3s-version = var.k3s_version
#    hostname = var.kube_master_hostname 
#  }
#}

data "template_file" "user_data_master" {
  template = file("cloud-init-master")
}


# Render a part using a `template_file`
data "template_file" "traefik" {
  template = "${file("manifests/traefik-daemon.yml")}"
}
data "template_file" "prod" {
  template = "${file("manifests/prod.yml")}"
}
# Render a part using a `template_file`
data "template_file" "calico" {
  template = "${file("manifests/calico.yml")}"
}
# Render a part using a `template_file`
data "template_file" "k3sinstall" {
  template = "${file("scripts/k3sinstall.sh")}"
}
# Render a part using a `template_file`
data "template_file" "installcontainers" {
  template = "${file("scripts/installcontainers.sh")}"
}
# Render a part using a `template_file`
data "template_file" "prodkey" {
  template = "${file("certs/prod.key")}"
}
# Render a part using a `template_file`
data "template_file" "prodcrt" {
  template = "${file("certs/prod.crt")}"
}
# Render a part using a `template_file`
data "template_file" "stagingyml" {
  template = "${file("manifests/staging.yml")}"
}
# Render a part using a `template_file`
data "template_file" "prometheus-yml" {
  template = "${file("manifests/prometheus.yml")}"
}
# Render a part using a `template_file`
data "template_file" "calico-wireguard" {
  template = "${file("scripts/calico-wireguard.sh")}"
}


# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "template_cloudinit_config" "master_config" {
  gzip          = true
  base64_encode = true

    # upload traefik.yml
  part {
    content_type = "text/cloud-config"
    content      = <<EOF
      #cloud-config
      write_files:
        # bash script to install k3s service
        - path: /tmp/k3sinstall.sh
          encoding: b64
          permissions: 0700
          owner: root:root
          content: |
            ${base64encode(file("scripts/k3sinstall.sh"))}
        - path: /tmp/installcontainers.sh
          encoding: b64
          permissions: 0700
          owner: root:root
          content: |
            ${base64encode(file("scripts/installcontainers.sh"))}
        - path: /tmp/traefik.yml
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("manifests/traefik-daemon.yml"))}
        - path: /tmp/calico.yml
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("manifests/calico.yml"))}
        - path: /tmp/prod.yml
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("manifests/prod.yml"))}
        - path: /tmp/prod.key
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("certs/prod.key"))}
        - path: /tmp/prod.crt
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("certs/prod.crt"))}
        - path: /tmp/staging.yml
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("manifests/staging.yml"))}
        - path: /tmp/prometheus.yml
          encoding: b64
          owner: root:root
          permissions: '0750'
          content: |
            ${base64encode(file("manifests/prometheus.yml"))}
        - path: /tmp/calico-wireguard.sh
          encoding: b64
          owner: root:root
          permissions: '0700'
          content: |
            ${base64encode(file("scripts/calico-wireguard.sh"))}
        # env vars
        - path: /etc/environment
          content: |
            KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
          append: true

            EOF
  }
  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.user_data_master.rendered}"
  }

}


// # Render a part using a `template_file`
// data "template_file" "stagingkey" {
//   template = "${file("certs/staging.key")}"
// }
// # Render a part using a `template_file`
// data "template_file" "stagingcrt" {
//   template = "${file("certs/staging.crt")}"
// }

        // - path: /tmp/staging.key
        //   encoding: b64
        //   owner: root:root
        //   permissions: '0750'
        //   content: |
        //     ${base64encode(file("certs/staging.key"))}
        // - path: /tmp/staging.crt
        //   encoding: b64
        //   owner: root:root
        //   permissions: '0750'
        //   content: |
        //     ${base64encode(file("certs/staging.crt"))}