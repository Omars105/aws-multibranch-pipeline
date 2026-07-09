#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."
                }
            }
        }

        stage("build") {
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    def dockerCmd = 'docker run -p 3080:3080 -d  omar1015/omar-test:latest'
                    echo "Deploying the application..."
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@16.16.100.205 ${dockerCmd}"
                    }
                }
            }
        }
    }
}
