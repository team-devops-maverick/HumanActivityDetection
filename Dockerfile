FROM python:3.10-slim

WORKDIR /app

# System dependencies required by OpenCV and Detectron2
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy only required files
COPY dist/*.whl .
COPY models ./models
COPY run.sh .

RUN chmod +x run.sh

EXPOSE 5000

CMD ["./run.sh"]
