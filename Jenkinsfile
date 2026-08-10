pipeline {
    agent any
    environment {
        PATH = "$HOME/.local/bin:$PATH"
        IMAGE_NAME = "had"
        IMAGE_TAG  = "1.0.${BUILD_NUMBER}"
        CONTAINER_NAME = "had-app"
        VOLUME_NAME = "had-venv"
    }
    stages {
        stage('Build Python .Whl file') {
            steps {
                sh '''
                set -eux
                curl -LsSf https://astral.sh/uv/install.sh | sh
                uv python install 3.10
                which python3.10 
                python3.10 --version
                rm -rf .venv
                uv venv --python 3.10
                rm -rf dist build *.egg-info
                uv build
                '''
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                          -Dsonar.projectKey=HAD \
                          -Dsonar.projectName='HAD'
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }
        stage('Push Docker Image to GHCR') {
    steps {
        withCredentials([
            string(
                credentialsId: 'github-token',
                variable: 'GITHUB_TOKEN'
            )
        ]) {
            sh '''
                set -e

                echo "$GITHUB_TOKEN" | docker login ghcr.io \
                    -u vinaykumarshetkar \
                    --password-stdin

                docker tag \
                    ${IMAGE_NAME}:${IMAGE_TAG} \
                    ghcr.io/team-devops-maverick/had:${IMAGE_TAG}

                docker push \
                    ghcr.io/team-devops-maverick/had:${IMAGE_TAG}
            '''
        }
    }
}
        stage('Stop Old Container') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    echo "Removing previous stopped container..."
                    docker rm -f had-app 2>/dev/null || true
                '''
            }
        }
        stage('Create Docker Volume') {
    steps {
        sh '''
            if docker volume inspect had-venv >/dev/null 2>&1; then
                echo "Docker volume 'had-venv' already exists"
            else
                echo "Creating Docker volume 'had-venv'"
                docker volume create had-venv
            fi
        '''
    }
}
                stage('Run Updated Container') {
            steps {
                sh '''
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 5000:5000 \
                        -v ${VOLUME_NAME}:/app/.venv \
                        ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }
}
