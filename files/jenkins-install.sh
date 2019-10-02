#!/bin/sh

# Install Jenkins and Java

sudo yum install java-1.8.0-openjdk-devel -y; 
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false;
sudo yum install wget -y;
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo;
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key;
sudo yum install jenkins -y;
sudo yum install maven git -y

 export JAVA_HOME=/usr/lib/jvm/java
 export PATH=$PATH:$JAVA_HOME/bin
 export M3_HOME=/usr/share/maven/
 export MAVEN_HOME=/usr/share/maven/
 export PATH=$PATH:$MAVEN_HOME/bin

# Automate Jenkins admin user setup

sudo mkdir /var/lib/jenkins/init.groovy.d/
sudo bash -c "cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
#!groovy

import jenkins.model.*
import hudson.security.*


def instance = Jenkins.getInstance()
println \"--> creating local user 'admin' \"
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','Qwerty123!')
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF"
sudo systemctl start jenkins.service
sudo sleep 30
sudo systemctl enable jenkins.service
sudo sleep 30
sudo systemctl stop jenkins.service
sudo sleep 30
sudo rm -rf /var/lib/jenkins/init.groovy.d

# Install Jenkins Plugins

 java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:123! -s "http://localhost:8080/" install-plugin trilead-api `
`jdk-tool workflow-support script-security command-launcher workflow-cps bouncycastle-api handlebars  locale `
`javadoc momentjs structs workflow-step-api scm-api workflow-api junit apache-httpcomponents-client-4-api `
`pipeline-input-step display-url-api mailer credentials ssh-credentials jsch maven-plugin git-server token-macro `
`pipeline-stage-step run-condition matrix-project conditional-buildstep parameterized-trigger git git-client `
`workflow-scm-step cloudbees-folder timestamper pipeline-milestone-step workflow-job jquery-detached jackson2-api `
`branch-api ace-editor pipeline-graph-analysis pipeline-rest-api pipeline-stage-view pipeline-build-step `
`plain-credentials credentials-binding pipeline-model-api pipeline-model-extensions workflow-cps-global-lib `
`workflow-multibranch authentication-tokens docker-commons durable-task workflow-durable-task-step `
`workflow-basic-steps docker-workflow pipeline-stage-tags-metadata pipeline-model-declarative-agent `
`pipeline-model-definition workflow-aggregator lockable-resources -deploy
sudo sleep 30
sudo systemctl start jenkins.service
sudo sleep 30
sudo systemctl restart jenkins.service
sudo sleep 30


# Install CLI for Jenkins
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:admin -s "http://localhost:8080/" safe-restart