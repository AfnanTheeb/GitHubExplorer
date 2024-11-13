# GitHub Users App

A Swift-based iOS application to browse GitHub users, repositories, and forks. This app leverages SwiftUI and UIKit to deliver a smooth user experience with a modern UI.

## Features

### User List (SwiftUI)
Displays a list of GitHub users fetched from GitHub APIs, including:
- Username
- Avatar image
- Number of public repositories
- Number of followers

### Repository List (UIKit)
Shows repositories for a selected user with:
- Repository name
- Description
- License information

### Forked Users List (UIKit + SwiftUI)
Displays all users who have forked the selected repository. The cell view is designed in SwiftUI and integrated into a UIKit list.

## Technologies Used

- **Swift**: Written entirely in Swift for clean and modern code structure.
- **SwiftUI**: Used for the user list and forked user cell view, providing a reactive and declarative UI experience.
- **UIKit**: Utilized for repository and forked users list, ensuring a versatile and flexible interface.
- **MVVM Architecture**: Adopts the Model-View-ViewModel pattern for a clean separation of business and UI logic.
- **Combine**: Manages data flow and binding between views and view models.
- **Core Data**: Caches user data to reduce network requests, especially beneficial for iPad users.

## Installation

Clone this repository:



Install dependencies if required and build the project.

### **Important Note**: 
To ensure the app functions properly, make sure you **open the scheme** and set your **GitHub Token**. This is required to authenticate and fetch data from the GitHub API.

## Usage

- **Launch the app**: The main view displays a list of GitHub users with basic information.
- **Select a user**: Tap on a user to view a list of their repositories.
- **View forked users**: Tap on a repository to see a list of users who have forked it.

## Screenshots

 
<p align="center">
  <img src="https://github.com/user-attachments/assets/55eee415-c0b8-4bd8-9095-2a2977755778" width="22%" style="border-radius: 16px; margin: 0 10px;" />
  <img src="https://github.com/user-attachments/assets/8520d98e-113a-47ca-bd72-a707b2f73c19" width="22%" style="border-radius: 16px; margin: 0 10px;" />
  <img src="https://github.com/user-attachments/assets/472721cb-35cf-4d29-bab1-cc18a22ce4aa" width="22%" style="border-radius: 16px; margin: 0 10px;" />
</p>




## License

This project is licensed under the MIT License. See the LICENSE file for details.



