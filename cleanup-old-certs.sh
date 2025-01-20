# Cleanup old certs
echo "Cleaning Up Old Certificates"
rm -rf *.pem; rm -rf *.crt; rm -rf *.csr; rm -rf *.key; rm -rf ca-pem; rm -rf *.srl
kubectl delete cm custom-ca
kubectl delete secret my-replica-sample-cert my-replica-sample-agent-certs my-replica-sample-cert-pem 
