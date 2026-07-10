#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [
        $class: 'GitSCMSource',
        remote: 'https://github.com/Omars105/Jenkins-shared-library.git',
        credentialsId: 'Github-jenkins-pat'
    ]
)



pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
  
    stages {
        stage('increment version') {
            steps {
                script {
                    echo "hello from increment version"
                    sh '''#!/bin/bash
mvn build-helper:parse-version versions:set \
-DnewVersion=\\${parsedVersion.majorVersion}.\\${parsedVersion.minorVersion}.\\${parsedVersion.nextIncrementalVersion}
'''
                    sh 'mvn versions:commit'

                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "${version}-${BUILD_NUMBER}"
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
                    
                    sshagent(['ec2-server-key']) {
                        def shellCmd = "bash ./server-Cmds.sh ${IMAGE_NAME}"
                        sh "scp server-Cmds.sh ec2-user@16.16.100.205:/home/ec2-user/"
                        sh "scp docker-compose.yaml ec2-user@16.16.100.205:/home/ec2-user/"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@16.16.100.205 ${shellCmd}"
                    }
                }
            }
        }
         stage('commit version in git') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Github-jenkins-pat', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                        sh "git config user.name ${GIT_USER}"
                        sh 'git config user.email "jenkins@example.com"'
                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'
                        sh "git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/Omars105/aws-multibranch-pipeline.git"
                        sh 'git add .'
                        sh "git commit -m 'version incremented to ${IMAGE_NAME}'"
                        sh 'git push origin HEAD:aws-multibranch-pipeline'
                    }
                }
            }
        }
    }
}