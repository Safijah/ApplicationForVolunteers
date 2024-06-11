#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
# Adjust the path to the project file
COPY ["RadVolontera/RadVolontera/RadVolontera.csproj", "RadVolontera/"]
RUN dotnet restore "RadVolontera/RadVolontera.csproj"
COPY . .
WORKDIR "/src/RadVolontera"
RUN dotnet build "RadVolontera.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "RadVolontera.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RadVolontera.dll"]
