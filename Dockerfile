FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY ./publish .

ENV ASPNETCORE_URLS="http://0.0.0.0:5000"
ENV ASPNETCORE_HTTP_PORTS=""
ENV ASPNETCORE_HTTPS_PORTS=""

EXPOSE 5000

#TODO: Replace C#_Start.dll with the actuall file path
ENTRYPOINT ["dotnet", "BestNote.dll"]
