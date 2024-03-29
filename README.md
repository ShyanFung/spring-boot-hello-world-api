## As Simple Maven & Java

#### Build with maven:
- ./mvnw clean install
- mvn clean install

#### Run as spring-boot:
- ./mvnw spring-boot:run
- mvn spring-boot:run

#### Test SwaggerUI (from running spring-boot):
- [localhost as unsecure on 8080](http://localhost:8080/swagger-ui.html)
- [localhost as secure on 8443](https://localhost:8443/swagger-ui.html)

#### Create self-signed cert:
Ref: [self-signed cert](https://www.baeldung.com/spring-boot-https-self-signed-certificate)

keytool -genkeypair -alias helloworld -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore helloworld.keystore.p12 -validity 3650

--- 

## IF Docker Setup

#### Build docker Image:
Ref. build-docker.sh
Ref. Dockerfile
Calls 'docker build ...'

#### List docker Built Images:
docker images

#### Run Containerized Service (as daemon):
docker run -d -t --rm --publish 8787:8080 --name hello-world-api hello-world-api:0.0.1-SNAPSHOT
docker run -d -t --rm --publish 8443:8443 --name hello-world-api hello-world-api:0.0.1-SNAPSHOT

#### Connect to running service's container:
docker exec -it hello-world-api sh

#### List running docker containers:
docker ps

#### Test SwaggerUI (from running container w/ port forwarding):
Open http://localhost:8787/swagger-ui.html

#### Stop/kill Docker Service:
docker kill hello-world-api
docker ps -a

#### Start/stop service/stack with docker-compose:
docker-compose up -d
docker-compose down

--- 

## IF Deploy to AWS

#### Push docker image to ECR (to run on ECS)
- Assumes you installed and setup your AWS CLI terminal
- Assumes you created ERC cluster on VPC with EC2 instances
- Assumes you created a repo on ECR, run script:
./wwsurv-api/aws-ecr-docker-tag-push-wwsurv-api-images.sh

#### Test SwaggerUI (from deployed image on AWS ECS)
- Assumes elastic ip is 3.208.128.124
- Assumes container port is mapped
Open http://3.208.128.124/swagger-ui.html
Open https://3.208.128.124/swagger-ui.html

#### AWS EC2 Instance Setup to connect to ECS Cluster:

##### Advanced > User data > :
<p> 
 #!/bin/bash
 echo ECS_CLUSTER=metron-dev-api >> /etc/ecs/ecs.config
</p>

##### Assign IAM role: 
- instance-profile/ecsInstanceRole
