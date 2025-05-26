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
      echo '🧪 Running tests with Docker Compose...'
      sh 'npm run test:ci'
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
        echo "🚀 Deploying with Docker Compose..."
        sh 'docker-compose down || true'
        sh 'docker-compose up -d --build'
      }
    }

    stage('Monitoring Health Check') {
      steps {
        echo "📈 Checking app health..."
        sh 'sleep 10'
        sh 'curl --fail http://localhost:3000/ping || exit 1'
      }
    }
  }

    post {
    always {
      echo "🧹 Cleaning up..."
      sh '''
        docker-compose -f docker-compose.test.yml stop || true
        docker-compose -f docker-compose.test.yml down --remove-orphans --volumes || true
        docker network prune -f || true
      '''
    }
    success {
      echo "✅ Pipeline completed successfully!"
    }
    failure {
      echo "❌ Pipeline failed. Please check logs above."
    }
  }

}
