dotnet new sln -n $sourceName$ && \
dotnet new classlib -n $sourceName$.Domain -o src/domain && \
dotnet new classlib -n $sourceName$.Application -o src/application && \
dotnet new webapi -n $sourceName$.API -o src/api && \
dotnet new classlib -n $sourceName$.Infrastructure.Persitance -o src/infrastructure/persitance && \
dotnet new xunit -n $sourceName$.UnitTests -o tests/unittest && \
dotnet new xunit -n $sourceName$.IntegrationTests -o tests/integration && \
dotnet sln $sourceName$.sln add src/domain/$sourceName$.Domain.csproj && \
dotnet sln $sourceName$.sln add src/application/$sourceName$.Application.csproj && \
dotnet sln $sourceName$.sln add src/api/$sourceName$.API.csproj && \
dotnet sln $sourceName$.sln add src/infrastructure/persitance/$sourceName$.Infrastructure.Persitance.csproj && \
dotnet sln $sourceName$.sln add tests/unittest/$sourceName$.UnitTests.csproj && \
dotnet sln $sourceName$.sln add tests/integration/$sourceName$.IntegrationTests.csproj

# dotnet new sln -n DDDTemplate && \
# dotnet new classlib -n DDDTemplate.Domain -o src/domain && \
# dotnet sln DDDTemplate.sln add src/domain/DDDTemplate.Domain.csproj