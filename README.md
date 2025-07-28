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
###  **Part 1 – Application Setup & CI Pipeline Using Github Actions**
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
###  Part 2 – Automation Using **Ansible**
#### Phase1 
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

By compelete this **phase 2&3**  
Ansible has to run from your local machine against the VM. This requirement was also achieved 
---
## Part3 -  Running Application with Docker Compose and Automated Image Updates on VM
- On the VM, use docker compose to run the application. Make sure you configure
the proper health checks.
   - I previously used simple docker-compose in part 1 in my local But i wanted to Enhance it
      - Implemented changes to enable better control over development and production  
          - Edit package.json to has "devDependencies" to has packages only using in development 
          - Split the Docker Compose setup into a main file and two environment specific configurations like (target,Volumes,...)
          - Used MultiStage Dockerfile to **enhance organization – separate stages for development and production - make Dockerfiles cleaner**
    Then Login to vm on aws
       - installed docker-compose 
       - Cloned My repo
       - pulled docker image that declared in docker-compose file from dockerhub repository by
       ```bash
       docker-compose pull
       ```
       - Run container with pulled image using docker-compose
       ```
       docker-compose -f (main-compose-file).yml -f (specific-file).yml up -d
       ```
![](https://github.com/horiaahmed/DevOps-Internship-Assessment-Todo-List-Nodejs/blob/main/assets/screenshots/2025-07-29.png)














  
