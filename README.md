# DDD Solution Template

This template provides a foundational structure for building .NET applications following Domain-Driven Design (DDD) principles. It is packaged as a reusable solution to drive consistent and high-quality DDD implementations across multiple projects. The template includes predefined layers for Domain, Application, Infrastructure, and API, along with essential interfaces and utility classes to ensure robust design aligned with DDD best practices.

## Project Structure

The solution (`DDDTemplate.sln`) is organized into the following projects:

- **`DDDTemplate.Domain`**: Contains domain entities, value objects, aggregates, domain services, and repository interfaces. This layer encapsulates the core business logic.
- **`DDDTemplate.Application`**: Implements application services, commands, queries, and handlers using MediatR to orchestrate use cases.
- **`DDDTemplate.Infrastructure.Persitance`**: Provides implementations for repository interfaces and database context (e.g., using Entity Framework Core). Note: "Persitance" is a typo and should be corrected to "Persistence" in actual implementations.
- **`DDDTemplate.API`**: Hosts API endpoints to handle HTTP requests and integrate with the application layer.
- **`DDDTemplate.UnitTests`**: Contains unit tests for domain and application logic.
- **`DDDTemplate.IntegrationTests`**: Includes integration tests for infrastructure and API functionality.

This structure adheres to DDD's layered architecture, separating concerns to promote maintainability and scalability.

## Key Interfaces and Utilities

The following sections detail the interfaces and utilities provided by this package, their purposes, and justifications for inclusion. These components are designed to be generic and reusable while enforcing DDD principles.

### Domain Layer

The domain layer is the heart of the application, focusing on business logic and rules. The following interfaces and utilities standardize domain modeling:

- **`IRepository<T>`**
  - **Definition**: A generic interface for repositories, defining standard CRUD operations (e.g., `GetByIdAsync`, `AddAsync`, `UpdateAsync`, `DeleteAsync`) for aggregate roots.
  - **Justification**: Decouples the domain layer from persistence concerns, enabling flexibility in data access implementations and facilitating unit testing through mocking.
  - **Usage**: Define specific repository interfaces in the domain layer (e.g., `IOrderRepository : IRepository<Order>`) with domain-specific methods as needed, and implement them in the infrastructure layer.

- **`Entity`**
  - **Definition**: A base class for all entities, providing a unique identifier (e.g., `Guid Id`) and equality comparison logic.
  - **Justification**: Ensures consistent identity management and equality checks across all domain entities, a fundamental aspect of DDD.
  - **Usage**: Inherit from this class for all entity types in your domain model.

- **`AggregateRoot`**
  - **Definition**: A base class for aggregate roots, inheriting from `Entity`, with support for managing domain events (e.g., `AddDomainEvent`, `ClearDomainEvents`).
  - **Justification**: Enforces the aggregate pattern by providing a mechanism to handle domain events, ensuring consistency within aggregates and enabling event-driven communication.
  - **Usage**: Inherit from this class for aggregate roots and use it to raise events reflecting significant state changes.

- **`ValueObject`**
  - **Definition**: A base class for value objects, implementing equality based on property values rather than identity.
  - **Justification**: Promotes immutability and value-based equality, key characteristics of value objects in DDD, reducing complexity in domain modeling.
  - **Usage**: Inherit from this class for value objects like addresses or money amounts.

- **`IDomainEvent`**
  - **Definition**: A marker interface for domain events.
  - **Justification**: Allows for polymorphic handling of events and integrates with event-driven architectures, a common practice in DDD.
  - **Usage**: Implement this interface for all domain event classes (e.g., `OrderCreatedEvent`).

- **`DomainEvents`**
  - **Definition**: A static utility class for raising and handling domain events (e.g., `Raise` method).
  - **Justification**: Centralizes event dispatching logic, simplifying the integration of domain events with application or infrastructure layers.
  - **Usage**: Use `DomainEvents.Raise` within the domain layer to dispatch events to handlers or external systems.

- **`ISpecification<T>`**
  - **Definition**: An interface for the specification pattern, defining query criteria (e.g., `Expression<Func<T, bool>> Criteria`) and potentially other query aspects like includes or sorting.
  - **Justification**: Enables reusable, composable, and expressive query definitions, preventing repository interfaces from becoming cluttered with numerous query methods.
  - **Usage**: Implement this interface to define specifications (e.g., `ActiveOrdersSpecification`), and use them in repository methods like `GetAsync(ISpecification<T>)`.

### Infrastructure Layer

The infrastructure layer provides technical implementations for persistence and other external concerns. The following interfaces abstract these capabilities:

- **`IDatabaseContext`**
  - **Definition**: An interface for database operations, providing access to entity sets (e.g., `DbSet<T>`) and save functionality (e.g., `SaveChangesAsync`).
  - **Justification**: Abstracts the persistence layer, allowing for different ORM implementations (e.g., EF Core) or mocking in tests, while keeping the domain layer pure.
  - **Usage**: Implement this interface in the infrastructure layer, typically wrapping an ORM like Entity Framework Core's `DbContext`.

- **`IUnitOfWork`**
  - **Definition**: An interface for managing transactions (e.g., `SaveChangesAsync`), often combined with `IDatabaseContext`.
  - **Justification**: Ensures atomic commits across multiple repository operations, a critical aspect of maintaining data consistency in DDD.
  - **Usage**: Implement this interface to coordinate database transactions, often fulfilled by the same class implementing `IDatabaseContext`.

### Application Layer

The application layer orchestrates use cases and coordinates interactions between the domain and infrastructure layers. It leverages MediatR for command and query handling, as indicated by the `Directory.Packages.props` file including `MediatR.Extensions.Microsoft.DependencyInjection`. Key practices include:

- **MediatR Integration**: Uses `IRequest` and `IRequestHandler` interfaces provided by MediatR for commands (state-changing operations) and queries (read operations).
- **Validation**: Employs FluentValidation (version 11.2.2) for validating commands and queries, configurable via MediatR pipeline behaviors.
- **No Additional Interfaces**: Since MediatR provides sufficient abstractions, no custom interfaces are defined here, keeping the package lightweight and focused.

### Utilities

Beyond interfaces, the template provides utilities to streamline development:

- **Base Classes**: `Entity`, `AggregateRoot`, and `ValueObject` offer foundational implementations for domain modeling, reducing boilerplate code.
- **Domain Event Handling**: `DomainEvents` simplifies event dispatching, ensuring consistency in event-driven designs.
- **Specification Pattern**: `ISpecification<T>` supports advanced querying in a decoupled manner.

## Recommendations

To maximize the benefits of this package, consider the following recommendations:

- **Extensibility**
  - Extend repository interfaces with domain-specific methods as needed (e.g., `IOrderRepository.GetOverdueOrdersAsync`).
  - Add new domain events or properties to entities and aggregates to adapt to specific business requirements.
  - Use the specification pattern to encapsulate complex query logic, making it easy to extend data retrieval capabilities.

- **Maintainability**
  - Keep the domain layer free of infrastructure dependencies by relying solely on interfaces like `IRepository<T>` and dependency injection.
  - Centralize cross-cutting concerns (e.g., logging, validation) in MediatR pipeline behaviors to avoid duplicating logic across handlers.
  - Use the provided base classes to enforce consistent domain modeling practices across projects.

- **Testability**
  - Write unit tests for domain logic by mocking `IRepository<T>` and other interfaces, ensuring isolation from infrastructure concerns.
  - Leverage `IDatabaseContext` and `IUnitOfWork` to create test doubles for persistence testing.
  - Use the included `DDDTemplate.UnitTests` and `DDDTemplate.IntegrationTests` projects as starting points for comprehensive test suites, enhanced by tools like xUnit and coverlet (as per `Directory.Packages.props`).

## Getting Started

1. **Install the Template**: Use the .NET CLI to install this template package:
   ```bash
   dotnet new install PahEmprender.DDDTemplate.CSharp
   ```
2. **Create a New Solution**: Generate a new solution using the template:
   ```bash
   dotnet new pe-ddd -n YourProjectName
   ```
3. **Customize**: Replace placeholder classes (e.g., `Class1.cs`) with your domain entities, application handlers, and infrastructure implementations.
4. **Run**: Build and run the API project (`DDDTemplate.API`) to verify the setup.

This template leverages .NET 9.0, ensuring modern features like nullable reference types and implicit usings are enabled for cleaner code.

## Dependencies

The template includes the following key packages (managed centrally via `Directory.Packages.props`):
- **MediatR.Extensions.Microsoft.DependencyInjection** (10.0.1): For command/query handling and dependency injection.
- **FluentValidation** (11.2.2): For validating commands and queries.
- **Microsoft.AspNetCore.OpenApi** (9.0.2): For API documentation in the API layer.
- **xUnit**, **Microsoft.NET.Test.Sdk**, **coverlet.collector**: For unit and integration testing.

## Conclusion

By using this `DDD Solution Template`, developers can quickly establish a robust DDD architecture with standardized interfaces and utilities. The design promotes separation of concerns, testability, and scalability, making it an ideal foundation for enterprise-grade .NET applications. 

## Continuous Integration and Deployment

This template includes a GitHub Actions workflow for automated building, testing, and publishing of the NuGet package when changes are pushed to the main branch.

### Semantic Versioning

The package uses semantic versioning (SemVer) based on conventional commits. The version is automatically determined using GitVersion based on commit messages:

- **Major Version Bump**: Commits starting with `breaking:` or `major:` (e.g., `breaking: remove legacy API`)
- **Minor Version Bump**: Commits starting with `feature:` or `minor:` (e.g., `feature: add new repository interface`)
- **Patch Version Bump**: Commits starting with `fix:` or `patch:` (e.g., `fix: correct typo in domain event handler`)
- **No Version Bump**: Commits starting with `none:` or `skip:` (e.g., `none: update documentation`)

### GitHub Actions Workflow

The workflow (`publish-package.yml`) performs the following steps:

1. **Build**: Compiles the solution to ensure code integrity
2. **Test**: Runs all unit and integration tests
3. **Pack**: Creates a NuGet package with the automatically determined version
4. **Test Installation**: Verifies the package can be installed and used correctly
5. **Publish**: Pushes the package to NuGet.org and creates a GitHub release

### Setting Up Secrets

To enable the publishing workflow, you need to add the following secret to your GitHub repository:

- **NUGET_API_KEY**: Your NuGet API key for publishing packages

Add this secret in your GitHub repository under Settings > Secrets and variables > Actions > New repository secret.

### Manual Publishing

If you need to publish a package manually, you can use the following commands:

```bash
# Pack the template
dotnet pack ./packer/PahEmprender.DDDTemplate.CSharp/PahEmprender.DDDTemplate.CSharp.csproj -o ./packer/nupkg -p:PackageVersion=X.Y.Z

# Test the template installation
dotnet new --install ./packer/nupkg/PahEmprender.DDDTemplate.CSharp.X.Y.Z.nupkg
dotnet new pe-ddd -n Test.Project -o TestDir

# Publish to NuGet
dotnet nuget push ./packer/nupkg/PahEmprender.DDDTemplate.CSharp.X.Y.Z.nupkg --api-key YOUR_API_KEY --source https://api.nuget.org/v3/index.json
```

Replace `X.Y.Z` with your desired version number and `YOUR_API_KEY` with your NuGet API key. 