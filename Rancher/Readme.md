### Run rancher with docker and nginx as loadbalancer
1. install the docker
2. Then run the below command for running rancher
```
docker run -d --restart=unless-stopped \
  -p 3000:80 -p 3001:443 \
   --privileged \
  rancher/rancher:latest --no-cacerts
```
