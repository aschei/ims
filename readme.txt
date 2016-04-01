Using MEAN stack on Docker for the Instance Management Server
-------------------------------------------------------------

1. What is MEAN stack
---------------------
The MEAN stack consists of Mongo-DB, Express.js, Angular.js and Node.js.
While Node.js and Express.js represent the web application server side, 
Mongo-DB is used for persistence and Angular.js on the client side (in
the browser).

2. What is Docker
-----------------
Docker is a container-based virtualization system with less resource re-
quirements than virtual machines. It comes with the benefits to a) separate
concerns into separate containers and b) takes away the complexity of
interdependencies and configuration of multiple services that are used
together to form a solution. It eases orchestration.

3. What docker containers will be part of the solution
------------------------------------------------------
Two containers, one for the database backend (Mongo-DB), and one for the
web application.

4. Prerequisites on the hosting server
--------------------------------------
On the hosting machine, docker needs to be installed and started:
Debian: sudo yum install -y docker && sudo service docker start
Ubuntu: see this page: https://docs.docker.com/engine/installation/linux/ubuntulinux/

5. Setting up Mongo-DB container
--------------------------------
Mongo-DB container will be given an external data directory so that the
container can be thrown away without losing important data:
mkdir /srv/mongodb

This command will create the docker container:
docker create --name imsdb -v /srv/mongodb/:/data/db/  mongo

The name of the container will be imsdb. Using the -v option, we map mongo's
default data directory (/data/db) to the directory on the host machine.

6. Running Mongo-DB container as a service
------------------------------------------
Using an upstart-script, the container gets started automatically, it also
restarts it if for any reason the container stops.
File /etc/init/imsdb.conf:

description "IMS's Mongo-DB"
author "Me"
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  /usr/bin/docker start -a imsdb
end script


Having the script in place, the service can be started manually by issuing
start imsdb

7. Creating a new web app docker image for deployment
-----------------------------------------------------
To create a new docker image of the web application on a development machine,
one can simply issue:
docker build -t hype/ims .

(The Dockerfile has been created with the help of
https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)



8. Run a new web container
--------------------------

docker create --name ims -e "JWT_SECRET=<secret here>" --link imsdb:db -p 80:3000 hype/ims

* The JWT_SECRET is needed for Jason Web Tokens to work.
* The link statement connects the mongo db container to an alias "db".
* The  port mapping maps the http port to port 80 on host machine.

When the container has been successfully created, it can be started using an
upstart script or manually by issuing:
docker start ims


Now, you should be able to access the system on the hostsystem using
http://localhost

