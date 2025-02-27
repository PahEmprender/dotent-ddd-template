# DDD Solution Template

<div align="center">

[![Build Status](https://github.com/PahEmprender/dotent-ddd-template/workflows/Publish%20NuGet%20Package/badge.svg)](https://github.com/PahEmprender/dotent-ddd-template/actions)
[![GitHub Package Version](https://img.shields.io/github/v/release/PahEmprender/dotent-ddd-template?label=GitHub%20Package)](https://github.com/PahEmprender/dotent-ddd-template/packages)
[![NuGet Version](https://img.shields.io/nuget/v/PahEmprender.DDDTemplate.CSharp.svg)](https://www.nuget.org/packages/PahEmprender.DDDTemplate.CSharp)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![.NET](https://img.shields.io/badge/.NET-9.0-blue.svg)](https://dotnet.microsoft.com/download)

</div>

## 📋 Overview

This template provides a foundational structure for building .NET applications following Domain-Driven Design (DDD) principles. It is designed to drive consistent and high-quality DDD implementations across multiple projects. The template includes predefined layers for Domain, Application, Infrastructure, and API, along with essential interfaces and utility classes to ensure robust design aligned with DDD best practices.

## 🚀 Quick Start

### Installation

Install the template from NuGet:

```bash
dotnet new install PahEmprender.DDDTemplate.CSharp
```

### Create a New Project

```bash
dotnet new pe-ddd -n YourProjectName
```

### Build and Run

```bash
cd YourProjectName
dotnet build
dotnet run --project src/YourProjectName.API
```

## 🏗️ Project Structure

The solution (`DDDTemplate.sln`) is organized into the following projects:

```
DDDTemplate/
├── src/
│   ├── DDDTemplate.Domain/              # Core domain model and business logic
│   ├── DDDTemplate.Application/         # Application services and use cases
│   ├── DDDTemplate.Infrastructure/      # External concerns implementation
│   │   └── Persistence/                 # Data access and repositories
│   └── DDDTemplate.API/                 # API endpoints and controllers
└── tests/
    ├── DDDTemplate.UnitTests/           # Unit tests for domain and application
    └── DDDTemplate.IntegrationTests/    # Integration tests for infrastructure and API
```

### Layer Descriptions

- **`DDDTemplate.Domain`**: Contains domain entities, value objects, aggregates, domain services, and repository interfaces. This layer encapsulates the core business logic.
- **`DDDTemplate.Application`**: Implements application services, commands, queries, and handlers using MediatR to orchestrate use cases.
- **`DDDTemplate.Infrastructure.Persistence`**: Provides implementations for repository interfaces and database context (e.g., using Entity Framework Core).
- **`DDDTemplate.API`**: Hosts API endpoints to handle HTTP requests and integrate with the application layer.
- **`DDDTemplate.UnitTests`**: Contains unit tests for domain and application logic.
- **`DDDTemplate.IntegrationTests`**: Includes integration tests for infrastructure and API functionality.

This structure adheres to DDD's layered architecture, separating concerns to promote maintainability and scalability.

## 🧩 Key Interfaces and Utilities

The following sections detail the interfaces and utilities provided by this template, their purposes, and justifications for inclusion. These components are designed to be generic and reusable while enforcing DDD principles.

### Domain Layer

<details>
<summary><b>Core Domain Components</b></summary>

#### `IRepository<T>`

```csharp
public interface IRepository<T> where T : AggregateRoot
{
    Task<T> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<T>> ListAllAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<T>> ListAsync(ISpecification<T> spec, CancellationToken cancellationToken = default);
    Task<T> AddAsync(T entity, CancellationToken cancellationToken = default);
    Task UpdateAsync(T entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(T entity, CancellationToken cancellationToken = default);
    Task<int> CountAsync(ISpecification<T> spec, CancellationToken cancellationToken = default);
    Task<T> FirstOrDefaultAsync(ISpecification<T> spec, CancellationToken cancellationToken = default);
}
```

- **Definition**: A generic interface for repositories, defining standard CRUD operations for aggregate roots.
- **Justification**: Decouples the domain layer from persistence concerns, enabling flexibility in data access implementations and facilitating unit testing through mocking.
- **Usage**: Define specific repository interfaces in the domain layer (e.g., `IOrderRepository : IRepository<Order>`) with domain-specific methods as needed, and implement them in the infrastructure layer.

#### `Entity`

```csharp
public abstract class Entity
{
    public Guid Id { get; protected set; }
    
    protected Entity(Guid id)
    {
        Id = id;
    }
    
    // Equality members and other base functionality
}
```

- **Definition**: A base class for all entities, providing a unique identifier and equality comparison logic.
- **Justification**: Ensures consistent identity management and equality checks across all domain entities, a fundamental aspect of DDD.
- **Usage**: Inherit from this class for all entity types in your domain model.

#### `AggregateRoot`

```csharp
public abstract class AggregateRoot : Entity
{
    private readonly List<IDomainEvent> _domainEvents = new();
    
    public IReadOnlyCollection<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();
    
    protected AggregateRoot(Guid id) : base(id) { }
    
    public void AddDomainEvent(IDomainEvent domainEvent)
    {
        _domainEvents.Add(domainEvent);
    }
    
    public void ClearDomainEvents()
    {
        _domainEvents.Clear();
    }
}
```

- **Definition**: A base class for aggregate roots, inheriting from `Entity`, with support for managing domain events.
- **Justification**: Enforces the aggregate pattern by providing a mechanism to handle domain events, ensuring consistency within aggregates and enabling event-driven communication.
- **Usage**: Inherit from this class for aggregate roots and use it to raise events reflecting significant state changes.

#### `ValueObject`

```csharp
public abstract class ValueObject
{
    protected abstract IEnumerable<object> GetEqualityComponents();
    
    // Equality implementation based on all properties
}
```

- **Definition**: A base class for value objects, implementing equality based on property values rather than identity.
- **Justification**: Promotes immutability and value-based equality, key characteristics of value objects in DDD, reducing complexity in domain modeling.
- **Usage**: Inherit from this class for value objects like addresses or money amounts.

#### `IDomainEvent`

```csharp
public interface IDomainEvent
{
    Guid Id { get; }
    DateTime OccurredOn { get; }
}
```

- **Definition**: A marker interface for domain events.
- **Justification**: Allows for polymorphic handling of events and integrates with event-driven architectures, a common practice in DDD.
- **Usage**: Implement this interface for all domain event classes (e.g., `OrderCreatedEvent`).

#### `DomainEvents`

```csharp
public static class DomainEvents
{
    public static void Raise<T>(T domainEvent) where T : IDomainEvent
    {
        // Implementation for raising events
    }
}
```

- **Definition**: A static utility class for raising and handling domain events.
- **Justification**: Centralizes event dispatching logic, simplifying the integration of domain events with application or infrastructure layers.
- **Usage**: Use `DomainEvents.Raise` within the domain layer to dispatch events to handlers or external systems.

#### `ISpecification<T>`

```csharp
public interface ISpecification<T>
{
    Expression<Func<T, bool>> Criteria { get; }
    List<Expression<Func<T, object>>> Includes { get; }
    List<string> IncludeStrings { get; }
    Expression<Func<T, object>> OrderBy { get; }
    Expression<Func<T, object>> OrderByDescending { get; }
    int Take { get; }
    int Skip { get; }
    bool IsPagingEnabled { get; }
}
```

- **Definition**: An interface for the specification pattern, defining query criteria and potentially other query aspects like includes or sorting.
- **Justification**: Enables reusable, composable, and expressive query definitions, preventing repository interfaces from becoming cluttered with numerous query methods.
- **Usage**: Implement this interface to define specifications (e.g., `ActiveOrdersSpecification`), and use them in repository methods like `GetAsync(ISpecification<T>)`.

</details>

### Infrastructure Layer

<details>
<summary><b>Infrastructure Components</b></summary>

#### `IDatabaseContext`

```csharp
public interface IDatabaseContext
{
    DbSet<T> Set<T>() where T : class;
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
```

- **Definition**: An interface for database operations, providing access to entity sets and save functionality.
- **Justification**: Abstracts the persistence layer, allowing for different ORM implementations or mocking in tests, while keeping the domain layer pure.
- **Usage**: Implement this interface in the infrastructure layer, typically wrapping an ORM like Entity Framework Core's `DbContext`.

#### `IUnitOfWork`

```csharp
public interface IUnitOfWork : IDisposable
{
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    Task<bool> SaveEntitiesAsync(CancellationToken cancellationToken = default);
}
```

- **Definition**: An interface for managing transactions, often combined with `IDatabaseContext`.
- **Justification**: Ensures atomic commits across multiple repository operations, a critical aspect of maintaining data consistency in DDD.
- **Usage**: Implement this interface to coordinate database transactions, often fulfilled by the same class implementing `IDatabaseContext`.

</details>

### Application Layer

<details>
<summary><b>Application Components</b></summary>

The application layer orchestrates use cases and coordinates interactions between the domain and infrastructure layers. It leverages MediatR for command and query handling. Key practices include:

#### MediatR Integration

```csharp
// Command example
public class CreateOrderCommand : IRequest<Guid>
{
    public string CustomerName { get; set; }
    public List<OrderItemDto> Items { get; set; }
}

// Command handler example
public class CreateOrderCommandHandler : IRequestHandler<CreateOrderCommand, Guid>
{
    private readonly IOrderRepository _orderRepository;
    private readonly IUnitOfWork _unitOfWork;
    
    public CreateOrderCommandHandler(IOrderRepository orderRepository, IUnitOfWork unitOfWork)
    {
        _orderRepository = orderRepository;
        _unitOfWork = unitOfWork;
    }
    
    public async Task<Guid> Handle(CreateOrderCommand request, CancellationToken cancellationToken)
    {
        // Implementation
    }
}
```

- Uses `IRequest` and `IRequestHandler` interfaces provided by MediatR for commands (state-changing operations) and queries (read operations).
- Employs FluentValidation for validating commands and queries, configurable via MediatR pipeline behaviors.
- Since MediatR provides sufficient abstractions, no custom interfaces are defined here, keeping the template lightweight and focused.

</details>

## 💡 Best Practices and Recommendations

### Extensibility

- Extend repository interfaces with domain-specific methods as needed (e.g., `IOrderRepository.GetOverdueOrdersAsync`).
- Add new domain events or properties to entities and aggregates to adapt to specific business requirements.
- Use the specification pattern to encapsulate complex query logic, making it easy to extend data retrieval capabilities.

### Maintainability

- Keep the domain layer free of infrastructure dependencies by relying solely on interfaces like `IRepository<T>` and dependency injection.
- Centralize cross-cutting concerns (e.g., logging, validation) in MediatR pipeline behaviors to avoid duplicating logic across handlers.
- Use the provided base classes to enforce consistent domain modeling practices across projects.

### Testability

- Write unit tests for domain logic by mocking `IRepository<T>` and other interfaces, ensuring isolation from infrastructure concerns.
- Leverage `IDatabaseContext` and `IUnitOfWork` to create test doubles for persistence testing.
- Use the included `DDDTemplate.UnitTests` and `DDDTemplate.IntegrationTests` projects as starting points for comprehensive test suites.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## ❓ Troubleshooting

### Common Issues

- **Missing Dependencies**: Ensure all NuGet packages are restored before building
- **Database Connection**: Check connection strings in `appsettings.json`
- **Validation Errors**: Ensure all required properties are set in commands/queries

### Getting Help

If you encounter any issues or have questions, please [open an issue](https://github.com/PahEmprender/dotent-ddd-template/issues) on GitHub.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
