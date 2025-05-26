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
    sh '''
      docker-compose -f docker-compose.test.yml down --remove-orphans || true
      docker rm -f test-mysql || true
      docker network rm pipelinetaskhd_default || true
      docker-compose -f docker-compose.test.yml up -d test-mysql
      sleep 10
      docker-compose -f docker-compose.test.yml run --rm api sh -c "cross-env NODE_ENV=test NODE_OPTIONS=--experimental-vm-modules dotenv -e .env.jenkins -- jest --coverage"
      docker-compose -f docker-compose.test.yml down --remove-orphans || true
    '''
  }
}





    stage('Code Quality (SonarQube)') {
      steps {
        echo "📊 Running SonarQube analysis..."
        withSonarQubeEnv('My SonarQube') {
          sh '''
            npx sonar-scanner \
              -Dsonar.projectKey=$SONAR_PROJECT_KEY \
              -Dsonar.sources=. \
              -Dsonar.host.url=$SONAR_HOST_URL \
              -Dsonar.login=$SONAR_TOKEN
          '''
        }
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
      sh 'docker-compose down || true'
    }
    success {
      echo "✅ Pipeline completed successfully!"
    }
    failure {
      echo "❌ Pipeline failed. Please check logs above."
    }
  }
}
