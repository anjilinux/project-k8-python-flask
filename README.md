# kubernetes-docker-python-flask
This is a Python Flask web application using [K8s](https://kubernetes.io/), [Docker](https://www.docker.com/), [Python Flask](http://flask.pocoo.org/) and [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/) as a service. 

## Architecture
This K8s architecture consists of one Node and one Pods using Deployment and the NodePort service for external site accessibility. The Node will reside within the Namespace `flask-namespace` and the bulk of the configuration can be found within the `kubernetes-docker-python-flask.yml`.

<img width="627" alt="image" src="https://user-images.githubusercontent.com/83971386/194745323-024095ca-8e8a-4f27-9482-ae5905dd556f.png">

## Build Process
This section details the steps required to deploy your own docker image onto Kubernetes.

## Prerequisites
* Minikube installation - [steps](https://minikube.sigs.k8s.io/docs/start/)
* Virtualbox installation - [steps](https://www.virtualbox.org/wiki/Downloads)
* Docker installation - [steps](https://docs.docker.com/engine/install/)

###	1. Create a Dockerfile 
      FROM ubuntu
      MAINTAINER BJWRD "brad.whitcomb97@gmail.com" # Change the name and email address accordingly
      RUN apt-get update \
          && apt-get install -y python3 \
          && apt-get install -y python3-pip \
          && pip install flask

      #Copy the app.py file from the current folder to /opt inside the container
      COPY app.py /opt/app.py

      ENTRYPOINT FLASK_APP=/opt/app.py flask run --host=0.0.0.0 --port=8080

### 2. Build an image from the Dockerfile
      docker build -t bjwrd/app.py .

### 3. Validate that your image exists
      docker images

### 4. Log into your public Docker Hub Repository (using your credentials)
      docker login
      
### 5. Push your newly created Docker image on to the Docker Hub repo 
      docker push bjwrd/app.py
      
### 6. Create a manifest file for your deployment (must include your image name)
      spec:
       containers:
       - name: bjwrd
         image: bjwrd/app.py:latest
         ports:
         - containerPort: 8080
           name: http-webapp-svc
           
### 7. Build and create your pod 
      kubectl create -f kubernetes-docker-python-flask.yml
      
### 8. Verify that your pod is successfully running 
      kubectl get pod -o wide
      
## How to Apply/Destroy
This section details the deployment and teardown of the kubernetes-docker-python-flask architecture. 

### Deployment steps

###	1. Clone the kubenetes-simple-webapp repo
     git clone https://github.com/BJWRD/kubernetes-docker-python-flask.git

### 2. Start the minikube instance within Virtualbox
     minikube start --driver=virtualbox

### 3. Create the flask-namespace using kubectl
     kubectl create -f namespace-definition.yml

### 4. Create the bulk of the Kubernetes resources (Deployment & Service)
     kubectl create -f kubernetes-docker-python-flask.yml
     
### 5. Verify the Minikube's external IP address and service list
     minikube ip
     minikube service list
<img width="610" alt="image" src="https://user-images.githubusercontent.com/83971386/194745134-8f899ab9-3afa-4491-b0be-d96033f8759e.png">

### 6. Test site accessibility

    curl http://<MinikubeIP>:30080
    
- Also, try from a web browser specifying the Host's IP Address

      http://<MinikubeIP>:30080

### Teardown steps

### 1. Delete the deployed K8's infrastructure
     kubectl delete -f namespace-definition.yml
     kubectl delete -f kubernetes-docker-python-flask.yml
    
### 2.  Delete the running minikube instance
     minikube delete

## List of tools/services used
* [Docker](https://www.docker.com/)
* [Dockerfile](https://docs.docker.com/engine/reference/builder/)
* [Docker Hub](https://hub.docker.com/)
* [Minikube](https://minikube.sigs.k8s.io/docs/)
* [K8s Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
* [Services- NodePort](https://kubernetes.io/docs/concepts/services-networking/service/)
* [Draw.io](https://www.draw.io/index.html)
