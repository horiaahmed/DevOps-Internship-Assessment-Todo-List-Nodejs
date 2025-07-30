#  DevOps Internship Assessment - 📝Todo List App

This project demonstrates DevOps skills by building, deploying, and automating a Node.js Todo API using Docker, GitHub Actions, Ansible, Docker Compose, and optionally Kubernetes with ArgoCD.

---
## Features

- Dockerized App: Package the Node.js application in a Docker container for consistent deployment.
- GitHub Actions CI/CD: Automate Docker image build and push to Docker Hub on every code push using GitHub Actions.
- Ansible Automation: Use Ansible to install Docker and it should run from My local machine against the VM.
- Used docker compose to run the application instead of docker build.
- With auto update part like (Watchtowr).
- Process Advanced with Kubernetes on the VM and use ArgoCD for the CD part.

---

## Project Steps
## Part 1 – Application Setup & CI Pipeline Using Github Actions
#### Phase 1
- Clone Repo https://github.com/Ankit6098/Todo-List-nodejs 
```bash
  git clone https://github.com/Ankit6098/Todos-nodejs
```
#### Phase 2
- Use My Own MongoDB Database:
  - Login to my mongoDB Atlas account 
  - Create free cluster and Database(Todos-nodeDB)
  - Take connection string and update the .env file with My MongoDB Atlas connection string.
#### Phase 3
- 🐳 Dockerize the application.
  - Write Docker File (image) Syntax
  - Build Docker image with
  ```bash
  docker build -t (image_name) .
  ```
  - Ensure that image was built successfully with
  ```bash
  docker images || docker image ls
  ```
  - Run Container using created image with 
  ```bash
  docker run --name (container_name) -d -p 4000:4000 (image_name)
  ```
  - show running container with 
  ```bash
  docker ps
  ```
  - Ensure app running and Dockerized successfully with logs 
  ```bash
  docker logs (container_name)
  ```
- App is Dockerized successfully but i want to enhance some points 
  - Enhance base image using node:20-alpine instead of node:20 that has many advantages
    - Lightweight: Alpine images are very small that reduces build time and image size.
    ![node:20](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-27.png)
    ![node:20-alpine](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-27%20(3).png)

    - Faster Deployments: Smaller images are quicker to pull/push to registries and start faster in containers.
    - **Important one** -> Improved Security: Fewer packages means a smaller attack surface.
  - Use .dockerignore file that 
    - Reducing image size (excludes unnecessary files like node_modules)

  - Use Vloumes like **Anonymous Volumes** 
    - Data is preserved across container restarts and when update in source code container is up to date automatically.
    - But to make sure not damage in the source code i used (ro)read only option that make one way update from (source code -> container)
    - Volume command 
   ```bash
    docker run --name (container_name) -v ${PWD}:/(WORKDIR):ro -d -p 4000:4000 (image_name)
    ```
  - finally used docker-compose simple file to build image and run containers in easy way
  - Run container&build image 
   ```bash
   docker-compose up -d --build
   ```
    - Just run container 
   ```bash
    docker-compose up -d 
   ```
    - Stop container 
   ```bash
   docker-compose down
   ```
#### Phase 4
- Use GitHub Actions to create a CI pipeline that builds the image and pushes it to
a private docker registry.
    - first i made the .yml file in .github/workflow directory
    - wrote the file syntax make the workflow trigger in two events (push and pull_request)
    - I used private repository in dockerhub as private docker registry and linked with github with username and password in actions secrets
    - finally pushed changes so workflow was triggerd and image built and pushed to repo in dockerhub
    ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-27%20(6).png)
    ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-27%20(5).png)
    - **Enhance build in .yml file** : used **QEMU** to build images for different CPU architectures and ensure that image build works on various platforms
--- 
## Part 2 – Automation Using **Ansible**
#### Phase 1 
- Create a Linux VM on your local machine or the Cloud.
   I Created Both:
   - I already use Orcale VM on my local macine 
   - And Created Linux VM on cloud (**AWS**) 
      - Lanching EC2 instance with os Ubuntu
      - Copy public ip address
      - Generate New pair key and use .pem file to connect to local machine using ssh with
      ```bash
      ssh -i ssh -i path/vm-aws.pem ubuntu@13.51.79.251 
      ```
      ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-27%20(7).png)
      ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-27%20(9).png)
#### Phase 2 & 3
- Use Ansible to configure the machine and install the needed packages such as
Docker.
  - Across using windows must use tools that allow you to run a Linux environment like **WSL** makes me deals easly with ansible
  - After installation i defiend ansible directory structure that has:
     - inventory folder with .ini file where i defined the hosts under groups to be managed
     - playbook .yml file that has instructions that run on the hosts using groups 
  - Then run the ansible with playbook with 
  ```bash
  ansible-playbook -i inventory/host.ini playbook.yml
  ```
  - First use one host (aws-ec2)  
  - Machine configured,docker installed and started it successfully 
  ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-28%20(6).png)
  - Then I want to increase availability by managing more than one host and made automation on both [ orcale-vm and cloud machine (aws-ec2) ]
  - Manged them with two diffrent access ways 
     - ec2-instance : Connected with ssh **nsible_ssh_private_key_file=~/.ssh/vm-aws.pem**
     - orcale vm : Connected with password **ansible_ssh_pass=********
  - Two Hosts Managed successfully
  ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-28%20(7).png)
By compelete this phase **2&3**
Ansible has to run from your local machine against the VM. **This requirement was also achieved**
---
## Part 3 -  Running Application with Docker Compose and Automated Image Updates on VM
#### Phase 1
- On the VM, use docker compose to run the application. Make sure you configure
the proper health checks.
   - I previously used simple docker-compose in part 1 on my local But i wanted to Enhance it 
      - Add healthchecks :To ensure a container is running correctly and restart it automatically if it's unhealthy.
      - Implemented changes to enable better control over development and production environment
          - Edit package.json to has "devDependencies" section that contain packages only using in development 
          - Split the Docker Compose setup into a main file and two environment specific configurations like (target,Volumes,...)
          - Used MultiStage Dockerfile to **enhance organization – separate stages for development and production - make Dockerfiles cleaner**
    - Then Logined to vm on aws
       - installed docker-compose 
       - Cloned My repo
       - login to docker with personal cardiential 
       ```bash
       docker login 
       ```
       - pulled docker image that declared in docker-compose file from dockerhub repository by
       ```bash
       docker-compose pull
       ```
       - Run container with pulled image using docker-compose
       ```
       docker-compose -f (main-compose-file).yml -f (specific-file).yml up -d
       ```
![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-29.png)

#### Phase 2 & 3 
- You need to continuously check for changes in the image on the docker registry
repo. If a change is detected, the new image should be pulled With auto update.
  - After changes in code and push to github the CI Pipline works and build new image and pushed it to dockerhub in my private repository it alwayes be latest image then to make new image pulled automatically i preferd to use
   **watctower** tool because:
      - It Easy to Configure without any installation proccess it just run more one container (watchtower container) 
      - Simple deployment automate tool to use with small/medium application 
      - Can control logs in east way just with passing environment argument you want to add (interval,trace,...) 
    You can use watchtower in two ways:
      - Just add new service in docker-compose file that when run containes with docker-compose watchtower container is created and listen to my containers
      - Or build watchtower container manually for one time with docker in Cli using
      ```bash 
      docker run -d --name watchtower -e REPO_USER=user -e REPO_PASS=pass -e WATCHTOWER_TRACE=true -e WATCHTOWER_POLL_INTERVAL=30 -v /var/run/docker.sock:/var/run/docker.sock  containrrr/watchtower
      ```
      Show watchtower logs with 
      ```bash
      docker logs -f watchtower
      ```
      Then when make new updates new image will be pulled automatically and Watchtower removes current container and starts new one with new updates
      ![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-29%20(5).png)
--- 
## Part 4 Bouns- Kubernetes & ArgoCD
#### Phase 1
- **Orchestration App Using Kubernetes**
    - Installed Kubernetes (k3s) and run a Kubernetes cluster on Vm Using 
    ```bash
    curl -sfL https://get.k3s.io | sh -
    ```
    - Ckeck cluster status using kubectl
    ```bash
    kubeectl get nodes
    ``` 
    ![alt text](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/Screenshot%20(2).png)
    - Defiend kubernets two files with .yaml:
        - Deployment file : Controls the app deployment proccess inside the Kubernetes cluster (replicas,docker image,port,...)
        - Service file : expose and make access easy outside using port
        - Beacuse i used private repo on dockerhub i added dockerhub secrets in kubernets to can access image using 
        ```bash
        kubectl create secret docker-registry regcred --docker-username=user --docker-password=pass --docker-email=email
        ```

      **Then two files work together using selector that app is defined in both**  
    - Apply files to cluster using 
    ```bash
    kubectl apply -f deployment.yaml
    kubectl apply -f todos-service.yaml
     ```
    - Ensure all is works correctly
        - Get Deployments ,services and created pods
        ```bash 
        kubectl get deployments
        kubectl get services
        kubectl get pods
        ```
        ![alt text](<assets/screenshots/Screenshot (4).png>)

    - finally can access my app through the port from service in browser in my case 31800 - http://VM_ip:31800

#### Phase 2   
- **Continous Deployment using ArgoCD** 
   - Installed using github repo
   - Confirm installaiton and runnig pods related to argocd using
   ```bash
   kubectl get pods -n argocd
   ```
   ![alt text](<assets/screenshots/Screenshot (5).png>)

   - Then i used argocd Ui in broswer using defult user admin and get password with 
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
   ```
   - I accessed the ui using ports in (argocd-server) http://vm-public-ip:30761
    And create new app with
       - my gitHub repository link
       - set the path to the Kubernetes
       - chose the cluster and namespace for deployment
  - Finally to enshure app is running successfully -> show pods it must ne **Running**
  ![alt text](<assets/screenshots/Screenshot (7).png>)
  --- 

## Skills
**Docker**
**Docker compose**
**CI with Github Actions**
**Ansible**
**Auto Update with (WatchTower)**
**Kubernetes**
**CD with ArgoCD**
  

   
   
  




    


    




















  
