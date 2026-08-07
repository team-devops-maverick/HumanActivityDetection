pipeline {
    agent any

    stages {

stage('Checkout') {
    steps {
        git branch: 'new',
            credentialsId: 'githubToken',
            url: 'https://github.com/team-devops-maverick/HumanActivityDetection.git'
    }
}

        stage('Create Virtual Environment') {
            steps {
                sh '''
                rm -rf .venv
            python --version
            python3.10 -m venv .venv
                    . .venv/bin/activate

                    pip install --upgrade pip
                    pip install uv build
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    . .venv/bin/activate
                    uv sync
                '''
            }
        }

        stage('Build Wheel') {
            steps {
                sh '''
                    . .venv/bin/activate
                    python -m build --wheel
                '''
            }
        }

        stage('Archive Wheel') {
            steps {
                archiveArtifacts artifacts: 'dist/*.whl', fingerprint: true
            }
        }
    }
}
