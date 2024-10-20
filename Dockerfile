name: Build and Test Django App

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      # Set up Docker
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      # Log in to DockerHub
      - name: Log in to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # Build the Docker image
      - name: Build the Docker image
        run: docker build . -t juneshg/rhino_returns:latest

      # Push the Docker image to DockerHub
      - name: Push the Docker image
        run: docker push juneshg/rhino_returns:latest

      # Run the container and capture its ID
      - name: Run the container
        run: docker run -d -p 8000:8000 juneshg/rhino_returns:latest
        id: container_id

      # Run Pytest in the container
      - name: Run Pytest tests
        run: docker exec ${{ steps.container_id.outputs.id }} pytest
