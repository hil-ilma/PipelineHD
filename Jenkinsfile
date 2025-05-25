pipeline {
  agent any

  environment {
    IMAGE_NAME = 'node-api'
    CONTAINER_NAME = 'node-api'
    DB_CONTAINER = 'companydb'
    TAG = "v1.0-${env.BUILD_NUMBER}"
  }

  stages {
    stage('Build') {
      steps {
        echo '🔧 Building Docker image...'
        sh 'docker build --no-cache -t $IMAGE_NAME .'
      }
    }

    stage('Test') {
      steps {
        echo '🧪 Starting Test Environment...'
        sh 'docker rm -f $CONTAINER_NAME || true'
        sh 'docker rm -f $DB_CONTAINER || true'
        sh 'docker-compose -f docker-compose.yml up -d --build'

        echo '🧪 Running Unit Tests...'
        sh 'sleep 10' // Wait briefly for DB to initialize
        sh 'docker exec $CONTAINER_NAME npm test || true'

        echo '🧹 Shutting down test containers...'
        sh 'docker-compose down || true'
      }
    }

    stage('Security Scan') {
      steps {
        echo '🔍 Running Trivy security scan...'
        sh 'trivy image $IMAGE_NAME || true'
      }
    }

    stage('Deploy') {
      steps {
        echo '🚀 Deploying app container...'
        sh 'docker rm -f $CONTAINER_NAME || true'
        sh '''
          docker run -d --name $CONTAINER_NAME \
          -p 3000:3000 \
          -e DB_HOST=host.docker.internal \
          -e DB_USER=root \
          -e DB_PASSWORD=1234 \
          -e DB_DATABASE=companydb \
          -e PORT=3000 \
          $IMAGE_NAME
        '''
      }
    }

    stage('Release') {
      steps {
        echo "🏷️ Tagging release: ${env.TAG}"
        sh "git config user.email 'jenkins@local' && git config user.name 'jenkins'"
        sh "git tag -a ${TAG} -m 'Release ${TAG}' || true"
        sh "git push origin ${TAG} || true"
      }
    }

    stage('Monitoring') {
      steps {
        echo '📋 Displaying last 10 log lines:'
        sh 'docker logs $CONTAINER_NAME --tail 10 || true'
      }
    }
  }

  post {
    failure {
      echo '❌ Build failed. Cleaning up...'
      sh 'docker-compose down || true'
    }
    success {
      echo '✅ Build completed successfully.'
    }
  }
}