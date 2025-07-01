#!/bin/bash

create_user() {
  user=$1
  group=$2
  sertPath=$2

  # 1. Generate Certificates for the User
  openssl genrsa -out ${user}.key 2048
  openssl req -new -key ${user}.key -out ${user}.csr -subj "/CN=${user}/O=$group"
  openssl x509 -req -in ${user}.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out ${user}.crt -days 365

  # 2. Create a Configuration Specific to the User
  kubectl config set-credentials ${user} --client-certificate=${user}.crt --client-key=${user}.key
  kubectl config set-context ${user}-context --cluster=minikube --namespace=default --user=${user}
}

create_user "devops-user" "devops"
create_user "tech-lead-user" "clients-services"
create_user "developer-user" "clients-services"
create_user "auditor-user" "auditors"