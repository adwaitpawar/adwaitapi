# Use the official .NET SDK image as the build image
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

WORKDIR /src
EXPOSE 50306

# Copy the project file and restore dependencies
COPY ["WebAPI.csproj", "./"]
RUN dotnet restore

COPY . .
RUN mkdir -p /app/Photos/  # Create the missing directory
RUN dotnet publish "WebAPI.csproj" -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:3.1

WORKDIR /app
COPY --from=build /app .

VOLUME /app/Photos

ENTRYPOINT ["dotnet", "WebAPI.dll"]

