Objective
The main goal of this document is to provide a detailed guide for Install the latest version of MongoDB on Ubuntu 22.04 and configure it 	  with a customized data directory (/mongo/data) and log directory  (/mongo/logs). It outlines the hardware  requirements, step-by-step installation procedures, configuration for setting up a efficient MongoDB environment.

It provides detailed steps to Install mongodb on ubuntu environment. It should be used as a reference for both Installation and configuration Best Practices.
Scope of this Document 
This document provides comprehensive instructions for installing and configuring MongoDB on an Ubuntu 22.04.2 LTS system. It includes the following key sections:

Introduction: An overview of the document's purpose and the context of the MongoDB installation.

Hardware Requirements: Detailed specifications for the minimum and recommended hardware configurations to ensure optimal performance of 	MongoDB.

Installation Steps: Step-by-step procedures for installing MongoDB, including setting up the repository, installing the software, and configuring data and log directories.
General Description
This document serves as a comprehensive guide for installing and configuring MongoDB on an Ubuntu 22.04.2 LTS system. It outlines the necessary steps to ensure a secure and efficient MongoDB environment, including hardware 	requirements, installation procedures, uninstallation.


Hardware Requirements

Minimum Hardware Requirements
64-bit Architecture   :  MongoDB requires a 64-bit processor (Intel x86_64 or AMD 			  		   x86_64).
RAM			:  At least 8 GB of RAM.
CPU			:  A minimum of 4 cores.
Storage		:  20 GB of disk space. It's recommended to use SSDs for better 			  		   performance2.
Operating System	:  MongoDB supports various Linux distributions924.04 LTS 					   ("Noble"),22.04 LTS ("Jammy"),20.04 LTS ("Focal") , mac-OS, and  				   Windows. 
Note  			:  MongoDB only supports the 64-bit versions of these platforms

Recommended Hardware for Production
RAM			:  32 GB or more, depending on  workload.
CPU			:  8 cores or more.
Storage		:  SSDs with high IOPS (Input/Output Operations Per Second) for 			 		   faster data access.
Network		:  Gigabit Ethernet or faster for better network performance.

Additional Considerations
Platform Support	:  MongoDB 8.0 Community Edition supports the following 64-bit Ubuntu 				   LTS (long-term support) releases on x86_64 architecture:
24.04 LTS ("Noble"),22.04 LTS ("Jammy"),20.04 LTS ("Focal")
Working Set		:  Ensure your working set (indexes and frequently accessed data) 			 	   fits in RAM for optimal performance.
Multiple CPU Cores	:  MongoDB's WiredTiger storage engine efficiently uses 				 		   multiple CPU cores.
Dedicated Server	:  For best performance, run one mongod process per host

Conclusion 
By following these steps, You have successfully installed MongoDB  APT package manager installation on Ubuntu 22.04 with customized data and log directories. MongoDB is now configured to store its data in /mongo/data and its logs in /mongo/logs, and also uninstall this mongo package. 
References
https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/
https://www.mongodb.com/community/forums/t/installing-mongodb-over-ubuntu-22-04/159931 
https://github.com/subrahmanyeswaraokrv/MongoDB-Handbook/tree/main/MongoDB%20Customised%20Installation
