# devops_projekt

Diese Applikation ist für das Speichern von Notizen.
So läuft ein Microservice welcher aus einer REST API (geschrieben in C#) besteht.
Die Schnittstellen dieser erlauben es dem Nutzer eine Notiz oder mehrere  Notizen: 
- zu erstellen 
- zu bearbeiten
- zu löschen
- auszulesen <br/>

Um gewährleisten das die Notizen nach dem schließen erhalten bleiben werden diese nach jeder erfolgreichen Transkation in ein JSON-Datei gespeichert.

##### Zum Pullen des Docker-Image des Projektes:
docker pull ghcr.io/kaktus1234567890/devops:main

##### Anschließend zur Nutzung:
###### In der Shell
docker run -p 5000:5000 -v $(pwd)/data:/app/data  -e Data__Directory=/app/data ghcr.io/kaktus1234567890/devops:main
###### In PowerShell
docker run -p 5000:5000 -v ${PWD}/data:/app/data  -e Data__Directory=/app/data ghcr.io/kaktus1234567890/devops:main

#### Danach kann die folgende URL aufgerufen werden, um zum UI zu kommen:
http://localhost:5000/api/notes
