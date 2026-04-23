# devops_projekt

##### Zum Pullen des Docker-Image des Projektes:
docker pull ghcr.io/kaktus1234567890/devops:test

##### Anschließend zur Nutzung:
docker run -p 5000:5000 -v $(pwd)/data:/app/data  -e Data__Directory=/app/data ghcr.io/kaktus1234567890/devops:test

#### Danach kann die folgende URL aufgerufen werden, um zum UI zu kommen:
http://localhost:5000/api/notes
