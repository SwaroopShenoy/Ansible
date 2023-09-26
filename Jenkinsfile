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
    //string(name: 'GIT_COMMIT', defaultValue: '')
    string(name: 'GIT_TAG', defaultValue: '')
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
        //hash="${sh(returnStdout: true, script: 'cd Ansible;git rev-parse HEAD')}"
        //tag="${sh(returnStdout: true, script: 'git describe --contains "$(cd Ansible;git rev-parse HEAD)"')}"
        def tag="${sh(returnStdout: true, script: 'git describe --tags')}"
        //env.GIT_TAG = tag
        echo "commit tag=${tag}"
        }
        sh 'cd Ansible;docker build -t ${IMAGE_URI}:${tag} .'
      }
    }

    stage('Push') {
      steps {
        sh 'sudo aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 265364535788.dkr.ecr.ap-south-1.amazonaws.com'
        sh 'sudo docker push ${IMAGE_URI}:${tag}'
      }
    }
  }
}
