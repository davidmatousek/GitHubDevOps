# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GitHubDevOps is a SwiftUI iOS application that connects to the GitHub GraphQL API to measure CI/CD metrics and display GitHub data. The app provides insights into repositories, organizations, and user information through a native iOS interface.

## Architecture

**Core Components:**
- **Network Layer** (Network.swift): Apollo GraphQL client with authentication handling
- **Data Models** (Models/): Repository, Organization, and Viewer structs
- **Views** (Screens/): SwiftUI views organized by feature (Home, Login, Organization, Viewer)
- **Security Layer** (KeychainHelper.swift): Secure token storage using iOS Keychain
- **GraphQL Integration**: Auto-generated API.swift from FetchViewerQuery.graphql

**Key Architecture Patterns:**
- Uses Apollo GraphQL client for GitHub API communication
- SwiftUI with @EnvironmentObject for state management
- OAuth authentication flow with secure bearer token storage in iOS Keychain
- Navigation-based UI with detail views for repositories and organizations

## Development Commands

**Build the project:**
```bash
# Open in Xcode
open GitHubDevOps.xcodeproj

# Build from command line
xcodebuild -project GitHubDevOps.xcodeproj -scheme GitHubDevOps build
```

**Run tests:**
```bash
xcodebuild -project GitHubDevOps.xcodeproj -scheme GitHubDevOps test
```

**CI/CD:**
GitHub Actions workflow configured in `.github/workflows/swift.yml` for macOS builds (currently commented out)

## Authentication Setup

The app requires GitHub OAuth configuration:
1. Create a GitHub OAuth Application
2. Copy `PropertyFiles/Keys.plist.template` to `PropertyFiles/Keys.plist`
3. Update the new `Keys.plist` with your actual credentials:
   - `client_id`: Your GitHub OAuth app client ID
   - `client_secret`: Your GitHub OAuth app secret
   - `redirect_uri`: OAuth callback URL (e.g., "octonotes://auth")
   - `GitHubToken`: GitHub personal access token (optional)

**Security Features:**
- OAuth credentials stored locally only (excluded from git)
- Bearer tokens stored securely in iOS Keychain using KeychainHelper utility
- Automatic credential cleanup on user logout
- Secure authentication state management with persistent sessions
- See `SETUP.md` for detailed setup instructions

## Key Files

- `FetchViewerQuery.graphql`: GraphQL query definition for fetching user, organizations, and repositories
- `API.swift`: Auto-generated Apollo GraphQL types and queries
- `Network.swift`: HTTP transport configuration with authentication headers
- `KeychainHelper.swift`: Secure token storage utility for iOS Keychain operations
- `Keys.plist`: OAuth credentials (requires manual setup)
- `ViewerView.swift`: User profile view with logout functionality

## GraphQL Schema

The app uses GitHub's GraphQL API v4 with a comprehensive query that fetches:
- User profile information (name, company, email, avatar, location, twitter)
- User repositories with metrics (forks, issues, stars, watchers, PRs)
- Organization memberships and their repositories
- Repository metadata (owner, description, last pushed date)

## Recent Updates

**Authentication & Security Enhancements:**
- Migrated from UserDefaults to iOS Keychain for secure token storage
- Added KeychainHelper utility class for standardized secure operations
- Enhanced ViewerView with extended user profile fields
- Implemented secure logout functionality with automatic credential cleanup

**User Experience Improvements:**
- Added user profile view (ViewerView) displaying comprehensive GitHub profile data
- Enhanced GraphQL query to fetch additional user fields (company, email, location, twitter)
- Improved data safety with nil-checking and error handling