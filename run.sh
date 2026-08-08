#!/bin/bash
set -e

if [ ! -d ".venv" ]; then
    echo "First run: installing dependencies..."

    python -m venv .venv
    source .venv/bin/activate

    pip install --upgrade pip
    pip install uv

    pip install \
        --index-url https://download.pytorch.org/whl/cpu \
        torch==1.13.1+cpu \
        torchvision==0.14.1+cpu

    pip install \
        --no-build-isolation \
        git+https://github.com/facebookresearch/detectron2.git

    pip install *.whl
else
    source .venv/bin/activate
fi

python app.py
