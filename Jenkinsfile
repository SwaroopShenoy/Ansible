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
        def tagv="${sh(returnStdout: true, script: 'git describe --tags')}"
        //env.GIT_TAG = tag
        echo "commit tag=${tagv}"
        env.GIT_TAG = tagv
        }
        sh 'cd Ansible;docker build -t ${IMAGE_URI}:${GIT_TAG} .'
      }
    }

    stage('Push') {
      steps {
        sh 'sudo aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 265364535788.dkr.ecr.ap-south-1.amazonaws.com'
        sh 'sudo docker push ${IMAGE_URI}:${GIT_TAG}'
      }
    }

     stage('Notify') {
            steps {
                script{
                def builds = env.BUILD_TAG
                def statusm = currentBuild.currentResult
                env.build=builds
                env.status=statusm
                }
                echo '${build}'
                echo '${status}'
                googlechatnotification message: "Build ${build} for ${GIT_TAG} has completed with a ${status} status!", url: 'https://chat.googleapis.com/v1/spaces/AAAA22ZS4gI/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=GxnRPD10DGQA9shTvXmhG6xY7fnZK6tX9S_4wV6_aEI'
            }
        }
  }
}
