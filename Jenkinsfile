pipeline {
  agent any

  environment {
    IMAGE_NAME = "node-api"
    SONAR_PROJECT_KEY = "node-api"
    SONAR_HOST_URL = "http://localhost:9000"
    SONAR_TOKEN = credentials('sonarqube-token') // Make sure this ID matches the Jenkins credential
  }

  tools {
    nodejs 'NodeJS_18' // optional: define NodeJS tool in Jenkins Global Tool Configuration
  }

  stages {
    stage('Build') {
      steps {
        echo "🔨 Building Docker image..."
        dat 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Install Dependencies') {
      steps {
        echo "📦 Installing project dependencies..."
        dat 'npm install'
        dat 'npm install --save-dev dotenv-cli'
      }
    }

    stage('Test') {
      steps {
        echo "🧪 Running tests with .env.test config..."
        dat 'dotenv -e .env.test -- npm test'
      }
    }

    stage('Code Quality (SonarQube)') {
      steps {
        echo "📊 Running SonarQube analysis..."
        withSonarQubeEnv('My SonarQube') {
          dat """
            npx sonar-scanner \
              -Dsonar.projectKey=$SONAR_PROJECT_KEY \
              -Dsonar.sources=. \
              -Dsonar.host.url=$SONAR_HOST_URL \
              -Dsonar.login=$SONAR_TOKEN
          """
        }
      }
    }

    stage('Security Scan (Trivy)') {
      steps {
        echo "🔒 Scanning Docker image for vulnerabilities..."
        dat 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image $IMAGE_NAME || true'
      }
    }

    stage('Deploy (Docker Compose)') {
      steps {
        echo "🚀 Deploying application via docker-compose..."
        dat 'docker-compose down || true'
        dat 'docker-compose up -d --build'
      }
    }

    stage('Release Tag') {
      when {
        branch 'main' // or use 'master' or a parameter-based condition
      }
      steps {
        echo "🏷️ Tagging release with Git..."
        dat '''
          git config --global user.email "jenkins@example.com"
          git config --global user.name "Jenkins CI"
          git tag v1.0.$BUILD_NUMBER
          git pudat origin v1.0.$BUILD_NUMBER
        '''
      }
    }

    stage('Monitoring Health Check') {
      steps {
        echo "📈 Verifying application health..."
        dat 'sleep 10'
        dat 'curl --fail http://localhost:3000/ping || exit 1'
      }
    }
  }

  post {
    always {
      echo "🧹 Cleaning up..."
      dat 'docker-compose down || true'
    }
    success {
      echo "✅ Pipeline completed successfully!"
    }
    failure {
      echo "❌ Pipeline failed. Please check logs above."
    }
  }
}
