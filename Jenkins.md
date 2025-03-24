# How to install Jekins on ubuntu


## Prerequisites:
You need to have a user with sudo privileges.

Your system must be connected to the internet.

### Steps to Install Jenkins on Ubuntu:
1. Update the Package Index:

Open a terminal and run the following command to ensure your package index is up to date:
```
sudo apt update
```
2. Install Java (Jenkins Requirement):
Jenkins requires Java to run. You can install the OpenJDK version (e.g., OpenJDK 11) using the following commands:

```
sudo apt install openjdk-11-jdk
```

3. Verify the installation:

```
java -version
```
This should show the Java version, confirming it's installed.


4. Add Jenkins Repository and Key:

Jenkins packages are not included in Ubuntu's default repositories. You need to add the Jenkins repository and key manually.

First, add the repository key:
```
#This is expired and do not use this 
#wget -q -O - https://pkg.jenkins.io/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins.asc

# use below updated
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

##  OR USE BELOW COMMAND TO ADD KEYS

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key  |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
```

5. you can also veryfy the expiry of gpg keys (optinal)
```
curl -s https://pkg.jenkins.io/debian/jenkins.io-2023.key | gpg --show-keys

## IMPORTANT

sudo mkdir -m 0755 -p /etc/apt/keyrings/
#gpg must me present on your system
```

6. Add the Jenkins repository to the system:
```
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.asc] https://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'

## IMPORTANT
sudo mkdir -m 0755 -p /etc/apt/keyrings/
```

7. Install Jenkins:

Update the package index again to include the Jenkins repository:
```
sudo apt update
```

8. Now, install Jenkins:
```
sudo apt install jenkins
```

9. Start Jenkins Service:

After installation, you can start Jenkins using the following command:

```
sudo systemctl enable jenkins

sudo systemctl start jenkins
```


10. To verify Jenkins is running, you can check the status with this command:
```
sudo systemctl status jenkins
```

11. Configure Firewall (if applicable):

If you have a firewall running, you need to allow traffic on Jenkins’ default port (8080):

```
sudo ufw allow 8080
sudo ufw reload
```

12. Access Jenkins Web Interface:

Once Jenkins is running, open a web browser and go to:

```
http://<your_server_ip>:8080
If you're on a local machine, you can simply visit http://localhost:8080.
```

13. Unlock Jenkins:

On the first login, Jenkins will require an unlock key. To retrieve the key, run the following command:

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Copy the password and paste it into the web interface to complete the setup.
```

## Complete Setup:

After entering the unlock key, Jenkins will ask you to install suggested plugins or select specific plugins.

Create your first admin user, or use the default admin account.

After completing these steps, you can start using Jenkins for building and managing your CI/CD pipelines.

Conclusion:
You’ve successfully installed Jenkins on Ubuntu! Now, you can start creating Jenkins jobs, configure pipelines, and integrate your projects.
