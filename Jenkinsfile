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
    sh 'docker rm -f node-api mysql-db || true'
    sh 'docker-compose down --remove-orphans'
    sh 'docker-compose up -d --build'
  }
}


stage('Monitoring') {
  steps {
    echo '📈 Simulating Monitoring (Health & Logs)...'
    script {
      sh 'sleep 5' // give app time to boot
      sh 'docker ps -a'
sh 'docker logs node-api || true'
      def health = sh(script: "docker exec node-api wget -qO- http://localhost:3000/health || echo 'fail'", returnStdout: true).trim()
      if (health == 'fail') {
        echo "❌ Health endpoint not available"
      } else {
        echo "✅ Health check passed"
      }
    }
  }
}


    stage('Release') {
  
  steps {
    echo '🏷️ Creating Release Tag and Preparing Artifact...'
    sh """
      git config user.email "ci@pipeline.com"
      git config user.name "Jenkins CI"
      git tag -a v1.0.${BUILD_NUMBER} -m "Release v1.0.${BUILD_NUMBER}"
      git push origin v1.0.${BUILD_NUMBER}
    """
    echo '📦 Build artifact tagged successfully.'
  }
}


  }

  post {
  always {
    echo '📊 Running health checks...'
    sh 'sleep 5'
    sh 'docker exec node-api wget -qO- http://localhost:3000/health || echo "❌ Health check failed inside container"'
  }
}

}
