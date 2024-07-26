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


# Really helpful resources

https://devopscube.com/aws-cloud-controller-manager/

https://github.com/antonbabenko/terraform-best-practices/blob/master/examples/medium-terraform/stage/variables.tf
