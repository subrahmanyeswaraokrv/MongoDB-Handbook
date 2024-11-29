Objective
The main goal of this document is to create a comprehensive guide to ensure a smooth setup of MongoDB replication with a 3-node configuration. This document serves as a reference for both developers and administrators involved in the process. It provides detailed steps for setting up and configuring a 3-node replica set in MongoDB on an Ubuntu environment and should be used as a reference for future replication setups.
Scope of this Document 
This document aims to provide a step-by-step guide for setting up a MongoDB replica set with three nodes, ensuring secure authentication and seamless replication. The scope includes:

 Installation:
Installing MongoDB on Ubunt
Configuring custom data and log directories
Enabling Authentication:
Steps to enable authentication in MongoDB
Creating an admin user

Configuring Replica Set:
Setting up keyFile for internal authentication
Configuring each node in the replica set
Initializing the replica set

General Description
This document provides a comprehensive guide to setting up MongoDB replication with a 3-node configuration on an Ubuntu environment. It is intended for developers and administrators who need to ensure a reliable and secure MongoDB setup. The guide covers the following key areas:
Installation and Configuration
Authentication Setup
Replica Set Configuration
Verification and Maintenance
Additional Considerations
Make sure the mongo_keyfile should  generated with suggested permisions 
And can copied to all replica members.
In config file replicaset name should be same for all 3 nodes of the set.
Rs.initiate() command should be run on the primary once.
Make sure to add secondary nodes and port number s

Conclusion 

Setting up MongoDB replication is a powerful way to ensure data availability, fault tolerance, and redundancy in your MongoDB deployment. Replication provides high availability and automatic failover, making it a crucial component of any robust database infrastructure.
References
https://www.mongodb.com/docs/manual/administration/replica-set-deployment/ 
https://github.com/subrahmanyeswaraokrv/MongoDB-Handbook/tree/main/MongoDB%20High%20Availability%20Replication 
