#!/bin/bash

cd infra/production

case $1 in
  init)
    terraform init -backend-config=../production.config --upgrade
    ;;
  plan)
    terraform plan --var-file ../production.tfvars
    ;;
  apply)
    terraform apply --var-file ../production.tfvars --auto-approve
    ;;
  destroy)
    terraform destroy --var-file ../production.tfvars --auto-approve
    ;;
  *)
    echo "Usage: ./tf.sh [plan|apply|destroy|state]"
    ;;
esac