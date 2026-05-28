
<h1 align="center">⚽ Sportify</h1>

<p align="center">
  <b>Your all-in-one iOS companion to discover sports, explore leagues, and never miss a match.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS-blue?style=flat-square&logo=apple" alt="Platform"/>
  <img src="https://img.shields.io/badge/Swift-5.0-orange?style=flat-square&logo=swift" alt="Swift"/>
  <img src="https://img.shields.io/badge/Architecture-VIPER-purple?style=flat-square" alt="Architecture"/>
  <img src="https://img.shields.io/badge/UIKit-Programmatic%20%2B%20XIB-green?style=flat-square" alt="UIKit"/>
  <img src="https://img.shields.io/badge/iOS-14.5%2B-lightgrey?style=flat-square" alt="Min iOS"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="License"/>
</p>

---

## 📖 Overview

**Sportify** is a native iOS application that delivers a rich sports browsing experience powered by the [AllSportsAPI](https://allsportsapi.com). Users can explore multiple sports categories, browse leagues, view upcoming and recent match fixtures, dive into team rosters, and save their favorite leagues for offline access.

### The Problem It Solves

Sports enthusiasts often juggle multiple apps to keep up with different sports. Sportify consolidates football, basketball, tennis, and cricket into a single, beautifully designed interface — complete with real-time fixtures, team details, and a personal favorites list backed by Core Data.

### Target Users

- Sports fans who follow multiple sports and leagues
- Casual users wanting quick access to upcoming matches and recent results
- Anyone looking for a well-structured, open-source iOS project demonstrating VIPER architecture

---

## ✨ Features

### 🏠 Core Experience
| Feature | Description |
|---|---|
| **Multi-Sport Support** | Browse Football, Basketball, Tennis, and Cricket from a unified home screen |
| **League Explorer** | View all available leagues per sport with country info and logos |
| **Live Search** | Real-time search filtering across league names and countries |
| **League Details** | Compositional layout showing upcoming matches, recent results, and teams in a single scrollable view |
| **Team Details** | View full team roster with player positions, ages, jersey numbers, and photos |

### ❤️ Favorites & Persistence
| Feature | Description |
|---|---|
| **Add/Remove Favorites** | Toggle favorite status on any league via the navigation bar heart icon |
| **Favorites Tab** | Dedicated tab listing all saved favorite leagues |
| **Offline Favorites** | Favorites are persisted locally via Core Data — accessible even without internet |
| **Swipe to Delete** | Remove favorites with a native swipe gesture |

### 🎨 User Experience
| Feature | Description |
|---|---|
| **Animated Splash Screen** | Physics-based ball bounce animation using `UIDynamicAnimator` with gravity, collision, and elasticity |
| **Onboarding Flow** | 3-page interactive onboarding with page view controller, custom dot indicators, and smooth transitions |
| **Cell Animations** | Spring-damped entrance animations on league lists and collection view items |
| **Tab Bar Navigation** | Clean Sports and Favorites tabs with SF Symbols |
| **Network Reachability** | Graceful handling of offline scenarios with retry dialogs |
| **Loading States** | Activity indicators during network requests with content hiding |
| **Error Handling** | Alert-based error presentation with retry callback support |

---

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| **Language** | Swift 5.0 |
| **Platform** | iOS 14.5+ (iPhone & iPad) |
| **UI Framework** | UIKit (XIBs + Programmatic UI) |
| **Architecture** | VIPER (View – Interactor/Presenter – Presenter – Entity – Router) |
| **Networking** | [Alamofire](https://github.com/Alamofire/Alamofire) via Swift Package Manager |
| **Image Loading** | [SDWebImage](https://github.com/SDWebImage/SDWebImage) via Swift Package Manager |
| **Local Storage** | Core Data (`NSPersistentContainer`) |
| **Serialization** | `Codable` / `Decodable` with `CodingKeys` |
| **State Persistence** | `UserDefaults` (onboarding completion flag) |
| **Layout** | `UICollectionViewCompositionalLayout`, `UICollectionViewFlowLayout`, Auto Layout |
| **Animations** | `UIDynamicAnimator`, `UIView.animate`, `CABasicAnimation` |
| **Dependency Management** | Swift Package Manager (SPM) |
| **Build System** | Xcode / xcodebuild |

---

## 🏗 Architecture

Sportify follows the **VIPER** architectural pattern, ensuring a clean separation of concerns, high testability, and modular scalability.

```
┌─────────────────────────────────────────────────────────┐
│                        MODULE                           │
│                                                         │
│  ┌─────────┐    ┌───────────┐    ┌──────────┐           │
│  │  View   │◄──►│ Presenter │◄──►│  Router  │           │
│  │(VC/XIB) │    │           │    │          │           │
│  └─────────┘    └─────┬─────┘    └──────────┘           │
│                       │                                 │
│                       ▼                                 │
│                ┌─────────────┐                          │
│                │   Service   │  (Interactor equivalent) │
│                │   Layer     │                          │
│                └──────┬──────┘                          │
│                       │                                 │
│                       ▼                                 │
│                ┌─────────────┐                          │
│                │   Entity    │  (Models / Core Data)    │
│                └─────────────┘                          │
│                                                         │
│  ┌─────────┐                                            │
│  │ Builder │  ← Assembles & injects dependencies        │
│  └─────────┘                                            │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility |
|---|---|
| **View** | Renders UI, forwards user interactions to Presenter. Conforms to `*ViewProtocol`. |
| **Presenter** | Contains presentation logic, transforms data for the View, delegates navigation to Router. |
| **Router** | Handles all navigation and screen transitions. Builds destination modules via Builders. |
| **Builder** | Factory that assembles the VIPER module — creates View, Presenter, Router, wires dependencies. |
| **Service** | Encapsulates business logic and API calls (acts as the Interactor). Each service has a protocol for testability. |
| **Entity / Model** | Plain `Codable`/`Decodable` structs representing API responses and domain objects. |
| **Contract** | Protocol definitions grouping View, Presenter, and Router protocols for a module. |

### Module Separation

Each feature module is self-contained with its own `Builder/`, `Presenter/`, `Router/`, `View/`, and optionally `Contract/` and `Model/` directories. Modules communicate exclusively through protocols and Builder-injected dependencies.

---

## 📂 Project Structure

```
Sportify/
├── AppDelegate.swift                  # App lifecycle + Core Data stack
├── SceneDelegate.swift                # Window setup + initial navigation
├── Info.plist                         # App configuration
├── Sportify.xcdatamodeld/             # Core Data model (FavoriteLeague entity)
├── Assets.xcassets/                   # Colors, app icons, sport images
├── Base.lproj/                        # Main.storyboard, LaunchScreen.storyboard
│
├── Core/
│   ├── Extensions/
│   │   ├── DateExtension.swift        # Date → API format string
│   │   └── ImageExtension.swift       # UIImageView + SDWebImage with sport placeholders
│   ├── Models/
│   │   ├── BaseResponse.swift         # Generic API response wrapper
│   │   ├── Event.swift                # Match/fixture model
│   │   ├── League.swift               # League model
│   │   ├── Player.swift               # Player model
│   │   └── Team.swift                 # Team model
│   ├── Network/
│   │   ├── APIClient.swift            # Alamofire-based generic network client
│   │   ├── APIConstants.swift         # Base URL + API key
│   │   ├── APISport.swift             # Sport type enum
│   │   ├── EndPoint.swift             # Type-safe endpoint definitions
│   │   ├── NetworkError.swift         # Custom error types
│   │   └── ReachabilityManager.swift  # Network connectivity checker
│   └── Services/
│       ├── Favorite/                  # Core Data CRUD for favorite leagues
│       ├── Fixtures/                  # Fetch match fixtures
│       ├── Leagues/                   # Fetch leagues by sport
│       ├── Players/                   # Fetch players by team
│       └── Teams/                     # Fetch teams by league
│
└── Module/
    ├── AppTabBarController.swift       # Main tab bar (Sports + Favorites)
    ├── Splash/                         # Animated splash screen
    │   ├── Builder/
    │   ├── Presenter/
    │   ├── Router/
    │   └── View/
    ├── Onboarding/                     # 3-page onboarding flow
    │   ├── Builder/
    │   ├── Presenter/
    │   ├── Router/
    │   └── View/
    ├── Sports/                         # Sport category grid
    │   ├── Builder/
    │   ├── Presenter/
    │   ├── Router/
    │   └── View/
    ├── Leagues/                        # League listing with search
    │   ├── Builder/
    │   ├── Contract/
    │   ├── Presenter/
    │   ├── Router/
    │   └── View/
    ├── LeagueDetails/                  # Upcoming, recent, teams sections
    │   ├── Builder/
    │   ├── Contract/
    │   ├── Model/
    │   ├── Presenter/
    │   ├── Router/
    │   └── View/
    ├── TeamDetails/                    # Team roster with player cards
    │   ├── Builder/
    │   ├── Contract/
    │   ├── Presenter/
    │   ├── Router/
    │   └── View/
    └── Favorite/                       # Saved favorite leagues
        ├── Builder/
        ├── Presenter/
        ├── Router/
        ├── View/
        └── View Model/
```

---

## 📱 Screens / Modules

| # | Module | Description |
|---|---|---|
| 1 | **Splash** | Physics-based ball drop animation → app name reveal → zoom transition to home or onboarding |
| 2 | **Onboarding** | 3-page swipeable introduction with custom page control and "Get Started" CTA |
| 3 | **Sports** | 2×2 grid of sport cards (Football, Basketball, Tennis, Cricket) |
| 4 | **Leagues** | Searchable list of leagues per sport with country flags and logos |
| 5 | **League Details** | Compositional layout with 3 sections: Upcoming Matches (horizontal paging), Recent Results (vertical list), Teams (horizontal scroll) |
| 6 | **Team Details** | Team logo header + scrollable player roster sorted by position |
| 7 | **Favorites** | Persisted favorite leagues with swipe-to-delete and navigation to league details |

### Navigation Flow

```
Splash → Onboarding (first launch) → TabBar
         ↓ (subsequent launches)
         TabBar
           ├── Sports → Leagues → League Details → Team Details
           └── Favorites → League Details → Team Details
```

---

## 🚀 Setup & Installation

### Prerequisites

- **macOS** 13.0 or later
- **Xcode** 15.0 or later
- **iOS** 14.5+ deployment target
- Active internet connection (for API data)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/Sportify-io/Sportify.git

# 2. Navigate to the project directory
cd Sportify

# 3. Open in Xcode
open Sportify.xcodeproj

# 4. Xcode will automatically resolve Swift Package Manager dependencies
#    (Alamofire + SDWebImage)

# 5. Select a simulator or connected device

# 6. Build & Run (⌘ + R)
```

> **Note:** No CocoaPods or Carthage setup is required. All dependencies are managed via Swift Package Manager and resolved automatically by Xcode.

### API Configuration

The app uses the [AllSportsAPI](https://allsportsapi.com). The API key is configured in:

```
Sportify/Core/Network/APIConstants.swift
```

Replace the API key if needed:

```swift
enum APIConstants {
    static let baseURL = "https://apiv2.allsportsapi.com/"
    static let apiKey  = "YOUR_API_KEY_HERE"
}
```

---

## 📦 Dependencies

| Dependency | Purpose | Manager |
|---|---|---|
| [**Alamofire**](https://github.com/Alamofire/Alamofire) | Elegant HTTP networking — handles API requests, response validation, and parameter encoding | SPM |
| [**SDWebImage**](https://github.com/SDWebImage/SDWebImage) | Asynchronous image loading with caching, placeholder support, and memory management | SPM |

### Built-in Frameworks Used

| Framework | Usage |
|---|---|
| **UIKit** | Entire UI layer — view controllers, collection views, table views, animations |
| **Core Data** | Local persistence for favorite leagues (`FavoriteLeague` entity) |
| **Foundation** | Data models, date formatting, JSON decoding |

---

## ✅ Best Practices Used

### Architecture & Design Patterns
- **VIPER Architecture** — Strict separation of View, Presenter, Router, and Service layers
- **Protocol-Oriented Design** — Every layer communicates through protocols (`*ViewProtocol`, `*PresenterProtocol`, `*RouterProtocol`, `*ServiceProtocol`)
- **Builder Pattern** — Each module has a dedicated Builder that assembles and injects dependencies
- **Singleton Pattern** — Used judiciously for shared services (`APIClient.shared`, `FavoritesService.shared`, `ReachabilityManager.shared`)

### Code Quality
- **Separation of Concerns** — Core infrastructure (network, models, services) is fully decoupled from feature modules
- **Protocol Abstraction for Services** — Every service conforms to a protocol, enabling easy mocking and unit testing
- **Generic Networking** — `APIClient` uses Swift generics (`T: Decodable`) for type-safe API responses
- **Type-Safe Endpoints** — `EndPoint` enum with associated values ensures compile-time safety for all API calls
- **Weak References** — Proper use of `weak` delegates and `[weak self]` in closures to prevent retain cycles

### UI/UX
- **Compositional Layout** — Modern `UICollectionViewCompositionalLayout` for the league details screen with mixed section types
- **Spring Animations** — Cell entrance animations with spring damping for a polished feel
- **Physics Animations** — `UIDynamicAnimator` with gravity, collision, and elasticity for the splash screen
- **Reusable Cells** — `LeagueCell` XIB shared across Leagues and Favorites modules
- **Sport-Specific Placeholders** — Custom placeholder images per sport type when network images fail

### Data & Networking
- **Network Reachability** — Pre-flight connectivity check before every API request
- **Error Recovery** — Retry callbacks on network failures for seamless recovery
- **CodingKeys Mapping** — Clean snake_case → camelCase mapping in all models
- **Core Data Context Management** — Background-safe save on app transition to background

### Scalability
- **Modular Feature Architecture** — Adding a new sport or screen requires only a new Module directory with Builder/Presenter/Router/View
- **Centralized Service Layer** — All API interactions go through protocol-defined services, making it trivial to swap implementations
- **Extensible Endpoint Enum** — New API endpoints can be added as new `EndPoint` enum cases

---

## 🔮 Future Improvements

| Improvement | Description |
|---|---|
| **Unit & UI Tests** | Add comprehensive tests for Presenters, Services, and navigation flows |
| **Dark Mode Support** | Extend the color assets to fully support `UIUserInterfaceStyle.dark` |
| **Localization** | Add multi-language support using `Localizable.strings` |
| **Player Detail Screen** | Dedicated screen with full player statistics and career info |
| **Push Notifications** | Match reminders for upcoming events in favorite leagues |
| **Pagination** | Lazy loading for large league and fixture lists |
| **Caching Layer** | Cache API responses locally for faster loading and reduced API calls |
| **Dependency Injection Container** | Replace singletons with a proper DI container (e.g., Swinject) |
| **Combine/Async-Await** | Migrate from completion handlers to modern Swift concurrency |
| **Widget Extension** | Home screen widget showing next match for favorite leagues |
| **Watch App** | Companion watchOS app for quick score checks |

---

## 👥 Contributors

| Contributor | Role |
|---|---|
| **Tasneem Hakeem** | iOS Developer — Onboarding, Sports, Favorites, Team Details, Core Data |
| **Elsobky** | iOS Developer — Splash, Leagues, League Details, Networking, API Integration |

> Want to contribute? Fork the repo, create a feature branch, and submit a pull request!

---

## 📄 License

```
MIT License

Copyright (c) 2026 Sportify

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<p align="center">
  Made with ❤️ in Swift
</p>
