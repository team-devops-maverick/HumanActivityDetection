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
        stage('Test Wheel') {
    steps {
        sh '''
        rm -rf test-env

        python3.10 -m venv test-env
        . test-env/bin/activate

        pip install dist/*.whl

        pip show humanactivitydetection

        python -c "import humanactivitydetection; print('Wheel installed successfully')"
        '''
    }
}
    }
}
