## how to check certificate of the domain 
```
openssl s_client -connect <your domain>:<port> -showcerts
```

## how to check detail of the cert of the file 
```
 openssl x509 -in /etc/nginx/certificates/finnomo_com.crt -text -noout
```
