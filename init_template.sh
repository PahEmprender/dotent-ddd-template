dotnet new sln -n DDDTemplate && \
dotnet new classlib -n DDDTemplate.Domain -o src/domain && \
dotnet new classlib -n DDDTemplate.Application -o src/application && \
dotnet new webapi -n DDDTemplate.API -o src/api && \
dotnet new classlib -n DDDTemplate.Infrastructure.Persitance -o src/infrastructure/persitance && \
dotnet new xunit -n DDDTemplate.UnitTests -o tests/unittest && \
dotnet new xunit -n DDDTemplate.IntegrationTests -o tests/integration && \
dotnet sln DDDTemplate.sln add src/domain/DDDTemplate.Domain.csproj && \
dotnet sln DDDTemplate.sln add src/application/DDDTemplate.Application.csproj && \
dotnet sln DDDTemplate.sln add src/api/DDDTemplate.API.csproj && \
dotnet sln DDDTemplate.sln add src/infrastructure/persitance/DDDTemplate.Infrastructure.Persitance.csproj && \
dotnet sln DDDTemplate.sln add tests/unittest/DDDTemplate.UnitTests.csproj && \
dotnet sln DDDTemplate.sln add tests/integration/DDDTemplate.IntegrationTests.csproj