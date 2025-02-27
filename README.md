# DDD Solution Template

[![Build Status](https://github.com/PahEmprender/dotent-ddd-template/workflows/Publish%20NuGet%20Package/badge.svg)](https://github.com/PahEmprender/dotent-ddd-template/actions)
[![NuGet Version](https://img.shields.io/nuget/v/PahEmprender.DDDTemplate.CSharp.svg)](https://www.nuget.org/packages/PahEmprender.DDDTemplate.CSharp)
[![License](https://img.shields.io/github/license/PahEmprender/pe-ddd-template)](https://github.com/PahEmprender/pe-ddd-template/blob/main/LICENSE)
[![.NET](https://img.shields.io/badge/.NET-9.0-blue.svg)](https://dotnet.microsoft.com/download)

This template provides a foundational structure for building .NET applications following Domain-Driven Design (DDD) principles. It is designed to drive consistent and high-quality DDD implementations across multiple projects. The template includes predefined layers for Domain, Application, Infrastructure, and API, along with essential interfaces and utility classes to ensure robust design aligned with DDD best practices.

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

The following sections detail the interfaces and utilities provided by this template, their purposes, and justifications for inclusion. These components are designed to be generic and reusable while enforcing DDD principles.

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

The application layer orchestrates use cases and coordinates interactions between the domain and infrastructure layers. It leverages MediatR for command and query handling. Key practices include:

- **MediatR Integration**: Uses `IRequest` and `IRequestHandler` interfaces provided by MediatR for commands (state-changing operations) and queries (read operations).
- **Validation**: Employs FluentValidation for validating commands and queries, configurable via MediatR pipeline behaviors.
- **No Additional Interfaces**: Since MediatR provides sufficient abstractions, no custom interfaces are defined here, keeping the template lightweight and focused.

### Utilities

Beyond interfaces, the template provides utilities to streamline development:

- **Base Classes**: `Entity`, `AggregateRoot`, and `ValueObject` offer foundational implementations for domain modeling, reducing boilerplate code.
- **Domain Event Handling**: `DomainEvents` simplifies event dispatching, ensuring consistency in event-driven designs.
- **Specification Pattern**: `ISpecification<T>` supports advanced querying in a decoupled manner.

## Recommendations

To maximize the benefits of this template, consider the following recommendations:

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
  - Use the included `DDDTemplate.UnitTests` and `DDDTemplate.IntegrationTests` projects as starting points for comprehensive test suites.

## Getting Started

1. **Create a New Solution**: Generate a new solution using the template:
   ```bash
   dotnet new pe-ddd -n YourProjectName
   ```
2. **Customize**: Replace placeholder classes with your domain entities, application handlers, and infrastructure implementations.
3. **Run**: Build and run the API project (`DDDTemplate.API`) to verify the setup.

This template leverages .NET 9.0, ensuring modern features like nullable reference types and implicit usings are enabled for cleaner code. 
