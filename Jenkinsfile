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
                which python3.10 || true
                python3.10 --version || true

                echo "Current directory:"
                pwd

                echo "PATH:"
                echo $PATH
                '''
            }
        }
    }
}
