#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [
        $class: 'GitSCMSource',
        remote: 'https://github.com/Omars105/Jenkins-shared-library.git',
        credentialsId: 'Github-jenkins-pat'
    ]
)

def gv

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = "omar1015/omar-test:jma-4.0"
    }
    stages {
        stage("build jar") {
            steps {
                script {
                    buildJava()
                }
            }
        }
        stage("build,login and push docker image") {
            steps {
                script {
                    dockerBuild(env.IMAGE_NAME)
                    dockerlogin()
                    dockerpush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying docker image to EC2"
                    
                    sshagent(['ec2-server-key']) {
                        def dockerComposeCmd = "docker compose -f docker-compose.yaml up -d"
                        sh "scp docker-compose.yaml ec2-user@16.16.100.205:/home/ec2-user/"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@16.16.100.205 ${dockerComposeCmd}"
                    }
                }
            }
        }
    }
}