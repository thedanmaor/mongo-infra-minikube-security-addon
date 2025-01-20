# Mongo-Infra-Minikube-Security-Addon

## Overview

This is a **security add-on** for the [`mongo-infra-minikube`](https://github.com/karl-denby/mongo-infra-minikube) repository, created by Karl Denby. It is designed to work *on top of* the `mongo-infra-minikube` repository to provide added security configurations.

### Problem this Add-On Solves:

This repository allows you to deploy a **sample replica set** with the following security features enabled:
- **TLS Encryption**
- **Authorization**
- A managed user for **Authentication**

This setup gives you a secure deployment environment for MongoDB, enabling you to reproduce and test secure deployment issues on Kubernetes (K8s).

---

## Usage Instructions

### Important Notes:
- The **default replica set name** is `my-sample-replica`. All certificates and YAML configurations are tied to this naming scheme. If you intend to use a different name, make sure to update it in **all relevant files** across both repositories.

---

### Prerequisites: (Before Using This Add-On)

1. **Clone the Base Repository**:  
   Clone the `mongo-infra-minikube` repository and navigate into its `MEKO-opsmanager` directory:  
   ```bash
   git clone https://github.com/karl-denby/mongo-infra-minikube.git
   cd mongo-infra-minikube/MEKO-opsmanager
   ```

2. **Update MongoDB Versions**:  
   Modify the template files in the `mongo-infra-minikube` repo to use MongoDB version **`8.0.4-ent`** (the defaults are `6.0.0-ent` or `5.0.0-ent`) for both the **AppDB** and the **Replica Set Sample**.

3. **Deploy the Base Cluster**:  
   Execute the `quick-start.sh` script to create the Minikube cluster and deploy Ops Manager + AppDB:  
   ```bash
   bash quick-start.sh
   ```
   - During the setup, **select the following versions** when prompted:  
     - Custom EKO Version: `1.30.0`  
     - Custom Ops Manager Version: `8.0.2`  
   - Note: The deployment process may take **25-35 minutes** to complete.

4. **Port-Forward Localhost Traffic**:  
   To enable access to the cluster, run the following command:  
   ```bash
   kubectl port-forward pod/mongo-infra-minikube-0 8080:8080 2>&1 > /dev/null &
   ```

5. **Deploy the Non-Secure Sample**:  
   Run the `extras.sh` script and select the `Deploy-Sample` option:  
   ```bash
   bash extras.sh
   ```
   - This will create the organization and deploy a **non-secure sample** replica set (takes approximately **10-15 minutes**).

---

### Steps to Enable Security with This Add-On:

1. **Clone This Repository**:  
   Clone the `mongo-infra-docker-security-addon` repository *into the `MEKO-opsmanager` directory* of the `mongo-infra-minikube` repository:  
   ```bash
   git clone https://github.com/thedanmaor/mongo-infra-docker-security-addon.git
   mv mongo-infra-docker-security-addon/* .
   rm -rf mongo-infra-docker-security-addon
   ```

2. **Deploy Secure Sample Replica Set**:  
   Run the `security-extras.sh` script and choose the `Deploy-Secure-Sample` option:  
   ```bash
   bash security-extras.sh
   ```
   - Then delete the non-secure sample pod to expedite the redeployment:  
     ```bash
     kubectl delete pod/my-replica-sample-0
     ```
   - The redeployment process will take approximately **10-15 minutes**.  
   - **Note:** The secure sample is pre-configured to use MongoDB version **`8.0.4-ent`**.

3. **Deploy the MongoDB User**:  
   Run the `security-extras.sh` script again, and choose the `Deploy-MDB-User` option to create a managed MongoDB user:  
   ```bash
   bash security-extras.sh
   ```
   - This process takes approximately **1 minute**.

---

## Cleanup Instructions

1. **Remove the Cluster**:  
   After tearing down the cluster using the base repository's cleanup script:  
   ```bash
   bash clean-up.sh
   ```

2. **Remove Old Certificates**:  
   Clean up the old certificate files to maintain a clutter-free environment:  
   ```bash
   bash cleanup-old-certs.sh
   ```

---

© Dan Maor (2025)
