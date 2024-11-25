## remove container logs
```
sudo find /var/lib/docker/containers/ -name *-json.log -exec truncate -s 0 {} \;
```
