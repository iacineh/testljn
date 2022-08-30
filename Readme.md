# TEST LJN
***
## First step

Create the cluster kubernetes with terraform
```
$ export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxx" 
$ export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxx" 
$ cd eks-cluster
$ terraform init
$ terraform plan
$ terraform apply
```

## Second step:

### applications:
configure kubectl.
```
$ aws eks --region us-east-1 update-kubeconfig --name eksprod
```
applications common on all namespace

ingress:
```
$ cd app/app-common
$ terraform init 
$ terraform plan
$ terraform apply
```


### install app ljn
```
$ timestamp="$(date +%F)"
docker login -u $USER -p $PASSWORD
Docker build -t iacine/jln:$timestamp
docker push

$ cd app/ljn
sed -i "s/TAG/$timestamp/g" ./ljn/values.yaml
$ helm upgrade --install -f ./ljn/values.yaml helloljn ./ljn --create-namespace $branch-name
```

### update app ljn new tag


## CI/CD
```
 CI steps:
 $ docker login -u $USER -p $PASSWORD
 $ docker build -t iacine/jln:$timestamp
 $ docker push
 $ timestamp="$(date +%F)"
 $ Docker build -t iacine/jln:$timestamp

```
CD
```
$ cd app/ljn
$ sed -i "s/TAG/$timestamp/g" ./ljn/values.yaml
$ helm upgrade --install -f ./ljn/values.yaml helloljn ./ljn --create-namespace $branch-name
```
But the best way is to use ARGOCD of Flux it's very cool sotfware.
