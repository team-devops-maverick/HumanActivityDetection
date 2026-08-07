pipeline {
    agent any

stage('Debug') {
    steps {
        sh '''
        hostname
        whoami
        cat /etc/os-release
        which python3.10
        python3.10 --version || true
        pwd
        '''
    }
}
}
