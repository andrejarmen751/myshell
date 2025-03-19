## links install and initial config:
# Kubernetes Manifests for Jenkins Deployment

Refer https://devopscube.com/setup-jenkins-on-kubernetes-cluster/ for step by step process to use these manifests.

    - https://www.jenkins.io/doc/book/installing/kubernetes/
    - https://devopscube.com/jenkins-build-agents-kubernetes/
    - https://devopscube.com/build-docker-image-kubernetes-pod/

## links configs CI/CD

    - https://www.sparksupport.com/blog/2020/02/11/ci-cd-pipeline-using-jenkins-and-gogs-tutorial/


## initial pass at:

    - $JENKINS_HOME/secrets/initialAdminPassword


1. install - files to install jenkins
2. setup haproxy, initial config (disable CRFS) and install plugins (strict scrumb(if not ssl install) - kubernetes) 
3. Plugin kubernetes:
   - http://jenkins-service.jenkins.svc.cluster.local:8080
   - pod label: jenkins - agent