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


  
