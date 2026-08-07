pipeline {
    agent any

        environment {
        PATH = "$HOME/.local/bin:$PATH"
    }
    stages {
        stage('Setup Python') {
            steps {
                sh '''
                echo "Hostname:"
                hostname

                echo "User:"
                whoami

                echo "OS:"
                cat /etc/os-release

                echo "Python:"
                curl -LsSf https://astral.sh/uv/install.sh | sh
                uv python install 3.10
                which python3.10 
                python3.10 --version

                echo "Current directory:"
                pwd

                echo "PATH:"
                echo $PATH
                rm -rf .venv
                uv venv --python 3.10                
                source .venv/bin/activate
                uv sync
                '''
            }
        }
    }
}
