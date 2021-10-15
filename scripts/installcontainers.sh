#!bin/bash
set -e
kubectl create namespace cattle-system
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
#kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yml
#kubectl create namespace cert-manager
#helm repo add jetstack https://charts.jetstack.io
#helm repo update  
#helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4 
#kubectl get pods --namespace cert-manager