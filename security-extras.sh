#!/bin/bash
MONGO_INFRA_MINIKUBE_IP=`minikube ip -p opsmanager`
export MONGO_INFRA_MINIKUBE
MONGO_INFRA_MINIKUBE_GLOBAL_API_PUBLIC=`kubectl get secret mongodb-mongo-infra-minikube-admin-key -o jsonpath={.data.publicKey} | base64 --decode`
export MONGO_INFRA_MINIKUBE_GLOBAL_API_PUBLIC
MONGO_INFRA_MINIKUBE_GLOBAL_API_PRIVATE=`kubectl get secret mongodb-mongo-infra-minikube-admin-key -o jsonpath={.data.privateKey} | base64 --decode`
export MONGO_INFRA_MINIKUBE_GLOBAL_API_PRIVATE
export MEKO_namespace=mongodb

echo "How should we connect to Ops Manager from here?"
version_options=("http://192.168.49.2:30100" "http://localhost:8080" "Quit")
select opt in "${version_options[@]}"
do
  case $opt in
      http://192.168.49.2:30100)
      export MONGO_INFRA_MINIKUBE_IP="$MONGO_INFRA_MINIKUBE_IP:30100"
      break
      ;;
      http://localhost:8080)
      export MONGO_INFRA_MINIKUBE_IP=http://localhost:8080
      break
      ;;
      Quit)
      echo "Bye."
      break
      ;;
      *)
      echo "Invalid option"
      ;;
  esac
done

# Create deployment
deployment_options=("Deploy-Secure-Sample" "Deploy-MDB-User" "Quit")
select opt in "${deployment_options[@]}"
do
  case $opt in
      Deploy-Secure-Sample)
      ./create-certificates.sh
      kubectl apply -f deploy-mdb-secure.yaml && echo "Deployed Secure Sample Succesfully"
      break
      ;;
      Deploy-MDB-User)
      kubectl apply -f deploy-mdbu.yaml
      break
      ;;
      Quit)
      echo "Quitting..."
      break
      ;;
      *)
      echo "Invalid option"
      ;;
  esac
done
