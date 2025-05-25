pipeline {
  agent any

  environment {
    IMAGE_NAME = "node-api"
    SONAR_PROJECT_KEY = "node-api"
    SONAR_HOST_URL = "http://localhost:9000"
    SONAR_TOKEN = credentials('sonarqube-token') // Add in Jenkins credentials
  }

  stages {
    stage('Build') {
      steps {
        echo "🔨 Building Docker image..."
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Test') {
      steps {
        echo "🧪 Running tests with .env.test config..."
        sh 'npm install'
        sh 'npm install --save-dev dotenv-cli'
        sh 'npm test'
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
        echo "🚀 Deploying application via docker-compose..."
        sh 'docker-compose down || true'
        sh 'docker-compose up -d --build'
      }
    }

    stage('Release Tag') {
      steps {
        echo "🏷️ Tagging release with Git..."
        sh '''
          git config --global user.email "jenkins@example.com"
          git config --global user.name "Jenkins CI"
          git tag v1.0.$BUILD_NUMBER
          git push origin v1.0.$BUILD_NUMBER
        '''
      }
    }

    stage('Monitoring Health Check') {
      steps {
        echo "📈 Verifying application health..."
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
