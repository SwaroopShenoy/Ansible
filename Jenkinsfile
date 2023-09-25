pipeline {
  agent any
  triggers {
    githubPush()
  }
  environment {
    IMAGE_URI = 'public.ecr.aws/v1r4i9y3/imagepushpipelinetest'
    GIT_URL = 'https://github.com/SwaroopShenoy/Ansible.git'
  }
  parameters {
    string(name: 'GIT_COMMIT', defaultValue: '')
  }

  
  stages {
    stage('Checkout and clear older images') {
      steps {
        sh 'docker system prune -f -a'
        sh 'rm -rvf Ansible'
        sh "git clone ${GIT_URL}"
      }
     
    }
    
    
    stage('Build') {
      steps {
          script{
        hash="${sh(returnStdout: true, script: 'cd Ansible;git rev-parse HEAD')}"
        env.GIT_COMMIT = hash
        echo "commit hash=${GIT_COMMIT}"
        }
        //sh 'cp Dockerfile dockerfile'
        sh 'cd Ansible;docker build -t ${IMAGE_URI}:${GIT_COMMIT} .'
      }
    }

    stage('Push') {
      steps {
          script{
        echo "commit hash=${GIT_COMMIT}"
        }
        sh 'sudo docker push ${IMAGE_URI}:${GIT_COMMIT}'
      }
    }
  }
}
