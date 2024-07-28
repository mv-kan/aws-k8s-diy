# AWS DIY EC2 K8S

THIS IS NOT PRODUCTION READY CLUSTER!!! THIS PROJECT IS JUST FOR DEMONSTRATION PURPOSES.

## Services that is used here

1. EC2 - 1x t3.small, 2x t3.micro (730 hours of t3.micro is free for Free Tier accounts)
2. Elastic IP - 3x 
3. Network Load Balancer - 1x
4. Internet Gateway - 1x 
5. VPC - 1x
6. Subnets in VPC - 3x 

## terraform apply

1. Create terraform.tfvars file in ./env/dev (read readme.md file for more details)
2. get aws credentials, they usually are in form of env variables that you paste to terminal like that 
```
# no worries these are fake and for demonstration purpose only
export AWS_ACCESS_KEY_ID="MEIAAA4DEPXZT7SV3A1Q"
export AWS_SECRET_ACCESS_KEY="BoXYOAqsYXAn+yreulPAkdKo1shAEhnpAFnBvUJA"
export AWS_SESSION_TOKEN="EVkVyk6g5phBvAEvRJjpHXzfiaLJRRThf1iRAxuUqpcAwhCwUqRhtjAjTgCA/0WfPU4VNnLZ1s015JnhBpTMVrMBQW99225Qacxn8q/GGkq1X=W/7EmQ5Bp37FyQHtkdDgiWwfbWswyoyKQIad+UbrkklTbDpB+MyWZdhsqMrWc53OaiwWx6wY/CSWc+A9vAQL/RS9I9Z8jXos4XLiPjORAvKsV908Cj4sNqm3iP1rCw79UjFWrcjpCUINIT5o7EzvmEVAiJMEjsWjwaqkDsfkjgIK3xB48AsOUrE5IAx9viGS+7NSLkzMwG3u5+A6SWK+ywLoWA09LVog1Nir+oX1J5TjIcu9qcDBBpDdVyRdgVdpxHLm5lMWnxX1RGZN6H6w+8TsBqL4B4kDMshVHqRnvkMrGYSejwXlXNixA3Dyzn36AFPN7GTZUOZeA8xNHab9654odgTa5Rf8t5bND47gAL3TwBOfObM4tecqeAoG6eZXwIzL1lJubCAmt2IshBgibXyprJ3=oRrgErGHMULRv+Q9b1Jwvdicw1cZ1sBxRcWmpMOGuAB048oTk69S3GWCIslw4YxbH/VgaVL5ppIpSCi1atEDiEmsq+CLPCrXv6NtqH1zCKgcEL3kOVwBvorRu5feEj3t7laF+sygN+dicwFfyDHkU+YTnlc0HnOF9egUGaZsRiAepPYk56bNtDtKg+/IF4QipuOdorIcn5RKieaf1Ryw221ZsTxztMqr2IDYbkw0WvkYuOEMwllAhZ3RoEGV9btVy/06YRblibnq0TiBsE0moLhBdv5cUrBlW4yNJ3vLm1fkSoL3qLt64cbNZlSq7"
```
3. in ./env/dev apply terraform like that
```
terrafrom apply
```

## Manual Action

This is not automatic setup, so some manual intervention is needed

WARNING: For each worker machine you have to create new tokens

in master node machine:
```
# Example of commands 
[root@hostname ~]# kubeadm token generate
hp9b0k.1g9tqz8vkf78ucwf
kubeadm token generate
[root@hostname ~]# kubeadm token create hp9b0k.1g9tqz8vkf78ucwf --print-join-command
W1022 19:51:03.885049   26680 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
kubeadm join 192.168.56.110:6443 --token hp9b0k.1g9tqz8vkf78ucwf     --discovery-token-ca-cert-hash sha256:32eb67948d72ba99aac9b5bb0305d66a48f43b0798cb2df99c8b1c30708bdc2c

# PRO TIP: You have result of user-data.sh script in master node here /var/log/user-data.log 
```

in every worker node:
```
# kubeadm join 10.20.101.19:6443 --token b6k0io.pztsy3g36y9gpoad \
#        --discovery-token-ca-cert-hash sha256:9554bac76ee33d46f892aa7f434e81c8b478a40fff5425e34d7daee5a8b88c97
# and put these token, ip address and hash to file in worker node at /root/kubeadm-join-config.yaml
# and execute as a root 
kubeadm join --config ~/kubeadm-join-config.yaml

# WARNING: you may need to wait a little bit for user-data.log to fill out with logs
# PRO TIP 2: for worker machines `sudo su` logs into root user 
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

## How to properly delete cluster 

in master node
```
kubectl delete all --all
```
and then in ./env/dev terraform was applied 
```
terraform destroy 
```

# Really helpful resources

https://devopscube.com/aws-cloud-controller-manager/

https://github.com/antonbabenko/terraform-best-practices/blob/master/examples/medium-terraform/stage/variables.tf
