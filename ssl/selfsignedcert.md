# Steps to Create a Self-Signed SSL Certificate and CA

### 1. Create the CA Private Key
This private key will be used to sign your certificates.
```
openssl genpkey -algorithm RSA -out /etc/nginx/ssl/ca.key -aes256 -passout pass:yourpassword
```
The -aes256 is optional; it encrypts the private key with a password (yourpassword). You can change the password to your preferred one.

### 2. Create the CA Certificate
Now that you have the private key, create the self-signed CA certificate:
```
openssl req -new -x509 -key /etc/nginx/ssl/ca.key -out /etc/nginx/ssl/ca.crt -days 3650 -passin pass:yourpassword
```
* The -days 3650 option makes the certificate valid for 10 years. Adjust this as per your needs.
* This will generate the ca.crt, which is your self-signed CA certificate.

### 3. Generate the SSL Certificate:
Run the following commands to generate a self-signed SSL certificate:
```
# Generate a private key
openssl genpkey -algorithm RSA -out /etc/nginx/ssl/selfsigned.key

# Generate a self-signed certificate, not needed if using csr with ca signed certificate.
openssl req -new -x509 -key /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt -days 365
```
During the process, you'll be asked to provide information like your country, state, and organization. You can fill these out or just press Enter to skip.

### 4. Create a Certificate Signing Request (CSR)
```
openssl req -new -key /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.csr

```
  You'll be prompted to enter the details for the certificate. These should match the intended values for the certificate you want to sign.

### 4. Sign the CSR Using Your CA
Now you can sign the CSR with your own CA:
```
openssl x509 -req -in /etc/nginx/ssl/selfsigned.csr -CA /etc/nginx/ssl/ca.crt -CAkey /etc/nginx/ssl/ca.key -CAcreateserial -out /etc/nginx/ssl/selfsigned_with_ca.crt -days 365 -passin pass:yourpassword
```
* The -CAcreateserial option will create a serial number file (it’s required by OpenSSL for managing certificate serial numbers).

* The output will be the signed certificate, selfsigned_with_ca.crt.

### 5. Verify the Signed Certificate
You can verify that the certificate has been signed by your CA with the following command:
```
openssl x509 -in /etc/nginx/ssl/selfsigned_with_ca.crt -noout -issuer -subject
```

### 6. Install the CA Certificate
If you plan to use this certificate for a system or browser, you will also need to install the ca.crt (the certificate of your own CA) into the trusted root certificates store for the systems or browsers to trust your signed certificate.

On Linux, you can add the CA certificate to the trusted store with:
```
sudo cp /etc/nginx/ssl/ca.crt /usr/local/share/ca-certificates/ca.crt
sudo update-ca-certificates
```
### 7. Use the Signed Certificate in Nginx
Once you have the signed certificate, you can configure Nginx to use it. For example:

```
server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/nginx/ssl/selfsigned_with_ca.crt;
    ssl_certificate_key /etc/nginx/ssl/selfsigned.key;
    ssl_trusted_certificate /etc/nginx/ssl/ca.crt;

    # Other Nginx configurations...
}
```
