import paramiko

def run_commands_on_server(server_ip, username, password):
    commands = [
        "cat /etc/lsb-release",
        "sudo apt update",
        "sudo wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/mongodb.asc",
        "echo 'deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list",
        "sudo apt-get install -y gnupg curl",
        "sudo curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg",
        "sudo apt-get update",
        "sudo apt-get install -y mongodb-org",
        "sudo mkdir -p /mongo/data /mongo/logs",
        "sudo chown -R mongodb:mongodb /mongo/data /mongo/logs",
        "sudo systemctl enable mongod",
        "sudo systemctl start mongod",
        "sudo systemctl status mongod --no-pager",
        "mongosh --eval \"use admin; db.createUser({ user: 'superAdmin', pwd: '$upe6Adm!n', roles: [{ role: 'root', db: 'admin' }] })\"",
        "mongosh --eval \"use touprd; db.createUser({ user: 'appusrdemo', pwd: 'Ap!p!U$rdE', roles: [{ role: 'readWrite', db: 'touprd' }] })\"",
        "echo 'security:\n  authorization: enabled' | sudo tee -a /etc/mongod.conf",
        "sudo systemctl restart mongod",
        "mongosh -u superAdmin -p '$upe6Adm!n' --eval 'db.auth(\"superAdmin\", \"$upe6Adm!n\")'",
        "mongosh -u appusrdemo -p 'Ap!p!U$rdE' --authenticationDatabase touprd --eval 'db.auth(\"appusrdemo\", \"Ap!p!U$rdE\")'"
    ]
    
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(server_ip, username=username, password=password)
    
    for cmd in commands:
        print(f"Executing: {cmd}")
        stdin, stdout, stderr = ssh.exec_command(cmd)
        print(stdout.read().decode())
        print(stderr.read().decode())
    
    ssh.close()
    print("MongoDB installation and setup completed.")

if __name__ == "__main__":
    server_ip = input("Enter the server IP: ")
    username = input("Enter SSH username: ")
    password = input("Enter SSH password: ")
    run_commands_on_server(server_ip, username, password)
