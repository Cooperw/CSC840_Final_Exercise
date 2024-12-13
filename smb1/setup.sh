#!/bin/bash

# Create a group for employees
groupadd -f employees

# Add users and set Samba passwords explicitly
useradd -M -s /sbin/nologin -G employees e76543210
echo -e "qmidqrblaglnqgemxayzfggvqshzpu\nqmidqrblaglnqgemxayzfggvqshzpu" | smbpasswd -a e76543210

useradd -M -s /sbin/nologin -G employees e27481930
echo -e "uuotvtxuyggcxqhlbgbxxtgviijspf\nuuotvtxuyggcxqhlbgbxxtgviijspf" | smbpasswd -a e27481930

useradd -M -s /sbin/nologin -G employees e90874321
echo -e "strongpassword123!\nstrongpassword123!" | smbpasswd -a e90874321

# Ensure welcome.txt is publicly readable in the employees share
mkdir -p /employees/johnson
echo "Welcome aboard Johnson! Your password is strongpassword123! and your username is your employee ID similar to e12345678." > /employees/johnson/welcome.txt
chmod 644 /employees/johnson/welcome.txt

# Create a restricted share and add flag.txt
mkdir -p /restricted
echo "FLAG: CSC840{ch3ck_y0ur_c0nf165}" > /restricted/flag.txt
chmod 770 /restricted
chown :employees /restricted
chown :employees /restricted/flag.txt

# Samba configuration
cat <<EOT > /etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   server string = Samba Server
   security = user
   map to guest = Bad User
   smb ports = 445
   passdb backend = tdbsam

[employees]
   path = /employees
   public = yes
   writable = no
   guest ok = yes
   force user = nobody

[restricted]
   path = /restricted
   public = no
   writable = yes
   valid users = @employees
   create mask = 0660
   directory mask = 0770
   guest ok = no
EOT

# Start Samba services directly
smbd -D
nmbd -D

# Output debugging information
pdbedit -L

# Keep the container running
tail -f /dev/null
