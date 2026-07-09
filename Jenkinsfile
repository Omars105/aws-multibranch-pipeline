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
        stage("init") {
            steps {
                script {
                    gv = load "Groovy.script.groovy"
                }
            }
        }
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
                    def dockerCmd = "docker run -p 8080:8080 -d ${env.IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@16.16.100.205 ${dockerCmd}"
                    }
                }
            }
        }
    }
}