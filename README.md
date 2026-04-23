# devops_projekt

Zum Pullen des Docker-Image des Projektes:\n
  docker pull ghcr.io/kaktus1234567890/devops:test

Anschließend zur Nutzung:\n
  docker run -p 5000:5000 -v $(pwd)/data:/app/data  -e Data__Directory=/app/data ghcr.io/kaktus1234567890/devops:test
