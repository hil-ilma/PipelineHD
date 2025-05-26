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
      sh 'docker-compose -f docker-compose.test.yml down --remove-orphans || true'
      sh 'docker-compose -f docker-compose.test.yml up --abort-on-container-exit --build --exit-code-from api'
    }
  }


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
        sh 'docker rm -f node-api || true'  // 🔧 Add this line
        sh 'docker-compose down --remove-orphans'
        sh 'docker-compose up -d --build'
      }
    }

  }

  post {
  always {
    echo '📊 Running health checks...'
    sh 'sleep 5'
    sh 'curl --fail http://localhost:3000/health || echo "❌ Health check failed"'
  }
}

}
