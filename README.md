# RecipeList App

![App Screenshot](/main.png)

## Summary

A simple app that demonstrates fetching a list of recipes from an API and implementing a custom image caching mechanism. Features pull-to-refresh mechanism. 
---

## Focus Areas

The primary focus areas of this project were:

1. **Data Handling:**  
   - Ensuring a smooth data flow from the API to parsing, ViewModel, and finally to the view.
   - Using the MVVM architecture for better separation of concerns.

2. **Image Caching:**  
   - Implemented efficient caching to minimize repeated network requests and improve performance.
   - Focused on memory and disk caching to optimize resource usage.

3. **Code Maintainability & Testability:**  
   - Followed clean code principles and dependency injection to ensure testability of core components.

I chose to focus on these areas because they directly impact user experience and the scalability of the app.

---

## Time Spent

I spent approximately **2-3 hours** working on this project. The time allocation was as follows:

- **0.5 hours:** Architecting the data flow (API, ViewModel, caching logic).  
- **1 hour:** Implementing UI using SwiftUI and handling image loading efficiently.  
- **0.5 hours:** Testing and refining the caching/pagination logic.  
- **0.5 hour:** Bug fixes and polishing the overall code structure.

---

## Trade-offs and Decisions

During the development process, I made the following trade-offs:

- **Pseudo-pagination:**  
   - Since the API does not support real pagination, I chose to fetch all data initially and simulate pagination on the client side. This approach provides a smoother user experience but increases initial load time and memory usage.
   - A better approach would be to have API support for pagination using limit-offset or cursor-based pagination.

- **No External Libraries:**  
   - Implemented image caching manually rather than using third-party libraries like `Kingfisher` or built in URLSession's HTTP caching to meet the project requirements of avoiding external dependencies.

- **Simplified UI:**  
   - Focused on functionality and clean architecture rather than overly complex UI elements, balancing between aesthetics and development time.

---

## Weakest Part of the Project

The weakest part of the project is the **pseudo-pagination** approach. Since the app fetches all data at once and simulates loading pages locally, it doesn't provide the benefits of true pagination, such as reducing API response size and improving network performance. Ideally, a backend that supports limit and offset or cursor pagination would be the preferred solution.

---

## Additional Information

Without the limitation of avoiding dependencies, we could explore the use of the **TCA (The Composable Architecture)** library instead of MVVM. This approach would enhance testability, improve separation of concerns, and take advantage of a unidirectional data flow, making the app more scalable and maintainable.

Additionally, features such as utilizing the **YouTube URL** or **source URL** from the API response could be implemented to provide users with more context and access to detailed recipe instructions directly from their sources.

---
