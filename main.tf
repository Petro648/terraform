provider "google" {
 // credentials = "var.credentials"
  credentials = "${file("C:/Git-1/terraform1/Keys/terraform-1-125-0acec1141512.json")}"
  project     = var.project
  region      = var.region
  zone        = var.zone
  }

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "g1-small"

   tags = ["jenkins","http-server"]

   metadata = {
sshKeys = "petro:${file("C:/Git-1/terraform1/Keys/cloud.pub")}"
   }

   boot_disk {
    initialize_params {
      image = "centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {}
      // Ephemeral IP
    }  

connection {
    user = "petro"
    host = "${google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip}"
    private_key = "${file("C:/Git-1/terraform1/Keys/cloud")}"
    agent = false  
  } 


provisioner "remote-exec" {
      inline = [
        sudo yum install java-1.8.0-openjdk-devel -y;
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo yum install -y maven git

sudo bash -c 'cat > /etc/profile.d/java8.sh <<EOF
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
EOF'
sudo bash -c 'cat > /etc/profile.d/maven.sh <<EOF
export M2_HOME=/usr/share/maven/
export MAVEN_HOME=/usr/share/maven/
EOF'
source /etc/profile.d/java8.sh
source /etc/profile.d/maven.sh

sudo mkdir /var/lib/jenkins/init.groovy.d/
bash -c "cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
#!groovy
import jenkins.model.*
import hudson.security.*
def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','Qwerty123!')
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF"
sudo systemctl start jenkins
sudo sleep 50s
sudo systemctl enable jenkins
sudo systemctl restart jenkins
sudo rm -rf /var/lib/jenkins/init.groovy.d

java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:Qwerty123! -s "http://localhost:8080/" install-plugin trilead-api `
`dk-tool workflow-support script-security command-launcher workflow-cps bouncycastle-api handlebars  locale `
`javadoc momentjs structs workflow-step-api scm-api workflow-api junit apache-httpcomponents-client-4-api `
`pipeline-input-step display-url-api mailer credentials ssh-credentials jsch maven-plugin git-server token-macro `
`pipeline-stage-step run-condition matrix-project conditional-buildstep parameterized-trigger git git-client `
`workflow-scm-step cloudbees-folder timestamper pipeline-milestone-step workflow-job jquery-detached jackson2-api `
`branch-api ace-editor pipeline-graph-analysis pipeline-rest-api pipeline-stage-view pipeline-build-step `
`plain-credentials credentials-binding pipeline-model-api pipeline-model-extensions workflow-cps-global-lib `
`workflow-multibranch authentication-tokens docker-commons durable-task workflow-durable-task-step `
`workflow-basic-steps docker-workflow pipeline-stage-tags-metadata pipeline-model-declarative-agent `
`pipeline-model-definition workflow-aggregator lockable-resources -deploy
sudo sleep 30s
sudo systemctl restart jenkins
      ]
  }
}    