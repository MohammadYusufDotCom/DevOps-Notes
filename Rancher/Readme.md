### Run rancher with docker and nginx as loadbalancer
```
docker run -d --restart=unless-stopped \
  -p 3000:80 -p 3001:443 \
   --privileged \
  rancher/rancher:latest --no-cacerts
```
