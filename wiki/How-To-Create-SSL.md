# How to Create Self-Signed SSL certifilcates

1. genrate key

    openssl genrsa 1024 > server.key

2. create csr

    openssl req -new -key server.key > server.csr

3. create crt

    openssl req -x509 -days 365 -key server.key -in server.csr > server.crt

4. view key and crt

    openssl rsa -noout -text -in server.key

    openssl x509 -noout -text -in server.crt

5. verify crt

    openssl verify server.crt   # self signed certificate

> If from CA, use openssl verify -CAfile cacert.pem certfromca.crt, OK.

## Addtion

1. remove passphrase

    cp server.key server.key.org

    openssl rsa -in server.key.org -out server.key
