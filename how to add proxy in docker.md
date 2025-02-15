# How to add squid proxy in docker 

### Step 1: Configure Docker to Use the Proxy
-> Create or edit Docker's systemd service drop-in directory to set proxy settings.
```
sudo mkdir -p /etc/systemd/system/docker.service.d
```
-> Create a file for Docker's proxy settings.
```
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```

-> Add the following content to configure the proxy for Docker.
```
[Service]
Environment="HTTP_PROXY=http://<prooxy-server-ip>:3128/"
Environment="HTTPS_PROXY=http://<prooxy-server-ip>:3128/"
Environment="NO_PROXY=localhost,127.0.0.1"
```
Note: <prooxy-server-ip> is ip of the server on which the squid isconfigure and 3128 (default) is port of squid 

-> If the Squid proxy uses authentication (username and password), update the configuration as.
```
Environment="HTTP_PROXY=http://<username>:<password>@<prooxy-server-ip>:3128/"
Environment="HTTPS_PROXY=http://<username>:<password>@<prooxy-server-ip>:3128/"
```
### Step 2: Reload and Restart Docker
-> Reload systemd to recognize the new configuration and restart docker service.
```
sudo systemctl daemon-reload
sudo systemctl reload docker
```
