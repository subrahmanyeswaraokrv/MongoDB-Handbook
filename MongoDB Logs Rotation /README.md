Objective
The purpose of the MongoDB log rotation script is to manage the log files generated by MongoDB. Over time, these log files can grow significantly, consuming disk space and potentially impacting system performance. The script ensures that log files are rotated, compressed, and old log files are cleaned up automatically.
Scope of this Document 
This document aims to provide a step-by-step guide for automate the process of rotating MongoDB logs  using shell script. The scope includes:

Objective: Clearly state the purpose of the MongoDB log rotation script, including the benefits of automating log rotation, compression, and cleanup.
 
Script Details: Provide the detailed script for log rotation, including:
MongoDB connection details.
Steps to rotate and compress the log files.
Commands to remove log files older than one week.
Debugging steps to ensure proper execution.
Automating with Cron
Editing the Sudoers File
Setting Up the Cron Job
Example Cron Schedules

General Description
The MongoDB Log Rotation Script is designed to manage the log files generated by a MongoDB database server efficiently. Over time, these log files can grow significantly, 
consuming valuable disk space and potentially impacting system performance. 
This script automates the process of rotating, compressing, and cleaning up these log files, ensuring they do not become a burden on the system.

Conclusion 

By following these steps, we will be automating the log rotation process. Compressed logs on every schedule and rotate then and also remove old logs older than 7 days. 

References
https://www.claudiokuenzler.com/blog/566/mongodb-3.x-log-rotation-script
https://github.com/subrahmanyeswaraokrv/MongoDB-Handbook/tree/main/MongoDB%20Logs%20Rotation%20
