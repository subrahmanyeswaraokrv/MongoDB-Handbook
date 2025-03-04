# Migration of MongoDB (On-prem) to MongoDB Atlas (Cloud) and Configurations

![MongoDB Data Migration](https://github.com/subrahmanyeswaraokrv/MongoDB-Handbook/blob/main/MongoDB%20Data%20Migration%20On-Prem-to-Atlas/screen1.jpg?raw=true)

This article will show how to configure MongoDB Atlas from scratch, its features, and different ways to migrate data from on-prem to Atlas cloud.

Recently we migrated mongodb on-prem(mongodb was running in Linux VMs containers) to their cloud provision i.e., Mongo Atlas for the data intensive application for one of the energy client, where we used to maintain data loads in Azure VM and migrated it to Mongo Atlas. Mongo Atlas is advantageous as below are benefits of migration, Atlas provides so many out-of-the-box features like - change stream, database logging and it’s very easy to auto scale cluster.  Access control, VPC peering, IP whitelists can be configured easily in Atlas. Field level encryption, data encryption in transit & rest are also provided by default.

We have migrated to Mongo Atlas because costing to manage the same data load in on-prem was much more than the cost what we are paying for mongo Atlas now. In on-prem server we had to implement all security features, but Atlas provides so many security features by default. Earlier we had custom application to handle change management but in Atlas we leveraged change stream feature. Indexing and logging features are also better in Atlas.   

Here is the detailed guide for migrating MongoDB from On-Prem to Cloud.
I will show how to set up a NoSQL cloud database using MongoDB Atlas, configuration of clusters, security measures, data migration from on-prem server to Mongo Atlas, change stream in Mongo Atlas, database auditing, database logging and alerting etc.

Features of MongoDB Atlas

Cloud based service
MongoDB Atlas is a cloud provider PaaS service that allows users to run the database on a cloud like AWS, Azure, and GCP.

Scalability & high availability
Atlas can scale up and down the compute power of Atlas cluster very easily with few clicks or auto scaling can be configured.

High Performance
MongoDB Atlas uses WiredTiger storage engine which gives high performance for any kind of database need.

Data encryption
WiredTiger storage engine by default encrypt the data before storing it into disk. We can create and configure our own key to do doubt encryption. There are two types of encryption Atlas provides – Encryption at transit & Encryption at rest.

Strong Security Measures
Atlas has its own tight security, but you can configure extra security on top of that to make your cluster more secure and according to your organization’s policy. We will look into this feature in detail.

Set up & configure Mongo Atlas cluster

MongoDB Atlas is one PaaS service where you need to create cluster that will hold the databases.  To create cluster from scratch, follow the steps below:

Signup in Mongo Atlas from - https://account.mongodb.com/account/login
![MongoDB Data Migration](https://github.com/subrahmanyeswaraokrv/MongoDB-Handbook/blob/main/MongoDB%20Data%20Migration%20On-Prem-to-Atlas/screen2.png?raw=true)
2. After Signup and validating email, you will have to fill some basic details like below.


3. There are three types of clusters available in Atlas – Serverless, Dedicated, Shared (Just for learning purpose). There are some limitations like private endpoint can’t be configured with serverless instance. Find more info here, https://www.mongodb.com/cloud/atlas/serverless

Select cloud provider, region, cluster Type (M0 will be free), MongoDB version, cluster name etc.

One cluster will be created, and it looks like below.


4. Next step is to create database user. Click on Database Access option from left side bar and click on Add New database User. There will be three types of authentication mechanism (password, certificate, AWS IAM). Now create user with specific role you want.


5. To access the Atlas cluster there are three options as of now.

IP whitelisting: We add the IPs (public IP) of the machine from where the cluster will be accessible.
Peering: We can peer our application VPC /VNet to access the cluster which are hosted in Azure / AWS / GCP.
Private Endpoint: We can use our existing private link of cloud to give access of the cluster.
Go to Network Access from left side pane, we can see all the three options like below.


Connect to Atlas cluster from IDE / Application

Now the basic configuration of the Atlas cluster is in place. If you want to connect the cluster, need to do the following step.

From the cluster view click on Connect It will show all the connect type we have configured. (I have configured private endpoint hence it is showing here) and click on Choose a connection method. If you configure private endpoint then only choose that option else go for Standard Connection.

Once you choose the connection method, it will give connection string like below to connect from MongoDB compass / Shell or application or BI connector. 

mongodb+srv://<username>:<password>@azrxxxxxxxx-pl-0.os3dd.mongodb.net/myFirstDatabase?retryWrites=true&w=majority

Backup & Restore in Mongo Atlas

Backup and restore can be done from Atlas GUI portal from command prompt. We can take backup of all databases in one cluster or particular one database.
We need to set the backup policy first for our cluster.

From Atlas GUI:
1. Setup backup policy. From Atlas home page click on browse Collection, then click on Backup and one option will be there called Backup Policy. From Backup Policy configure backup frequency & retain policy for the cluster.

Depending upon your frequency, backup will be taken automatically and that will be in Snapshots tab.



2. We can restore the backups from into any target Atlas cluster by clicking Restore button under Snapshots tab.

Backup & restore using command:

We can use mongodump & mongorestore to take backup and restore respectively.

Find the commands here - https://docs.mongodb.com/manual/tutorial/backup-and-restore-tools/

Data migration from on-prem server to Atlas

Scenarios may come where we need to migrate on-prem data to Atlas. We can avail two options.

Live Migration
Mongo Mirror
Live Migration: Atlas can perform a Live Migration of a source replica set to an Atlas cluster, keeping the cluster in sync with the remote source until you cut your applications over to the Atlas cluster.    We can avail this feature when our Atlas cluster size is greater than M5.

Live Migration does not support VPC peering or private endpoints for either the source or target cluster.

If we are not using VPC / private endpoint we can do migration to mongo atlas from on-prem database server. Find the steps to do live migration.

Click on three dots (…) of your cluster then click on Migrate data to this cluster. Then select General Live Migration / Migrate from Ops Manager. Configure the source server properly and click on Start Migration.

2. Cutover – Then optime gap reaches zero for Live Migration that means your own cluster & Atlas are in sync. Click on Prepare to Cutover. Stop your application, change the connect string in application & restart the containers / applications. Test if the application is working properly or not, then click on Cut Over to finish the migration.

Mongo Mirror: If we are using private endpoint, we have to migrate the data in Atlas using one tool called mongo mirror.  We need to install the tool in source server and need to run the below command to migrate the data.

Download the tool from https://docs.atlas.mongodb.com/import/mongomirror/ for your source operating system and run the below command.
mongomirror --host "sourceReplicaSet/azrxxx.yyyy.azr.zzz.com:27017,azraaa.bbbb.azr.ccc.com:27017,
azrqqqq.eeee.azr.rrrr.com:27017" --username 'admin' --password 'passwordforAdminUser' --authenticationDatabase 'admin' --destination "atlasReplicaSet/pl-1-westeurope-azure.1d3dx.mongodb.net:1011,pl-1-westeurope-azure.1d3dx.mongodb.net:1012,pl-0-westeurope-azure.1d3dx.mongodb.net:1013" --destinationUsername 'admin' --destinationPassword 'passwordforAtlasAdminUser' --includeNamespace 'abc.xyz'

 

Migration will be started. In the O/P window you can see that status of that and if the source and target application is in full sync.
2. Cutover - Then optime gap reaches zero for Live Migration that means your own cluster & Atlas are in sync. Stop your application, change the connect string in application & restart the containers / applications. Test if the application is working properly or not. Stop the mongo mirror tool.

Note: We can do reverse mirroring to migrate data from Atlas to on-prem server.



Monitoring Metric

For monitoring the whole cluster about OpLog, IPOS, Latency, CPU usage etc, mongo Atlas allows us to enable the metrics.
We can do that from Browse Collection ->  Metrics . Find the screenshot below.


Configuration of Alerts in Atlas

We can configure Atlas alert either at project level or organization level for mongoDB Atlas cluster.

Configuration of alert at organization level:

Go to the below path to configure alert at organization level.


Access Manager (Select Org) -> Alerts -> Add Alert -> Select Target(User / Billing) & Condition for triggering the alert -> Add Notification Method -> Configure notification method -> Create

Step 1: Select Target
Step 2: Select Condition
Step 3: Add Notification Method (There are different ways where the alerts can be sent). The below image shows the different notification method where alerts can be sent once the condition will be executed.
Step 4: Need to configure the notification method & create the alert


Configuration of alert at project level:

At project level we can configure alert for so many targets like – Host, Replica Set, Shared cluster, cloud backup, User, Project, Billing, Encryption Key & Authentication.

Access Manager (Select Org) -> Alerts -> Add -> New Alert -> Select TARGET & Conditions -> Configure whom to send alert (select Roles) -> Select Medium to send(Email / SMS) -> Save


Logging of Atlas Cluster

We can get logs of Altas cluster by using multiple APIs provided by mongoDB. To get different alert info & logs, we will have to enable the API keys from the settings.

To enable API keys, we shall have to go to the below path to enable public IP Access List.

Org Settings -> We need to turn on Require IP Access List for the Atlas Administration API


Now we need to add public & private keys. Go to the below path to add that,

Access Manager -> API Keys -> Create API Keys (Need to keep the record of the private key because it will be shown once for the first time).

While creating the API keys, we will have to filter the IP, from where it is expected the API will be invoked.


We can invoke the APIs and get different kind of logs. And we can orchestrate these APIs for live log aggregation with any cloud log aggregator.

Get all Atlas MongoDB processes for the specified project.

> curl -i -u "{PUBLIC-KEY}:{PRIVATE-KEY}" --digest https://cloud.mongodb.com/api/atlas/v1.0/groups/{GROUP-ID}/processes?pretty=true

The request & response format referenced at https://docs.atlas.mongodb.com/reference/api/processes-get-all/

Get compressed Log

 To get a compressed (.gz) log file that contains a range of log messages for a particular host in an Atlas cluster, we can use another API.

> curl --user '{PUBLIC-KEY}:{PRIVATE-KEY}' --digest \

 --header 'Accept: application/gzip' \

 --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/{GROUP-ID}/clusters/{HOSTNAME}/logs/mongodb.gz" \

 --output "mongodb.gz"


If we want more info regarding database, measurement, disk info we can consume different APIs.

https://docs.atlas.mongodb.com/reference/api/monitoring-and-logs/

Change Streams

Change stream  feature  was introduced in MongoDB version 3.6 which  captures the real-time data change. This can be used to capture the data change of single collection, a database, or an entire cluster but we can’t put change stream for System collection or any collection of the admin, local or config database.
This is super helpful in event driven architecture, real time data analysis or firing notification for any change.

Advantages:

Easy to do the integration
Reduce development effort
Reduce infra cost
Capture real-time data change
We can enable change stream at any point because for each change unique id is mentioned.
There are many advantages of mongo change stream over Custom change management. Find the differences below.

MongoDB change stream
1. Can be provisioned quickly
2. In-built feature
3. Very less maintain cost
4. No Extra deployment cost
Custom change management
1. Lot of development effort
2. Need to create custom application
3. Higher maintenance cost to handle the infrastructure
4. Extra deployment cost


Change stream can trigger for the below Event –

Insert Event
Update Event
Delete Event
Drop Event
Drop database Event
If anything is changed on the collection, database or cluster, how the change stream is configured, one event will be raised to capture the changes. The generic response document looks like below.


To capture changes, we can open a change cursor using .watch() function on collection, or database or whole cluster.

For collection:collection.watch()
For whole database: db.watch()
Whole deployment: mongo.watch()
One small application can be created to capture the changes and for further processing.

Ex – Send any stream data to event grid, store the changes in another database, send the changes into any log aggregator (ex – Azure log analytics workspace) for further alerting or tracing.


Database Auditing
This is the process of track activity on any cluster. This is used by admin persons to track the defined operation for further analysis.
Database auditing allows to customize log downloads with the users, groups, and actions we want to audit. This can capture failed and successful logins, which user is reading or writing data into database etc. There are many events (authCheck, authChecksReadAll, authChecksWriteFailures, authChecksWriteAll) which are used to capture all these auditing info.

This process charges certain cost for these operations. If we enable this, the cluster pricing will  increase.

Steps to enable Database auditing

Login into Mongo atlas web( https://cloud.mongodb.com/)
2. In Security section go to Advance. ‘Advanced’ window will be open and one option will be there called ‘Database Auditing’.


3. Select database users or roles, LDAP groups which you want to audit
4. Select the events you want to audit.

Click on ‘Save’.
