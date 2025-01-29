## How to check certificate of the domain 
```
openssl s_client -connect <your domain>:<port> -showcerts
```

## How to check detail of the cert of the file 
```
 openssl x509 -in /etc/nginx/certificates/ca.crt -text -noout
```

## how to get public key from domain 
```t
openssl s_client -connect mobilemoney-awsprod.payless.africa:8443 -showcerts < /dev/null 2>/dev/null | openssl x509 -pubkey -noout > public_key.pem
 # if you want to encode 
openssl x509 -in <your_crt_file>.crt -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```
cd /home/ussdaps/Install-Client-Certificate-In-Java

SELF SIGNED Certificate
Make sure RSA key size is 4096

Name Certificate with alternative  SAN/IPs.
```
openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout www.example.com-private.key -out www.example.com.crt -days 3650 -subj "/C=IN/ST=UP/L=NOIDA/O=ONE97/OU=SUPERAPP/CN=www.example.com" -addext "subjectAltName = DNS.1:subdomain.example.com,DNS.2:*.example.com,IP.1:10.94.163.97,IP.2:10.94.163.98"
```
IP Certificate with alternative IPs.

```
openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout 10.94.163.97.key -out 10.94.163.97.crt -days 3650 -subj "/C=IN/ST=UP/L=NOIDA/O=ONE97/OU=SUPERAPP/CN=10.94.163.97" -addext "subjectAltName = IP.1:10.94.163.97,IP.2:10.94.163.98"
```
Name Certificate without alternative  SAN/IPs.
```
openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout www.example.com-private.key -out www.example.com.crt -days 3650 -subj "/C=IN/ST=UP/L=NOIDA/O=ONE97/OU=SUPERAPP/CN=www.example.com"
```
IP Certificate without alternative IPs.

```
openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout 10.94.163.97.key -out 10.94.163.97.crt -days 3650 -subj "/C=IN/ST=UP/L=NOIDA/O=ONE97/OU=SUPERAPP/CN=10.94.163.97"
```

CA SIGNED Certificate
Make sure RSA key size is 4096
Generate CSR with alternatives SAN/IP's

```
openssl req -nodes -newkey rsa:4096 -keyout www.example.com-private.key -out www.example.com.csr -subj "/C=IN/ST=UP/L=NOIDA/O=ONE97/OU=SUPERAPP/CN=www.example.com" -addext "subjectAltName = DNS.1:subdomain.example.com,DNS.2:*.example.com,IP.1:10.94.163.97,IP.2:10.94.163.98"
```
Generate CSR without alternatives SAN/IP's

```
openssl req -nodes -newkey rsa:4096 -keyout www.example.com-private.key -out www.example.com.csr -subj "/C=IN/ST=UP/L=NOIDA/O=ONE97/OU=SUPERAPP/CN=www.example.com"
```

Provide the CSR only to CA for generating CA Signed Certificates along with intermediates and root certificates. DO NOT Provide private keys.

Combine/Merge CA signed Domain, root and intermediate certificates in order:
Graphically
Download or import the all certificates as base64

Create a new file, like www.example.com-bundle.crt

Open the file in a text editor

Stack the certificates in the following order:

	Domain certificate
	Intermediate certificate 1
	Intermediate certificate 2
	Root certificate

Save the file

Command
```
cat www.example.com.crt Intermediate1.crt Intermediate2.crt root.crt > www.example.com-bundle.crt
```
Troubleshooting/Useful Commands
To extract the CSR details for verification
```
openssl req -text -in www.example.com.csr
```
Modulus Value Matching with Private Key and SSL/TLS certificate Key Pair
To extract the CSR Modulus:
```
openssl req -noout -modulus -in www.example.com.csr
```
To extract the certificate Modulus:

```
openssl x509 -noout -modulus -in www.example.com.crt
```
To extract the private key Modulus:
```
openssl rsa -noout -modulus -in www.example.com-private.key
```



To extract the expiry dates, common name, other SSL certificate details of a crt file.
```
openssl x509 -text -noout -in www.example.com.crt
```

To extract the expiry dates, common name, other SSL certificate details of a website.
```
openssl s_client -connect www.example.com:443 -showcerts
```
```
openssl s_client -connect www.example.com:443 2>/dev/null | openssl x509 -noout -dates
```
#For IP
```
openssl s_client -connect 10.94.163.97:443 -showcerts
```
```
openssl s_client -connect 10.94.148.76:443 2>/dev/null | openssl x509 -noout -dates
```
# Output of all should be same

To extract the TLS versions & CIPHERS of a SSL configured website for audit/fixes verifications.
```
nmap -sV --script ssl-enum-ciphers -p 443 10.94.163.97
```
# If firewall/any restricted use below command
```
nmap -sV --script +ssl-enum-ciphers -p 443 10.94.163.97
```

Measure TLS connection and handshake time
Measure SSL connection time without/with session reuse:
```
openssl s_time -connect example.com:443 -new
openssl s_time -connect example.com:443 -reuse
```

Roughly examine TCP and SSL handshake times using curl:
```
curl -kso /dev/null -w "tcp:%{time_connect}, ssldone:%{time_appconnect}\n" https://example.com
```

Measure speed of various security algorithms:
```
openssl speed rsa2048
openssl speed ecdsap256
```

Convert between encoding and container formats
Convert certificate between DER and PEM formats:
```
openssl x509 -in example.pem -outform der -out example.der
openssl x509 -in example.der -inform der -out example.pem
```

Combine several certificates in PKCS7 (P7B) file:
```
openssl crl2pkcs7 -nocrl -certfile child.crt -certfile ca.crt -out example.p7b
```

Convert from PKCS7 back to PEM. If a PKCS7 file has multiple certificates, the PEM file will contain all of the items in it.
```
openssl pkcs7 -in example.p7b -print_certs -out example.crt
```

Combine a PEM certificate file and a private key to PKCS#12 (.pfx .p12). Also, you can add a chain of certificates to the PKCS12 file.
```
openssl pkcs12 -export -out certificate.pfx -inkey privkey.pem -in certificate.pem -certfile ca-chain.pem
```

Convert a PKCS#12 file (.pfx .p12) containing a private key and certificates back to PEM:
```
openssl pkcs12 -in keystore.pfx -out keystore.pem -nodes
```

List cipher suites
List available TLS cipher suites, openssl client is capable of:
```
openssl ciphers -v
```
To extract the TLS versions & CIPHERS of a SSL configured website for audit/fixes verifications.

```
nmap -sV --script ssl-enum-ciphers -p 443 10.94.163.97
```
#If firewall/any restricted use below command
```
nmap -sV --script +ssl-enum-ciphers -p 443 10.94.163.97

SSL Pinning
```
```
openssl x509 -in STAR_payless_africa-server.crt -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```
```
openssl s_client -connect mobilemoney-awspprd.payless.africa:443 |openssl x509  -pubkey -noout </dev/null 2>/dev/null |openssl pkey -pubin -outform der |openssl dgst -sha256 -binary |openssl enc -base64

openssl s_client -connect dev.libertyuconnect.com:443 </dev/null 2>/dev/null | openssl x509 -pubkey -noout|openssl pkey -pubin -outform der |openssl dgst -sha256 -binary |openssl enc -base64
```
```
openssl s_client -servername mobilemoney-awspprd.payless.africa -connect mobilemoney-awspprd.payless.africa:443 </dev/null 2>/dev/null |openssl x509  -pubkey -noout |openssl pkey -pubin -outform der |openssl dgst -sha256 -binary |openssl enc -base64

openssl s_client -connect dev.libertyuconnect.com:443 -servername dev.libertyuconnect.com </dev/null 2>/dev/null | openssl x509 -pubkey -noout|openssl pkey -pubin -outform der |openssl dgst -sha256 -binary |openssl enc -base64
```

JAVA Certificate Management
Search all JAVA CACERTs on server
```
find /usr/lib/jvm -iname cacerts*
```
Backup all JAVA running CACERT
```
find /usr/lib/jvm -name "cacerts" -exec bash -c 'cp "$0" "$0"_$(date +%Y%m%d)' {} \;
```
List all installed certificates on JAVA CACERT
```
keytool -list -keystore <cacert file path> -storepass changeit | grep -i aliasname
```
To extract the expiry dates, common name, other SSL certificate details of a particular certificate from JAVA CACERT files. 
```
keytool -list -v -keystore <cacert file path> -storepass changeit -alias <alias-name>
```
To install new certificate on a JAVA CACERT file
```
keytool -import -noprompt  -trustcacerts -file example.crt -alias example.crt-$(date +%Y%m%d) -keystore <cacert file path> -storepass changeit
```
To install new multiple certificates on a JAVA CACERT file using for loop
```
for i in example.crt IntermediateCertificate.crt TrustedRoot.crt;do keytool -import -noprompt  -trustcacerts -file $i -alias $i-$(date +%Y%m%d) -keystore <cacert file path> -storepass changeit;done
```
To install new multiple certificates on multiple JAVA CACERT files using nested for loop
```
for i in example.crt IntermediateCertificate.crt TrustedRoot.crt;do for j in <1st cacert file path> <2nd cacert file path>;do keytool -import -noprompt  -trustcacerts -file $i -alias $i-$(date +%Y%m%d) -keystore $j -storepass changeit;done;done
```
To extract fingerprint from a website to match with locally installed/placed certificates
```
openssl s_client -connect 10.94.137.212:6271 < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin
```

```
keytool -v -list -keystore <cacert file path> -storepass changeit -alias <alias-name>|grep SHA1
```
# For a crt
```
openssl x509 -fingerprint -noout -in example.crt
```

Convert crt files and key file into jks for java process like tomcat
First Combine all the crt files like server, imtermidiate, trustedroot into an single crt file like
```
cat star_startalk_in.crt IntermediateCertificate.crt TrustedRoot.crt >> star_startalk_in.crt2
```
Convert newly generated crt into p12 format like 
```
openssl pkcs12 -export -in star_startalk_in.crt2 -inkey star_startalk_in.key -out star_startalk_in.p12
```
Now convert this newly generated p12 file to jks like
```
keytool -importkeystore -destkeystore web.startalk.in.jks -srckeystore star_startalk_in.p12 -srcstoretype PKCS12 -deststoretype JKS
```
--------------------------------------------------------------------------------------------------------------------------------------------------------------
