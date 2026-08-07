pipeline {
    agent any

        environment {
        PATH = "$HOME/.local/bin:$PATH"
    }
    stages {
        stage('Setup Python') {
            steps {
                sh '''
                set -eux
                curl -LsSf https://astral.sh/uv/install.sh | sh
                uv python install 3.10
                which python3.10 
                python3.10 --version
                rm -rf .venv
                uv venv --python 3.10                
                uv build
                '''
            }
        }
    }
}
