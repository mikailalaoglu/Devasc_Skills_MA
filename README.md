# Devasc_Skills_MA
          Task 1:  Github! 

- Stap 1: Make a repository on github
- Stap 2: create folder with (Foldername) and open the folder with VScode
- Stap 3: in the terminal Type...
        git init
        git clone (link of repository)
        git add .     // !!!!to add something to your repository you need a change in the folder, you can create a python file type something in and save it; this way you have something to add to your repository!!!!!

        git commit -m "(a command  about the thing thats pushed)"
        git branch -M main
        git remote add origin https://github.com/mikailalaoglu/Devasc_Skills_MA.git
        git push -u origin main

- Stap 4: look for changes in github.

 
             Task 2: Ansible

- Stap 1: connect to router with your laptop from a console cable, ethernet cable connects switch and router
- Stap 2: connected via putty do the following commands,

enable
Router#show ip interface brief  
Router#conf t
Router(config)#hostname R1
R1(config)#int gig0/0/0
R1(config-if)#ip address 10.0.1.1 255.255.255.0
R1(config-if)#no shutdown
R1(config-if)#exit

R1(config)#ip dhcp pool DevOpspool
R1(dhcp-config)#network 10.0.1.0 255.255.255.0
R1(dhcp-config)#default-router 10.0.1.1
R1(dhcp-config)#domain-name DevOps.be
R1(dhcp-config)#exit

R1(config)#ip domain name DevOps.be
R1(config)#crypto key generate rsa modulus 2048
R1(config)#end

R1#show ip ssh

R1#conf terminal
R1(config)#username admin privilege 15 secret cisco123
R1(config)#line vty 0 15
R1(config-line)#transport input ssh
R1(config-line)#login local
R1(config-line)#end
R1#R1#Router(config)#hostname R1

R1#R1(config)#ip dhcp pool DevOpspool
R1#R1(config)#crypto key generate rsa modulus 2048
>R1(dhcp-config)#network 10.0.1.0 255.255.255.0

Switch>R1(dhcp-config)#default-router 10.0.1.1

- Stap 3: on the pc in command prompt you type 
ipconfig /release
ipconfig /renew    // this way you get a ip addres from the router

- Stap 4: create a folder in Devasc_Skills ;now you can create a host file named (hosts) in VM machine and put the following.
[router]
CSR1kv ansible_host=10.0.1.1 ansible_user=admin ansible_password=cisco123 enable_password=cisco123 ansible_network_os=ios    // you put in the routers ip addres and passwords

- stap 5: make a file named ansible.cfg put the following inside the file
[defaults]
# Use local hosts file in this folder
inventory=./hosts 
# Don't worry about RSA Fingerprints
host_key_checking = False 
# Do not create retry files
retry_files_enabled = False 

- Stap 6: now you make a yaml file with the codes you need and you can run it by typing 
ansible-playbook (file_name)
---
- name: Gather IOS version and IP addresses
  hosts: router
  gather_facts: no
  connection: local

  tasks:
    - name: Retrieve IOS version
      ios_command:
        commands: show version | include IOS
      register: ios_version

    - name: Display IOS version
      debug:
        msg: "IOS version: {{ ios_version.stdout_lines[0] | regex_replace('\\s*IOS\\s+', '') }}"

    - name: Retrieve IP addresses
      ios_command:
        commands: show ip interface brief | exclude unassigned
      register: ip_addresses

    - name: Display IP addresses
      debug:
        var: ip_addresses.stdout_lines



          Task 3: Docker

- Stap 1 : make a folder named Docker, in this folder you create a datescript.js file and a Dockerfile

- Stap 2 :in the Dockerfile you put in 
FROM httpd:2.4
COPY templates/index.html /usr/local/apache2/htdocs/
COPY datescript.js /usr/local/apache2/htdocs/
EXPOSE 80

- Stap 3 : in the datescript.js file you put in the following
document.addEventListener("DOMContentLoaded", function() {
    
    function updateDateTime() {
      
        var currentDate = new Date();
        var formattedDateTime = currentDate.toLocaleString();
        document.getElementById("datetime").innerText = formattedDateTime;
    }

    // Initial call to update date and time
    updateDateTime();

   
    setInterval(updateDateTime, 1000);
});

- Stap 4 : after this you create a new folder in Docker folder with the name templates, create a index.html file init 
<html>
<head>
    <title>DevNet Associate Skills Test:Mikail Alaoglu</title>
    <link rel="stylesheet" href="/static/style.css" />
</head>
<body>
    <h1>DevNet Associate Skills Test</h1>
    <p>Created by: <mark>Mikail Alaoglu</mark></p>
    <p>Date: <script src="datescript.js"></script></p>
    <p id="datetime"></p>
</body>
</html>

- Stap 5 : now when you have all these files you can go in the terminal and go where your Dockerfile is placed do the following commands.
docker image build -t (image_name) .
docker run -d -p 8080:80 --name (container_name)  (image_name)

- Stap 6 : now you can test it by typing this in the cmd "curl http://localhost:8080" or go on the browser and type 
"http://localhost:8080"



          Task 10: DANC

- Stap 1: You create a folder named "Danc" with a .py file(pythone file) in it; put the following in it
import requests
import datetime
import json
requests.packages.urllib3.disable_warnings()

DNAC_scheme = 'https://'
DNAC_authority='sandboxdnac.cisco.com'
DNAC_port=':443'
DNAC_path_token='/dna/system/api/v1/auth/token'
DNAC_path='/dna/intent/api/v1/network-device'
DNAC_user = 'devnetuser'
DNAC_psw = 'Cisco123!'

# DATE AND TIME
print("Current date and time: ")
print(datetime.datetime.now())

# TOKEN REQUEST
token_req_url = DNAC_scheme + DNAC_authority + DNAC_path_token
auth = (DNAC_user, DNAC_psw)
req = requests.request('POST', token_req_url, auth=auth, verify=False)
token = req.json()['Token']

# INVENTORY REQUEST
req_url = DNAC_scheme + DNAC_authority + DNAC_port + DNAC_path
headers = {'X-Auth-Token': token}
resp_devices = requests.request('GET', req_url, headers=headers, verify=False)
resp_devices_json = resp_devices.json()

# FILTER RESPONSE DATA
for device in resp_devices_json['response']:
    if device['type'] is not None:
        print('===')
        print('Hostname: ' + device['hostname'])
        print('Family  : ' + device['family'])
        print('MAC: ' + device['macAddress'])
        print('IP: ' + device['managementIpAddress'])
        print('Software version: ' + device['softwareVersion'])
        print('Reachability: ' + device['reachabilityStatus'])

- Stap 2: here you create a program that prints the time and device informations that he finds from the web. to connect to the web you use Json.
you create the same output as you see on "output_task_10"

- Stap 3: now you can run the Pythone script by typing this in the bash terminal 
python3 (python_script_name.py)