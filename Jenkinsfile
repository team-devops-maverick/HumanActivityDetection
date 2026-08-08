pipeline {

    agent any

    environment {
        IMAGE_NAME = "had"
        IMAGE_TAG = "1.0.${BUILD_NUMBER}"
        CONTAINER_NAME = "had-app"
        VOLUME_NAME = "had-venv"
    }

    stages {

        stage('Build Python WHL') {
    steps {
        bat '''
            @echo on

            echo ==============================
            echo Jenkins user
            echo ==============================
            whoami

            echo ==============================
            echo Installing uv
            echo ==============================

            powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"

            set "PATH=%USERPROFILE%\\.local\\bin;%PATH%"

            where uv
            uv --version

            echo ==============================
            echo Installing Python 3.10
            echo ==============================

            uv python install 3.10

            uv python find 3.10

            uv run --python 3.10 python --version

            echo ==============================
            echo Cleaning old build files
            echo ==============================

            if exist .venv rmdir /s /q .venv
            if exist dist rmdir /s /q dist
            if exist build rmdir /s /q build

            for /d %%D in (*.egg-info) do rmdir /s /q "%%D"

            echo ==============================
            echo Building WHL
            echo ==============================

            uv build

            set "BUILD_RESULT=%ERRORLEVEL%"

            if not "%BUILD_RESULT%"=="0" (
                echo ==============================
                echo UV BUILD FAILED
                echo ERROR CODE: %BUILD_RESULT%
                echo ==============================
                exit /b %BUILD_RESULT%
            )

            echo ==============================
            echo Build completed
            echo ==============================

            dir dist
        '''
    }
}

        stage('Build Docker Image') {
            steps {
                bat '''
                    @echo on

                    docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
                '''
            }
        }

        stage('Stop Old Container') {
            steps {
                bat '''
                    @echo on

                    echo Stopping old container...

                    docker rm -f %CONTAINER_NAME% 2>nul || echo No existing container found.
                '''
            }
        }

        stage('Create Docker Volume') {
            steps {
                bat '''
                    @echo on

                    echo Checking Docker volume...

                    docker volume inspect %VOLUME_NAME% >nul 2>&1

                    if %ERRORLEVEL% EQU 0 (
                        echo Docker volume "%VOLUME_NAME%" already exists.
                    ) else (
                        echo Creating Docker volume "%VOLUME_NAME%".
                        docker volume create %VOLUME_NAME%
                    )
                '''
            }
        }

        stage('Run Updated Container') {
            steps {
                bat '''
                    @echo on

                    echo Starting updated container...

                    docker run -d ^
                        --name %CONTAINER_NAME% ^
                        -p 5000:5000 ^
                        -v %VOLUME_NAME%:/app/.venv ^
                        %IMAGE_NAME%:%IMAGE_TAG%
                '''
            }
        }

        stage('Verify Container') {
            steps {
                bat '''
                    @echo on

                    timeout /t 10 /nobreak

                    docker ps -a --filter "name=%CONTAINER_NAME%"

                    echo.
                    echo Container logs:
                    docker logs %CONTAINER_NAME%
                '''
            }
        }
    }
}
