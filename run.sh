#!/bin/bash
set -e

VENV="/app/.venv"

if [ ! -d "$VENV" ]; then

    echo "======================================"
    echo "First run: installing dependencies..."
    echo "======================================"

    python -m venv "$VENV"
    source "$VENV/bin/activate"

    pip install --upgrade pip
    pip install uv

    echo "Installing CPU PyTorch..."

    pip install \
        --index-url https://download.pytorch.org/whl/cpu \
        torch==1.13.1+cpu \
        torchvision==0.14.1+cpu

    echo "Installing Detectron2..."

    pip install \
        --no-build-isolation \
        git+https://github.com/facebookresearch/detectron2.git

    echo "Installing application wheel..."

    pip install /app/*.whl

else

    echo "======================================"
    echo "Existing environment found"
    echo "Skipping dependency installation"
    echo "======================================"

    source "$VENV/bin/activate"

fi

echo "======================================"
echo "Starting Human Activity Detection"
echo "======================================"

python -m app
