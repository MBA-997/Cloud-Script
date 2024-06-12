# MONGO DB SCRIPT

### 1. Connect to AWS Ubuntu server

```sh
ssh -i path_to_your_key.pem ubuntu@your_instance_ip
```

### 2. Import the public key used by the package management system

```sh
sudo apt-get install gnupg curl
```

### 3. Import the MongoDB public GPG key

```sh
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
```

### 4. Create the list file

```sh
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
```

### 5. Reload local package database

```sh
sudo apt-get update
```

### 6. Install the MongoDB packages

```sh
sudo apt-get install -y mongodb-org
```

### 7. Check which system you are running (Usually systemd)

```sh
ps --no-headers -o comm 1
```

### 8. Start MongoDB

```sh
sudo systemctl start mongod
```

If you receive an error similar to the following when starting mongod:

```Failed to start mongod.service: Unit mongod.service not found.```

Run the following command first:

```sh
sudo systemctl daemon-reload
```

### 9. Verify that MongoDB has started successfully.

```sh
sudo systemctl status mongod
```

To enable mongo on every reboot run this command:

```sh
sudo systemctl enable mongod
```

## Configure Mongo on AWS

### 10. Open configuration file

```sh
sudo vim /etc/mongod.conf
```

Find the bindIp setting and ensure it is set to 127.0.0.1 to restrict access to localhost

```sh
bindIp: 127.0.0.1
```

Now, connect to your application to the database using this string, where mydatabase is your database name.

```
'mongodb://localhost:27017/mydatabase'
```

### Optionally, if you want to access your database from any development environment and not just the cloud, then set it to:

```sh
bindIp: 0.0.0.0
```

This will allow you to have same data synced whilst development and production environments.

Restart mongo to implement changes
```sh
sudo systemctl restart mongod
```

### 11. Modify the security group to allow a new rule

Type: Custom TCP
Protocol: TCP
Port Range: 27017
Source: 0.0.0.0/0

Save the rules.

### 12. Test Connection to your Mongo remotely

```sh
mongosh --host your_instance_ip --port 27017
```

### 13. Conenct to your mongo on AWS

```sh
mongosh
```

Once connected, run these commands

```sh
use DATABASE_NAME
```

Make sure to change password to something more complex
```sh
db.createUser({
  user: "admin",
  pwd: "password",
  roles: [{ role: "dbOwner", db: "DATABASE_NAME" }]
})
```

Exit Mongo Shell and configure Mongo

```sh
sudo vim /etc/mongod.conf
```

Add this comment below security comment

```sh
security:
  authorization: "enabled"
```

Exit and restart Mongo

```sh
sudo systemctl restart mongod
```

### 14. Your Mongo Connection string will look something like this

```sh
mongo --host your_instance_ip --port 27017 -u "admin" -p "password" --authenticationDatabase "DATABASE_NAME"
```

## 15. Congrats, you have successfully deployed MongoDB on your server with internet Access.
