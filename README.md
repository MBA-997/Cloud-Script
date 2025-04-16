# Cloud Script

How to deploy nodejs app to AWS EC2 Ubuntu 22 Server with free SSL and Nginx reverse proxy

## Installation instructions

### 1. Launch amazon ubuntu server in aws + Attach Elastic IP to the new instance

### 2.1 Change permissions of .pem file

## For Windows
```sh
icacls your-key.pem /reset
icacls your-key.pem /inheritance:r
icacls your-key.pem /grant:r "%USERNAME%:R"
```

## For Linux/MacOS
```sh
sudo chmod 400 your-key.pem
```

### 2.2 ssh to ubuntu to install packages

```sh
ssh -i <key.pem> ubuntu@<ip-address> -v
```

### 3. Update and Upgrade linux machine and install node and nvm

```sh
sudo apt update
```

```sh
sudo apt upgrade
```

```sh
sudo apt install -y git htop wget
```

#### 3.1 install node

To **install** or **update** nvm, you should run the [install script][2]. To do that, you may either download and run the script manually, or use the following cURL or Wget command:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

Or

```sh
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

Running either of the above commands downloads a script and runs it. The script clones the nvm repository to `~/.nvm`, and attempts to add the source lines from the snippet below to the correct profile file (`~/.bash_profile`, `~/.zshrc`, `~/.profile`, or `~/.bashrc`).

#### 3.2 Copy & Past (each line separately)

<a id="profile_snippet"></a>

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

#### 3.3 Verify that nvm has been installed

```sh
nvm --version
```

#### 3.4 Install node

```sh
nvm install --lts # Latest stable node js server version
```

#### 3.5 Check nodejs installed

```sh
node --version
```

#### 3.6 Check npm installed

```sh
npm -v
```

### 4. Clone backend repository

```sh
cd /home/ubuntu
```

Be sure to create a PAT (Personal Access Token) in developer settings on your GitHub profile, and replace it in the git clone command

```sh
git clone https://Your-PAT@github.com/MBA-997/cloud-backend.git
```

### 5. Run node app.js (Make sure everything working)

```sh
cd Backend
```

```sh
npm install
```

```sh
node app.js
```

### 6. Install pm2

```sh
npm install -g pm2 # may require sudo
```

### 7. Starting the app with pm2 (Run nodejs in background and when server restart)

```sh
pm2 start index.js --name=backend-server
```

```sh
pm2 save     # saves the running processes
                  # if not saved, pm2 will forget
                  # the running apps on next boot
```

#### 7.1 IMPORTANT: If you want pm2 to start on system boot

```sh
pm2 startup # starts pm2 on computer boot
```

### 8. FREE SSL - Install Nginx web server

```sh
sudo apt install nginx
```

```sh
sudo vim /etc/nginx/sites-available/default
```

#### Add the following to the location part of the server block

```sh
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:5000; #whatever port your app runs on
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
```

##### Check NGINX config

```sh
sudo nginx -t
```

##### Restart NGINX

```sh
sudo service nginx restart
```

#### You should now be able to visit your IP with no port (port 80) and see your app. Now let's add a domain

### 9 Add domain in goDaddy.com

If you have domain, you can add A record to your EC2 instance IP with a new subdomain as I'm going to show you next

#### 9.1 Check that Port 80 redirect to Nodejs server

### 10 Installing Free SSL

#### 10.1 Installing Certbot

```sh
sudo snap install core; sudo snap refresh core
```

```sh
sudo apt remove certbot
```

```sh
sudo snap install --classic certbot
```

```sh
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

#### 10.2 Confirming Nginx’s Configuration

```sh
sudo vim /etc/nginx/sites-available/default
```

let edit this line:

```sh
...
server_name example.com www.example.com;
...
```

```sh
sudo nginx -t
```

```sh
sudo systemctl reload nginx
```

#### 10.3 Obtaining an FREE SSL Certificate

```sh
sudo certbot --nginx
```

Output:

```
IMPORTANT NOTES:
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/your_domain/fullchain.pem
Key is saved at: /etc/letsencrypt/live/your_domain/privkey.pem
This certificate expires on 2022-06-01.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
* Donating to ISRG / Let's Encrypt: https://letsencrypt.org/donate
* Donating to EFF: https://eff.org/donate-le
```

#### 10.4 Verifying Certbot Auto-Renewal

```sh
sudo systemctl status snap.certbot.renew.service
```

Output:

```
○ snap.certbot.renew.service - Service for snap application certbot.renew
     Loaded: loaded (/etc/systemd/system/snap.certbot.renew.service; static)
     Active: inactive (dead)
TriggeredBy: ● snap.certbot.renew.timer
```

To test the renewal process, you can do a dry run with certbot:

```sh
sudo certbot renew --dry-run
```

### 11. Visit your website HTTPS://<your website>

### 12. Setup and run deployment.sh for automation

Replace or adjust commands as needed to automate the deployment of your server for future

Enjoy Your free Nodejs server with Free SSL :)
