#  DevOps Internship Assessment - 📝Todo List App

This project demonstrates DevOps skills by building, deploying, and automating a Node.js Todo API using Docker, GitHub Actions, Ansible, Docker Compose, and optionally Kubernetes with ArgoCD.

---
## Features

- Dockerized App: Package the Node.js application in a Docker container for consistent deployment.
- GitHub Actions CI/CD: Automate Docker image build and push to Docker Hub on every code push using GitHub Actions.
- Ansible Automation: Use Ansible to install Docker and it should run from My local machine against the VM.
- Used docker compose to run the application instead of docker build.
- With auto update part like (Watchtowr).
- Process Advanced with Kubernetes on the VM.
---

## Project Steps
###  Part 1 – Application Setup & CI Pipeline
- Clone Repo https://github.com/Ankit6098/Todo-List-nodejs 
```bash
  git clone https://github.com/Ankit6098/Todos-nodejs
```
- Use Your Own MongoDB Database: Update the .env file with My MongoDB Atlas connection string.
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





  
