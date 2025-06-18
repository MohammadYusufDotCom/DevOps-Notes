## Steps to Configure Proxy on CentOS

### Open the terminal on 192.168.1.7 and add the following lines to your /etc/environment file:
```
sudo vim /etc/environment
```
### Add the following lines at the end of the file:
```
http_proxy="http://192.168.1.5:3128"
https_proxy="http://192.168.1.5:3128"
ftp_proxy="http://192.168.1.5:3128"
no_proxy="localhost,127.0.0.1"
```
note : `192.168.1.5:3128` is the IP address and port of your Squid proxy (default port for Squid is `3128`).

### Apply the Proxy Settings:
After editing the /etc/environment file, run the following command to reload the environment variables:
```
source /etc/environment
```

### Set Proxy for YUM/DNF (CentOS):

```
sudo vim /etc/yum.conf
```
Add the following lines to the file:
```
proxy=http://192.168.1.5:3128
```
If your Squid proxy requires authentication (username/password), add the following as well:
```
proxy_username=your_username
proxy_password=your_password
```
### Install Docker (CentOS):
```
 sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```
http_proxy="http://pub-instance:3128"
https_proxy="http://pub-instance:3128"
ftp_proxy="http://pub-instance:3128"
no_proxy="localhost,127.0.0.1"
```
