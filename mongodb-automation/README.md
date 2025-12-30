# ============================================
# MongoDB Automation Toolkit (DBA Operations)
# ============================================
This directory contains a menu-driven MongoDB DBA automation toolkit designed for on-prem and hybrid MongoDB environments.

It automates daily DBA operational tasks safely, securely, and in a production-ready manner.

📂 Directory Structure
mongodb-automation/
│
├── mongo_task_multi_env.sh        # Main controller (entry point)
├── env.conf                       # Environment & MongoDB URI config
│
├── tasks/
│   ├── task_1_connect_server.sh
│   ├── task_2_connect_mongo.sh
│   ├── task_3_create_user.sh
│   ├── task_4_update_user.sh
│   ├── task_5_update_field.sh
│   ├── task_6_backup_db.sh
│   ├── task_7_log_rotation.sh
│   ├── task_8_verify_backup.sh
│   ├── task_9_df_critical_check.sh
│   └── task_10_drop_user.sh
│
├── utils/
│   └── mongo_log_rotate.sh        # Runs locally on MongoDB servers
│
├── logs/
│   └── mongo_dba.log              # Runtime logs (auto-generated)
│
└── .gitignore

🔧 Prerequisites
Control Node (where toolkit runs)

Linux (Ubuntu / RHEL)

bash 4+

mongosh

mongodump

SSH access to MongoDB servers

MongoDB Servers

SSH user: venkata

MongoDB installed and running

MongoDB config file present (example: /mongo/mongod.conf)

Local log rotation script installed

Passwordless sudo ONLY for approved script

🔐 Permissions & Security Model
Required sudo rule on MongoDB servers
venkata ALL=(root) NOPASSWD: /usr/local/bin/mongo_log_rotate.sh


✔ Least-privilege
✔ Auditable
✔ No sudo -i
✔ No passwords stored in scripts

⚙️ Environment Configuration (env.conf)

Single source of truth for MongoDB connectivity.

Example:

DEV_URI="mongodb://superAdmin@host1,host2/admin?replicaSet=rs0&tls=true"
DEV_TLS=true


⚠️ Never store passwords in env.conf.

▶️ How to Run the Toolkit
cd mongodb-automation
chmod +x mongo_task_multi_env.sh
chmod +x tasks/*.sh

./mongo_task_multi_env.sh

Execution Flow

Script password authentication
[Script Password Protection (Controller Script)
The main controller script (mongo_task_multi_env.sh) is protected by a SHA-256 hashed password to prevent unauthorized execution.
This password is separate from MongoDB credentials and is required every time the toolkit is started.
🔧 How Script Authentication Works
User enters a password at runtime
The password is hashed using SHA-256
The hash is compared with a stored value in the script
The script continues only if the hash matches
No plaintext password is stored anywhere.
🧪 Generate Script Password Hash
Run the following command on the control node:

read -s -p "Enter new script password: " PASS
echo
printf "%s" "$PASS" | sha256sum
unset PASS

Example output
811786ad1ae74adfdd20dd0372abaaebc6246e343aebd01da0bfc4c02bf0106c
Copy only the hash value (before the dash).
✏️ Add / Update Password Hash in Script
Open the controller script:
vi mongo_task_multi_env.sh
Locate this section:

# ===========================================
# Script password protection (SHA256)
# ============================================
SCRIPT_HASH="811786ad1ae74adfdd20dd0372abaaebc6246e343aebd01da0bfc4c02bf0106c"
Replace the value with your newly generated hash:
SCRIPT_HASH="<PASTE_NEW_HASH_HERE>"
Save and exit.

▶️ Runtime Behavior
When running the toolkit:
./mongo_task_multi_env.sh
You will see:
Enter script password:
Input is hidden
If the password is incorrect, execution stops immediately
If correct, the toolkit continues

🔒 Security Best Practices
✔ Never store plaintext passwords
✔ Change script password periodically
✔ Use a strong password (12+ characters)
✔ Limit file permissions on the script

Recommended permissions:

chmod 750 mongo_task_multi_env.sh

⚠️ Important Notes
Script password protects execution, not MongoDB access
MongoDB credentials are requested separately at runtime
Script password is not logged
Summary
Item	Status
Password stored	Hashed only
Algorithm	SHA-256
Plaintext saved	❌ No
Runtime prompt	✅ Yes
Easy rotation	✅ Yes
This makes your toolkit:
More secure
Enterprise-ready
Audit-friendly]
MongoDB admin password prompt

Environment selection

Task selection

Guided execution
# ============================================
# 🧭 TASK-WISE DOCUMENTATION
# ============================================

# 🔹 Task 1 – Connect to Server

task_1_connect_server.sh

Purpose

Connect to a selected MongoDB server via SSH.

What it does

Lists all servers in the selected environment

Prompts user to select one

SSH connects as venkata

Requirements

SSH access to server

Password or SSH key for venkata

Execution
Select Environment → Task 1 → Select server → SSH login

# 🔹 Task 2 – Connect to MongoDB

task_2_connect_mongo.sh

Purpose

Open an interactive MongoDB shell (mongosh) session.

What it does

Uses environment URI

Handles TLS / non-TLS automatically

Authenticates as MongoDB admin

Requirements

mongosh installed

MongoDB admin credentials

Execution
Select Environment → Task 2 → mongosh session opens

# 🔹 Task 3 – Create MongoDB User

task_3_create_user.sh

Purpose

Create a new MongoDB user with role assignment.

What it does

Prompts for DB, username, password, role

Creates user

Prints connection string + credentials

Requirements

MongoDB admin access

Execution
Select Environment → Task 3

Output includes

DB name

Username

Password

Role

Ready-to-use connection string

# 🔹 Task 4 – Update MongoDB User

task_4_update_user.sh

Purpose

Manage existing users.

Options

Update password

Update roles

Add role to another database

Create user if not found

Execution
Select Environment → Task 4 → Follow prompts

# 🔹 Task 5 – Update Document Fields

task_5_update_field.sh

Purpose

Safely update MongoDB documents.

Supports

updateOne / updateMany

$set operations

Arrays

Date fields

JSON validation

Execution
Select Environment → Task 5

Example Input
Filter: { "_id": "22292939" }
Update: { "d0010": "HKG" }

# 🔹 Task 6 – MongoDB Backup

task_6_backup_db.sh

Purpose

Perform MongoDB backups using mongodump.

Options

Single database

All databases

Single collection

Features

TLS aware

Timestamped backups

Uses --nsInclude (best practice)

Backup Location
/mongo/mongo_backup/<env>/<timestamp>/

# 🔹 Task 7 – MongoDB Log Rotation

task_7_log_rotation.sh

Purpose

Safely rotate MongoDB logs per node.

Design

Select replica-set member

SSH to server

Execute local script

Local Script
/usr/local/bin/mongo_log_rotate.sh

What it does

Detects log path from mongod.conf

OS-level log rotation

Triggers db.adminCommand({ logRotate: 1 })

# 🔹 Task 8 – Verify Backup

task_8_verify_backup.sh

Purpose

Validate MongoDB backups.

Checks

Backup directory exists

BSON files present

Size validation

# 🔹 Task 9 – Disk / Filesystem Check

task_9_df_critical_check.sh

Purpose

Detect disk space issues.

What it does

Runs df -h

Highlights critical usage

Useful before backups & restores

# 🔹 Task 10 – Drop MongoDB User

task_10_drop_user.sh

Purpose

Safely remove MongoDB users.

Safety

Prompts for confirmation

Ensures correct DB context

📜 Logging

All operations are logged to:

mongodb-automation/logs/mongo_dba.log

Passwords are never logged.

# Task 11 – Long Running Queries

task_11_long_running_queries.sh

Purpose

Identify MongoDB queries running longer than a specified threshold.

Use cases

Investigate application slowness

Find missing indexes

Detect blocking queries

Production troubleshooting

Input

Threshold in milliseconds (e.g. 100)

Option to include idle operations

Output

Operation ID

Namespace

Runtime

Client IP

Query / command

Execution
Select Environment → Task 11 → Enter threshold

Notes

Read-only

Does not terminate operations

Safe for production usage

🧠 Best Practices Followed

No secrets in Git

No sudo -i

Node-level operations handled locally

Replica-set aware

Production-safe defaults

👤 Author

Venkata Subrahmanyeswarao
MongoDB DBA / Data Architect

📌 Final Notes

This toolkit is suitable for:

DBA daily operations

On-call support

Controlled production usage

Interview & portfolio demonstration
