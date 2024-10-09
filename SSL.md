## how to check certificate of the domain 
```
openssl s_client -connect <your domain>:<port> -showcerts
```

## how to check detail of the cert of the file 
```
openssl s_client -connect lla-dev.finnomo.com:8448 -showcerts
```
