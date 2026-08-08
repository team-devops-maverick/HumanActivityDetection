#!/bin/bash
set -e

VENV="/app/.venv"
WHEEL=$(ls /app/*.whl)

echo "======================================"
echo "Using wheel: $WHEEL"
echo "======================================"

if [ ! -f "$VENV/bin/activate" ]; then

    echo "First run: creating virtual environment"

    python -m venv "$VENV"

    source "$VENV/bin/activate"

    pip install --upgrade pip

    echo "Installing PyTorch CPU..."

    pip install \
        --index-url https://download.pytorch.org/whl/cpu \
        torch==1.13.1+cpu \
        torchvision==0.14.1+cpu

    echo "Installing Detectron2..."

    pip install \
        --no-build-isolation \
        git+https://github.com/facebookresearch/detectron2.git

    echo "Installing application wheel..."

    pip install "$WHEEL"

else

    source "$VENV/bin/activate"

    echo "Existing virtual environment found"

    if pip show humanactivitydetection > /dev/null 2>&1; then

        INSTALLED_VERSION=$(pip show humanactivitydetection |
            grep '^Version:' |
            awk '{print $2}')

        CURRENT_VERSION=$(basename "$WHEEL" |
            sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/')

        echo "Installed version: $INSTALLED_VERSION"
        echo "Current wheel version: $CURRENT_VERSION"

        if [ "$INSTALLED_VERSION" != "$CURRENT_VERSION" ]; then

            echo "======================================"
            echo "New application version detected"
            echo "Updating application wheel..."
            echo "======================================"

            pip install --force-reinstall "$WHEEL"

        else

            echo "Same application version"
            echo "Skipping application installation"

        fi

    else

        echo "Application not installed"
        echo "Installing application wheel..."

        pip install "$WHEEL"

    fi

fi

echo "======================================"
echo "Starting application"
echo "======================================"

python -m app
