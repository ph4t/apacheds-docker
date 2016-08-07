# Intro

This Docker image provides an [ApacheDS](https://directory.apache.org/apacheds/) Server. 
It's based on [java:7-alpine](https://github.com/docker-library/openjdk/blob/54c64cf47d2b705418feb68b811419a223c5a040/7-jdk/alpine/Dockerfile) to reduce the image size and overhead.

# Usage

To run, use this command 

    docker run --name apacheds -d -p 389:10389 mriedmann/apacheds
	
for persistance mount the "instances"-volume to a host-directory

    docker run --name apacheds -d -p 389:10389 -v /var/apacheds:/opt/apacheds/instances mriedmann/apacheds
	
or use data-only containers

# Configuration

Application-specific configurations should be done with [ApacheDirectoryStudio](https://builds.apache.org/job/dir-studio/lastSuccessfulBuild/artifact/trunk/product/target/products/) (use latest Snapshot to avoid some critical bugs on config-saving)

# Contribution

Issues and Pull-Requests on Github are highly welcomed
	


