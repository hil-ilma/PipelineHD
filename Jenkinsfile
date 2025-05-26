pipeline {
  agent any

  environment {
    IMAGE_NAME = "node-api"
    SONAR_PROJECT_KEY = "node-api"
    SONAR_HOST_URL = "http://localhost:9000"
    SONAR_TOKEN = credentials('sonarqube-token')
  }

  stages {
    stage('Build') {
      steps {
        echo "🔨 Building Docker image..."
        sh 'docker build -t $IMAGE_NAME -f Dockerfile .'
      }
    }

  stage('Test') {
    steps {
      echo "🧪 Running stateless tests inside Docker..."
      sh 'docker-compose -f docker-compose.test.yml up --abort-on-container-exit --build --exit-code-from api'
    }
  }




// stage('Code Quality (SonarQube)') {
//     agent {
//         docker { image 'node' }
//     }
//     steps {
//         script {
//             docker.image('sonarsource/sonar-scanner-cli').inside {
//                 withSonarQubeEnv('sonarqube-token') {
//                     sh '''
//                     sonar-scanner -Dsonar.projectKey=node-api -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.login=$SONAR_TOKEN
//                     '''
//                 }
//             }
//         }
//     }
// }




    stage('Security Scan (Trivy)') {
      steps {
        echo "🔒 Scanning Docker image for vulnerabilities..."
        sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image $IMAGE_NAME'
      }
    }

  stage('Deploy (Docker Compose)') {
    steps {
      echo '🚀 Deploying with Docker Compose...'
      sh 'docker rm -f mysql-db || true'
      sh 'docker-compose down'
      sh 'docker-compose up -d --build'
    }
  }


stage('Monitoring Health Check') {
  when {
    expression {
      currentBuild.currentResult == 'SUCCESS' || currentBuild.currentResult == 'UNSTABLE'
    }
  }
  steps {
    echo '📊 Running health checks...'
    // Add your actual health check command here
  }
}

  }

    post {
  always {
    stage('Monitoring Health Check') {
      steps {
        echo '📊 Running health checks...'
        // curl http://localhost:3000/health or similar
      }
    }
  }
}
post {
  always {
    stage('Monitoring Health Check') {
      steps {
        echo '📊 Running health checks...'
        // curl http://localhost:3000/health or similar
      }
    }
  }
}


}
