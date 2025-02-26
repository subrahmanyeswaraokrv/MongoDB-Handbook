# MongoDB SSL/TLS Configuration

## Overview

This repository provides instructions and configurations for setting up SSL/TLS encryption for MongoDB. Enabling SSL/TLS ensures secure communication between MongoDB instances and clients by encrypting data in transit, which is critical for protecting sensitive data and complying with security standards.

**Author**: Subrahmanyeswarao Karri

## Prerequisites

Before setting up SSL/TLS for MongoDB, ensure that you have the following:

- MongoDB installed (Version 4.0 or above)
- OpenSSL installed (for certificate generation)
- Administrative access to the MongoDB server

## Steps to Enable SSL/TLS on MongoDB

### 1. Create SSL/TLS Certificates

MongoDB requires SSL/TLS certificates for encryption. You can use self-signed certificates or purchase certificates from a trusted certificate authority (CA).

#### Generating Self-Signed Certificates with OpenSSL

```bash
openssl genpkey -algorithm RSA -out server.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key server.key -out server.csr
openssl x509 -req -in server.csr -signkey server.key -out server.crt
This will generate the following files:

server.key: The private key
server.crt: The public certificate
2. Configure MongoDB to Use SSL/TLS
To configure MongoDB to use SSL/TLS, you'll need to modify the MongoDB configuration file (mongod.conf) with the following settings:

yaml
Copy
net:
  ssl:
    mode: requireSSL
    PEMKeyFile: /path/to/your/server.crt
    PEMKeyFilePassword: your-password  # if applicable
    CAFile: /path/to/your/CA.crt
PEMKeyFile: Specifies the file containing the certificate and private key.
CAFile: Specifies the Certificate Authority (CA) certificate for verifying client certificates.
3. Restart MongoDB with SSL/TLS
After configuring the SSL/TLS settings, restart MongoDB:


sudo systemctl restart mongod
4. Connect to MongoDB Using SSL/TLS
Once MongoDB is configured with SSL/TLS, you can connect to it securely using the following command:

mongo --ssl --sslCAFile /path/to/CA.crt --sslPEMKeyFile /path/to/client.pem
--ssl: Enables SSL/TLS for the connection.
--sslCAFile: Specifies the CA certificate file for client verification.
--sslPEMKeyFile: Specifies the client's certificate and key.
5. (Optional) Enabling Client Authentication
MongoDB supports client authentication using SSL/TLS. You can configure MongoDB to require clients to present certificates for authentication.

Modify the mongod.conf file with the following settings:

yaml
Copy
security:
  authorization: enabled
  clusterAuthMode: x.509
This will enable authentication using client certificates.

6. Verify the SSL/TLS Configuration
To verify that MongoDB is using SSL/TLS encryption, check the server logs after restarting MongoDB. You should see something similar to:

2024-02-26T12:34:56.789+0000 I NETWORK  [main] SSL support for MongoDB enabled
You can also verify the connection by checking the SSL/TLS status on the MongoDB shell or using a network tool like openssl s_client.

Troubleshooting
Error: SSL certificate validation failed: Ensure that the client certificate is properly signed by a trusted CA, and that the correct CA certificate is provided in the --sslCAFile option.
Error: Cannot start MongoDB with SSL enabled: Double-check the certificate paths and permissions. Ensure MongoDB has access to the necessary certificate files.
Conclusion
Enabling SSL/TLS encryption on MongoDB ensures that your data is transmitted securely between clients and servers. By following the steps outlined in this guide, you can configure MongoDB for secure communications.

For additional details and advanced configurations, refer to the official MongoDB SSL documentation.

Author: Subrahmanyeswarao Karri
Email: [subrahmanyeswaraokarri@gmail.com]
Date: February 2024

This `README.md` file includes essential information on setting up SSL/TLS encryption for MongoDB, from certificate generation to configuration and troubleshooting, and clearly attributes the work to **Subrahmanyeswarao Karri**.

