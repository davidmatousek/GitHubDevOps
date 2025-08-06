# GitHubDevOps

A SwiftUI iOS application that connects to the GitHub GraphQL API to measure CI/CD metrics and display comprehensive GitHub data. The app provides insights into repositories, organizations, and user information through a native iOS interface.

## Features

- **Secure Authentication**: OAuth flow with secure iOS Keychain token storage
- **User Profile**: Display comprehensive GitHub profile information (name, company, email, location, Twitter)
- **Repository Metrics**: View detailed repository statistics including forks, issues, stars, watchers, and pull requests
- **Organization Data**: Access organization memberships and their repositories
- **Secure Logout**: Automatic credential cleanup and session management

## Architecture

- **SwiftUI** for modern iOS UI development
- **Apollo GraphQL** client for GitHub API integration
- **iOS Keychain** for secure token storage using KeychainHelper utility
- **OAuth 2.0** authentication flow with GitHub

## Quick Start

1. **Create GitHub OAuth Application**
   - Go to GitHub → Settings → Developer settings → OAuth Apps
   - Click "New OAuth App" and fill in:
     - Application Name: Your choice
     - Homepage URL: Your choice (not critical)
     - Application description: Your choice
     - Authorization callback URL: `com.alphafish.GitHubDevOps://oauth/callback`

2. **Clone and Setup**
   ```bash
   git clone https://github.com/davidmatousek/GitHubDevOps
   cd GitHubDevOps
   cp GitHubDevOps/PropertyFiles/Keys.plist.template GitHubDevOps/PropertyFiles/Keys.plist
   ```

3. **Configure Credentials**
   - Edit `GitHubDevOps/PropertyFiles/Keys.plist`
   - Add your GitHub OAuth Client ID, Secret, and callback URL
   - See [SETUP.md](SETUP.md) for detailed configuration instructions

4. **Build and Run**
   - Open `GitHubDevOps.xcodeproj` in Xcode
   - Build and run the project

## Security

- OAuth credentials stored locally only (excluded from git)
- Bearer tokens stored securely in iOS Keychain
- Automatic credential cleanup on logout
- Session persistence across app launches

For detailed setup and security information, see [SETUP.md](SETUP.md).

## Recent Updates

- **Security Enhancement**: Migrated from UserDefaults to iOS Keychain for token storage
- **User Experience**: Added comprehensive user profile view with logout functionality
- **Data Expansion**: Enhanced GraphQL queries to fetch additional user profile fields
- **Error Handling**: Improved data safety with nil-checking and graceful error handling
