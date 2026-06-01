# App Architecture Specification

## Overview

This document defines the architecture of the application using **The Composable Architecture (TCA)** combined with **Clean Architecture** principles. The architecture is divided into three distinct layers with clear separation of concerns and dependency injection managed through TCA's Dependencies system.

---

## Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Responsibility**: Define business logic, use cases, and abstraction protocols
- **Dependencies**: None (Pure Swift, no external dependencies)
- **Components**:
  - `UseCases/`: Business logic operations that orchestrate data and domain models
  - `Repositories/Protocols/`: Protocol definitions for data access abstraction
  - `Models/`: Domain-specific entities and value types

### 2. **Data Layer** (Data Access)
- **Responsibility**: Implement data access logic and manage local database operations
- **Dependencies**: Domain Layer (implements protocols)
- **Components**:
  - `Repositories/Implementations/`: Concrete repository implementations
  - `LocalDB/`: Local database models and CRUD operations
  - `Mappers/`: Convert between API/DB models and domain models

### 3. **Presentation Layer** (UI & State Management)
- **Responsibility**: Manage UI, user interactions, and app state
- **Dependencies**: Domain Layer (uses UseCases and Repositories via TCA)
- **Components**:
  - `Features/[FeatureName]/`: Feature-specific modules
    - `View/`: SwiftUI views
    - `Reducer/`: TCA reducers for state management
    - `Models/`: Feature-specific state and action types
  - `Common/`: Shared UI components and utilities
  - `Navigation/`: App-wide navigation logic

### 4. **App Layer** (Dependency Injection & Assembly)
- **Responsibility**: Assemble all dependencies and provide DI configuration
- **Components**:
  - `AppDelegate.swift` / `App.swift`: Entry point with DI setup
  - `DIContainer.swift`: Centralized dependency injection configuration
  - TCA `Dependencies` live values registration

---

## Folder Structure

```
YourApp/
├── Domain/
│   ├── UseCases/
│   │   ├── [FeatureName]UseCase.swift
│   │   └── ...
│   ├── Repositories/
│   │   ├── Protocols/
│   │   │   ├── [FeatureName]RepositoryProtocol.swift
│   │   │   └── ...
│   │   └── Models/
│   │       └── [FeatureName]Model.swift
│   └── Models/
│       ├── EntityA.swift
│       └── ...
│
├── Data/
│   ├── Repositories/
│   │   ├── [FeatureName]Repository.swift
│   │   └── ...
│   ├── LocalDB/
│   │   ├── DBManager.swift
│   │   ├── [FeatureName]DAO.swift
│   │   └── ...
│   └── Mappers/
│       ├── [FeatureName]Mapper.swift
│       └── ...
│
├── Presentation/
│   ├── Features/
│   │   ├── [FeatureName]/
│   │   │   ├── View/
│   │   │   │   ├── [FeatureName]View.swift
│   │   │   │   └── ...
│   │   │   ├── Reducer/
│   │   │   │   └── [FeatureName]Reducer.swift
│   │   │   └── Models/
│   │   │       ├── [FeatureName]State.swift
│   │   │       ├── [FeatureName]Action.swift
│   │   │       └── ...
│   │   └── ...
│   ├── Common/
│   │   ├── Components/
│   │   │   └── ...
│   │   └── Utilities/
│   │       └── ...
│   └── Navigation/
│       ├── AppRouter.swift
│       └── ...
│
└── App/
    ├── App.swift
    ├── DIContainer.swift
    └── ...
```

---

## Dependency Injection Pattern

### TCA Dependencies Registration

All dependencies are registered in the `App` layer using TCA's `DependencyValues` system.

#### Example: DIContainer.swift

```swift
import ComposableArchitecture

extension DependencyValues {
    // MARK: - Repositories
    var featureRepository: FeatureRepositoryProtocol {
        get { self[FeatureRepositoryKey.self] }
        set { self[FeatureRepositoryKey.self] = newValue }
    }
    
    // MARK: - UseCases
    var featureUseCase: FeatureUseCase {
        get { self[FeatureUseCaseKey.self] }
        set { self[FeatureUseCaseKey.self] = newValue }
    }
}

// MARK: - Dependency Keys

private enum FeatureRepositoryKey: DependencyKey {
    static let liveValue: FeatureRepositoryProtocol = FeatureRepository(
        dbManager: DBManager.shared
    )
    
    static let testValue: FeatureRepositoryProtocol = unimplemented(#function)
}

private enum FeatureUseCaseKey: DependencyKey {
    static let liveValue: FeatureUseCase = FeatureUseCase(
        repository: FeatureRepository(dbManager: DBManager.shared)
    )
    
    static let testValue: FeatureUseCase = unimplemented(#function)
}
```

---

## Layer Details

### Domain Layer

#### 1. Repository Protocols
Abstracts data access logic from business logic.

```swift
// Domain/Repositories/Protocols/FeatureRepositoryProtocol.swift
import Foundation

protocol FeatureRepositoryProtocol {
    func fetchItems() async -> [DomainModel]
    func saveItem(_ item: DomainModel) async throws
    func deleteItem(id: String) async throws
}
```

#### 2. UseCases
Implements business logic by orchestrating repository operations.

```swift
// Domain/UseCases/FeatureUseCase.swift
import Foundation

class FeatureUseCase {
    private let repository: FeatureRepositoryProtocol
    
    init(repository: FeatureRepositoryProtocol) {
        self.repository = repository
    }
    
    func getItems() async -> [DomainModel] {
        await repository.fetchItems()
    }
    
    func addItem(_ item: DomainModel) async throws {
        try await repository.saveItem(item)
    }
}
```

#### 3. Domain Models
Pure data structures representing business entities.

```swift
// Domain/Models/DomainModel.swift
struct DomainModel: Identifiable, Equatable {
    let id: String
    let name: String
    let createdAt: Date
}
```

---

### Data Layer

#### 1. Repository Implementation
Concrete implementation of repository protocols using local database.

```swift
// Data/Repositories/FeatureRepository.swift
import Foundation

class FeatureRepository: FeatureRepositoryProtocol {
    private let dbManager: DBManager
    
    init(dbManager: DBManager) {
        self.dbManager = dbManager
    }
    
    func fetchItems() async -> [DomainModel] {
        let dbModels = dbManager.fetchAll(FeatureEntity.self)
        return dbModels.map { FeatureMapper.toDomain($0) }
    }
    
    func saveItem(_ item: DomainModel) async throws {
        let dbModel = FeatureMapper.toDatabase(item)
        try dbManager.save(dbModel)
    }
    
    func deleteItem(id: String) async throws {
        try dbManager.delete(FeatureEntity.self, withId: id)
    }
}
```

#### 2. Local Database Manager
Manages CRUD operations for the local database.

```swift
// Data/LocalDB/DBManager.swift
import Foundation

class DBManager {
    static let shared = DBManager()
    
    private init() {}
    
    func fetchAll<T>(_ type: T.Type) -> [T] {
        // Implementation for fetching all records
        []
    }
    
    func save<T>(_ entity: T) throws {
        // Implementation for saving records
    }
    
    func delete<T>(_ type: T.Type, withId id: String) throws {
        // Implementation for deleting records
    }
}
```

#### 3. Mappers
Convert between database models and domain models.

```swift
// Data/Mappers/FeatureMapper.swift
import Foundation

struct FeatureMapper {
    static func toDomain(_ dbModel: FeatureEntity) -> DomainModel {
        DomainModel(
            id: dbModel.id,
            name: dbModel.name,
            createdAt: dbModel.createdAt
        )
    }
    
    static func toDatabase(_ domainModel: DomainModel) -> FeatureEntity {
        FeatureEntity(
            id: domainModel.id,
            name: domainModel.name,
            createdAt: domainModel.createdAt
        )
    }
}
```

---

### Presentation Layer

#### 1. Feature Reducer
Manages state and side effects using TCA.

```swift
// Presentation/Features/Feature/Reducer/FeatureReducer.swift
import ComposableArchitecture

@Reducer
struct FeatureReducer {
    @ObservableState
    struct State: Equatable {
        var items: [DomainModel] = []
        var isLoading = false
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case itemsResponse([DomainModel])
        case addItem(DomainModel)
        case deleteItem(String)
        case errorOccurred(String)
    }
    
    @Dependency(\.featureUseCase) var featureUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let items = await featureUseCase.getItems()
                    await send(.itemsResponse(items))
                }
            
            case let .itemsResponse(items):
                state.isLoading = false
                state.items = items
                return .none
            
            case let .addItem(item):
                return .run { send in
                    do {
                        try await featureUseCase.addItem(item)
                        let items = await featureUseCase.getItems()
                        await send(.itemsResponse(items))
                    } catch {
                        await send(.errorOccurred(error.localizedDescription))
                    }
                }
            
            case let .deleteItem(id):
                return .run { send in
                    do {
                        try await featureUseCase.deleteItem(id: id)
                        let items = await featureUseCase.getItems()
                        await send(.itemsResponse(items))
                    } catch {
                        await send(.errorOccurred(error.localizedDescription))
                    }
                }
            
            case let .errorOccurred(message):
                state.errorMessage = message
                return .none
            }
        }
    }
}
```

#### 2. Feature View
SwiftUI view that displays UI and handles user interactions.

```swift
// Presentation/Features/Feature/View/FeatureView.swift
import SwiftUI
import ComposableArchitecture

struct FeatureView: View {
    @Perception.Bindable var store: StoreOf<FeatureReducer>
    
    var body: some View {
        NavigationStack {
            ZStack {
                if store.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(store.items) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Button(action: {
                                    store.send(.deleteItem(item.id))
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Feature")
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}
```

---

### App Layer (Dependency Injection)

#### App Entry Point

```swift
// App/App.swift
import SwiftUI
import ComposableArchitecture

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store(
                initialState: FeatureReducer.State(),
                reducer: {
                    FeatureReducer()
                }
            )
            
            FeatureView(store: store)
        }
    }
}
```

---

## Data Flow

```
User Interaction (Presentation Layer)
        ↓
    TCA Action
        ↓
    TCA Reducer
        ↓
UseCase (Domain Layer)
        ↓
Repository Protocol (Domain Layer)
        ↓
Repository Implementation (Data Layer)
        ↓
Local Database / DBManager (Data Layer)
        ↓
       [Response back through layers]
        ↓
    State Update
        ↓
    View Rerender
```

---

## Key Principles

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Inversion**: Presentation depends on Domain, Data implements Domain protocols
3. **Testability**: Mock implementations can be injected via TCA Dependencies for testing
4. **Modularity**: Features are organized by functionality for future modularization
5. **No API Layer**: Currently using mock data with local DB; API can be added to Data layer later without changing Domain/Presentation
6. **Centralized DI**: All dependency assembly happens in the App layer

---

## Migration Path to Real API

When ready to integrate a real API:

1. Create a new `APIService` class in the Data layer
2. Modify repository implementations to fetch from API instead of local DB
3. Update mappers to handle API response models
4. No changes needed in Domain or Presentation layers

Example:
```swift
// Data/Services/FeatureAPIService.swift
class FeatureAPIService {
    func fetchItems() async throws -> [APIFeatureModel] {
        // API call implementation
    }
}

// Then update FeatureRepository to use it:
class FeatureRepository: FeatureRepositoryProtocol {
    private let apiService: FeatureAPIService
    
    func fetchItems() async -> [DomainModel] {
        let apiModels = try await apiService.fetchItems()
        return apiModels.map { FeatureMapper.toDomain($0) }
    }
}
```

---

## Testing Strategy

- **Domain Layer**: Unit tests for UseCases
- **Data Layer**: Unit tests for Repository implementations with mock database
- **Presentation Layer**: Integration tests for Reducers with mock UseCases/Repositories via TCA Dependencies
- **End-to-End**: Full app flow with mock data

---

## Dependencies

- **The Composable Architecture (TCA)**: `1.25.0+` (latest) - For state management and dependency injection
- **SwiftUI**: For UI (comes with iOS)
- **Core Data / SQLite / Realm** (optional): For local database (not yet specified)

### Installation via Swift Package Manager

Add to your `Package.swift`:

```swift
let package = Package(
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: "1.25.0"
    ),
  ],
  targets: [
    .target(
      name: "YourApp",
      dependencies: [
        .product(name: "ComposableArchitecture",
                 package: "swift-composable-architecture")
      ]
    )
  ]
)
```

Or in Xcode: **File > Add Packages** → Enter repository URL → Select version `1.25.0` or later

---

## Future Considerations

1. Modularization: Split features into separate frameworks
2. Plugin Architecture: Make features pluggable
3. Analytics/Logging: Add middleware to TCA for cross-cutting concerns
4. Real API Integration: Add APIService layer to Data
5. Authentication: Implement auth UseCase and middleware
