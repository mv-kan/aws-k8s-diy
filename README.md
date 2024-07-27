# AWS DIY EC2 K8S

## Manual Action

This is not automatic setup, so some manual intervention is needed

in worker node:
```
# search in master node machine in /var/log/user-data.log string that connects worker node with master node
# command should look like this 
# kubeadm join 10.20.101.19:6443 --token b6k0io.pztsy3g36y9gpoad \
#        --discovery-token-ca-cert-hash sha256:9554bac76ee33d46f892aa7f434e81c8b478a40fff5425e34d7daee5a8b88c97
# and put these token, ip address and hash to file in worker node at /root/kubeadm-join-config.yaml
# and execute as a root 
kubeadm join --config ~/kubeadm-join-config.yaml
```

## Testing new cluster 
in master node 
```
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3  
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
EOF

kubectl get svc nginx-service
# expected output 
# NAME            TYPE           CLUSTER-IP      
# EXTERNAL-IP                                                                     PORT(S)        AGE
# nginx-service   LoadBalancer   10.101.171.34   aa64c7e28c3384b5598493b6fbb04d4c-f53de39b06106733.elb.us-west-2.amazonaws.com   80:30249/TCP   39s
```
open browser and type external ip (aa64c7e28c3384b5598493b6fbb04d4c-f53de39b06106733.elb.us-west-2.amazonaws.com) address.
You should see Nginx welcome page

# Really helpful resources

https://devopscube.com/aws-cloud-controller-manager/

https://github.com/antonbabenko/terraform-best-practices/blob/master/examples/medium-terraform/stage/variables.tf
