FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src

COPY ["src/Mondol.FileService.Web/Mondol.FileService.Web.csproj", "src/Mondol.FileService.Web/"]
COPY ["src/Mondol.FileService.Authorization/Mondol.FileService.Authorization.csproj", "src/Mondol.FileService.Authorization/"]
COPY ["src/Mondol.FileService.Db/Mondol.FileService.Db.csproj", "src/Mondol.FileService.Db/"]
COPY ["src/Mondol.FileService.Service/Mondol.FileService.Service.csproj", "src/Mondol.FileService.Service/"]
RUN dotnet restore "src/Mondol.FileService.Web/Mondol.FileService.Web.csproj"

COPY . .
WORKDIR "/src/src/Mondol.FileService.Web"
RUN dotnet build "Mondol.FileService.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Mondol.FileService.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Mondol.FileService.Web.dll"]