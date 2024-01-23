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
     

          Task 6: WEBEX

- Stap 1: you create a folder named Webex
- Stap 2: there make a python script named (devasc_skills_(nameInitials).py) put the following init.
import requests
import json 

# Webex Teams API base URL
api_url = "https://api.ciscospark.com/v1"

# Your Webex Teams API token
api_token = "Y2RkOTY2NTQtMWUwOS00ZWRkLWI1N2MtYzQwMDFlMGUxZDI4NjM4OTFhMTYtMTEx_P0A1_14a2639d-5e4d-48b4-9757-f4b8a23372de"

# Members' email addresses
your_email = "mikailalaoglu@outlook.com"
yvan_email = "yvan.rooseleer@biasc.be"

# Webex Teams space name
space_name = "devasc_skills_MikailAlaoglu"

# Function to create a Webex Teams space
def create_space(api_url, api_token, space_name):
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json",
    }
    payload = {"title": space_name}
    response = requests.post(f"{api_url}/rooms", headers=headers, json=payload)
    return response.json()["id"]

# Function to invite members to a Webex Teams space
def invite_members(api_url, api_token, space_id, email_list):
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json",
    }
    for email in email_list:
        payload = {"roomId": space_id, "personEmail": email}
        requests.post(f"{api_url}/memberships", headers=headers, json=payload)
# Function to send a message to a Webex Teams space
def send_message(api_url, api_token, space_id, message):
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json",
    }
    payload = {"roomId": space_id, "text": message}
    requests.post(f"{api_url}/messages", headers=headers, json=payload)

# Create Webex Teams space
space_id = create_space(api_url, api_token, space_name)

# Invite members to the space
invite_members(api_url, api_token, space_id, [your_email, yvan_email])

# Publish GitHub repository URL in the space
github_repo_url = "https://github.com/mikailalaoglu/Devasc_Skills_MA"
send_message(api_url, api_token, space_id, f"Check out my GitHub repository: {github_repo_url}")

# Send a message to the space
send_message(api_url, api_token, space_id, "Here are my screenshots of devasc skills-based exam")

- Stap 3: so here you have a script that connects to your webex account via a python script and creates a webex space, there you invite yourself and your professor. In addition you link your repositorie in the chat. 

- Info: so you need to create a webex account and search for the api token so you can connect via the script (api tokens only last around 16hours so you need to change it regularly); all these informations you find on your webex account

          Task 7: BASH
- Stap 1: First you make a folder named Bash
- Stap 2: after this you create a pythone file named (restconf_put_get_interface.py) you put the following commands (you run to see the result )
import requests
requests.packages.urllib3.disable_warnings()

IP_HOST = "192.168.56.107"
RESTCONF_USERNAME="cisco"
RESTCONF_PASSWORD="cisco123!"
DATA_FORMAT="application/yang-data+json"
LOOPBACK_INTERFACE="Loopback199"
LOOPBACK_IP="10.1.99.1"

api_url_put = f"https://{IP_HOST}/restconf/data/ietf-interfaces:interfaces/interface={LOOPBACK_INTERFACE}"
api_url_get = f"https://{IP_HOST}/restconf/data/ietf-interfaces:interfaces"
headers = { "Accept": DATA_FORMAT ,  "Content-type": DATA_FORMAT }
basicauth = (RESTCONF_USERNAME, RESTCONF_PASSWORD)
yangConfig = {
  "ietf-interfaces:interface": {
     "name": LOOPBACK_INTERFACE,
     "description": f"RESTCONF => {LOOPBACK_INTERFACE}",
     "type": "iana-if-type:softwareLoopback",
     "enabled": True,
     "ietf-ip:ipv4": {
         "address": [
             {
                 "ip": LOOPBACK_IP,
                 "netmask": "255.255.255.0"
             }
         ]
     }
 }
}

resp_put = requests.put(api_url_put, json=yangConfig, auth=basicauth, headers=headers, verify=False)

if resp_put.status_code in range(200,300):
    print(f"STATUS OK: {resp_put.status_code}") 
else:
    print("ERROR") 
    print(resp_put.status_code)
    print(resp_put.text)

resp_get = requests.get(api_url_get, auth=basicauth, headers=headers, verify=False)
print(resp_get.text)

- Stap 3: The pythone file was an example of a api call now you need to make the same in a Bash script
- Stap 4: make a Bash File (restconf_api.sh) you put in the following code;
#!/bin/bash

# RESTCONF API endpoints
IP_HOST="192.168.56.107"
RESTCONF_USERNAME="cisco"
RESTCONF_PASSWORD="cisco123!"
DATA_FORMAT="application/yang-data+json"
LOOPBACK_INTERFACE="Loopback199"
LOOPBACK_IP="10.1.99.1"

api_url_put="https://${IP_HOST}/restconf/data/ietf-interfaces:interfaces/interface=${LOOPBACK_INTERFACE}"
api_url_get="https://${IP_HOST}/restconf/data/ietf-interfaces:interfaces"
headers="-H 'Accept: ${DATA_FORMAT}' -H 'Content-type: ${DATA_FORMAT}'"
basicauth="-u ${RESTCONF_USERNAME}:${RESTCONF_PASSWORD}"
yangConfig='{
  "ietf-interfaces:interface": {
     "name": "'${LOOPBACK_INTERFACE}'",
     "description": "RESTCONF => '${LOOPBACK_INTERFACE}'",
     "type": "iana-if-type:softwareLoopback",
     "enabled": true,
     "ietf-ip:ipv4": {
         "address": [
             {
                 "ip": "'${LOOPBACK_IP}'",
                 "netmask": "255.255.255.0"
             }
         ]
     }
 }
}'

# Output to check_restconf_api.txt
{
    # First line: today's date
    echo "Today's date: $(date)"

    # Next line: START REST API CALL
    echo "START REST API CALL"
    echo "============"

    # First API Call
    echo "FIRST API CALL"
    echo "============"
    
    # Debug: Print details about the request
    echo "Curl PUT Command:"
    echo "curl -i -X PUT $api_url_put -d \"$yangConfig\" $basicauth $headers --insecure"
    
    # Perform the RESTCONF PUT request
    resp_put=$(curl -i -X PUT $api_url_put -d "$yangConfig" $basicauth $headers --insecure)
    
    # Debug: Print the full response for troubleshooting
    echo "Full Response (PUT):"
    echo "$resp_put"

    # Extract and Output Status Code
    status_code_put=$(echo "$resp_put" | grep HTTP/ | awk '{print $2}')
    echo "Status Code (PUT): $status_code_put"
    echo "============"

    # Second API Call
    echo "SECOND API CALL"
    echo "============"
    
    # Debug: Print details about the request
    echo "Curl GET Command:"
    echo "curl -i -X GET $api_url_get $basicauth $headers --insecure"
    
    # Perform the RESTCONF GET request
    resp_get=$(curl -i -X GET $api_url_get $basicauth $headers --insecure)

    # Extract and Output Status Code
    status_code_get=$(echo "$resp_get" | grep HTTP/ | awk '{print $2}')
    echo "Status Code (GET): $status_code_get"
    
    # Extract and Output Specific Field (e.g., interface names)
    interfaces=$(echo "$resp_get" | jq -r '.data | .["ietf-interfaces:interfaces"] | .interface | .[].name')
    echo "Interfaces: $interfaces"

    echo "============"

    # Last line: END REST API CALL
    echo "END REST API CALL"
} >| check_restconf_api.txt

- Stap 5: here you have a bash script that calls to a server via json to get information, you print the information accordingly to the task, at the end you will create a txt file that haz all information init.

- info : there is a slight porblem connecting to port 443. the port is not blocked and i can reach the server via the program; so i hope there is a problem with the server not with the code (:-)

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