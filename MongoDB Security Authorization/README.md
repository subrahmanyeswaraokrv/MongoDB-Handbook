Objective
The main goal of this document is to provide a detailed guide for enabling MongoDB security authorization. It outlines the step-by-step configuration settings necessary to set up a secure MongoDB environment.
This document also provides comprehensive instructions for enabling security for MongoDB databases. It should be used as a reference for both configuration and for creating users and roles based on best practices.

Scope of this Document 
This document covers the procedures and configurations required to enable and manage security authorization in MongoDB. It includes detailed instructions on:

Configuring MongoDB to enable authentication and authorization.
Setting up user roles and permissions based on best practices.
Enabling and managing secure access to MongoDB databases.
Implementing necessary security measures for protecting sensitive data.

The document is intended for system administrators, database administrators, and security professionals who need to configure and maintain a secure MongoDB environment. It does not cover general MongoDB setup or non-security-related configurations.
General Description
MongoDB is a widely used NoSQL database that provides high performance, scalability, and flexibility. As with any database, securing MongoDB is essential to protect sensitive data and ensure that only authorized users have access to critical information.
This document provides a comprehensive guide to enabling and configuring security features in MongoDB, focusing on authentication and authorization mechanisms. It covers the necessary steps to configure role-based access control (RBAC), enable secure connections, and implement best practices for user and data security.
By following the instructions in this guide, administrators can ensure that MongoDB is configured to meet organizational security standards, preventing unauthorized access and ensuring compliance with security policies.

Manage Mongo Service 
venkata@dev-mongodb-poc1:~$ sudo systemctl restart mongod
venkata@dev-mongodb-poc1:~$ mongosh
Current Mongosh Log ID: 6746f6eb723a366acac1c18b
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/
test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication
test>

Connect to Mongo using Authentication 
venkata@dev-mongodb-poc1:~$ mongosh -u superAdmin -p
Enter password: **********
Connecting to:          mongodb://<credentials>@127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMUsing MongoDB:          8.0.3
Using Mongosh:          2.3.3
For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/
test> show dbs
admin   132.00 KiB
config   48.00 KiB
local    72.00 KiB
test> exit
venkata@dev-mongodb-poc1:~$
Conclusion 
By following these steps, we should enable security for the mongo databases . 

Reference URL:
Conclusion 
By following these steps, we should enable security for the mongo databases . 

Reference Documents
https://www.mongodb.com/docs/manual/tutorial/configure-scram-client-authentication/ 
https://github.com/subrahmanyeswaraokrv/MongoDB-Handbook/tree/main/MongoDB%20Security%20Authorization 

