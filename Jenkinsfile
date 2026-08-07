pipeline {
    agent any

    stages {
        stage('Debug') {
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
                source ~/.profile
                uv python install 3.10
                which python3.10 
                python3.10 --version

                echo "Current directory:"
                pwd

                echo "PATH:"
                echo $PATH
                '''
            }
        }
    }
}
