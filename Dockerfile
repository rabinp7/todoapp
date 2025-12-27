###########################################
# Multi-stage build: Angular + ASP.NET Core
###########################################

# ---------- 1) Build Angular ----------
FROM node:20-alpine AS frontend-build
WORKDIR /src/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ ./
RUN npm run build -- --configuration production

# ---------- 2) Build .NET API ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS backend-build
WORKDIR /src

COPY backend/TodoApi/TodoApi.csproj backend/TodoApi/
RUN dotnet restore backend/TodoApi/TodoApi.csproj

COPY backend/ backend/
RUN dotnet publish backend/TodoApi/TodoApi.csproj \
    -c Release \
    -o /out \
    /p:UseAppHost=false

# ---------- 3) Runtime ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine
WORKDIR /app

COPY --from=backend-build /out ./
COPY --from=frontend-build /src/frontend/dist/todo-angular ./wwwroot

# Azure App Service expects port 80
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "TodoApi.dll"]