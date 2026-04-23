# devops_projekt

Zum Pullen des Docker-Image des Projektes:
  docker pull ghcr.io/kaktus1234567890/devops:test

Anschließend zur Nutzung:
  docker run -p 5000:5000 -v $(pwd)/data:/app/data  -e Data__Directory=/app/data ghcr.io/kaktus1234567890/devops:test
