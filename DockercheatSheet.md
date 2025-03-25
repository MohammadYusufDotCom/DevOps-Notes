## Remove container logs
```
sudo find /var/lib/docker/containers/ -name *-json.log -exec truncate -s 0 {} \;
```
## How to run container as root user or non root user
```
docker run -u 0 --privileged --name jenkinstest1 -it -d -p 8090:8080 -p 50000:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/lib/jvm/jdk-1.8-oracle-x64:/usr/lib/jvm/jdk-1.8-oracle-x64 \
-v $(which docker):/usr/bin/docker \
-v  /usr/libexec/docker/cli-plugins:/usr/libexec/docker/cli-plugins \
-v jenkinsvol:/var/jenkins_home \
jenkins/jenkins
```

## How to save and load images 
```t
# docker
docker save -o xxx.tar $imageList
docker load -i  xxx.tar
# containerd
ctr -n=k8s.io image export  xxx.tar  $imageList
ctr -n=k8s.io image import  xxx.tar
```
