# GitHubDevOps Setup Instructions

## Security Setup

This project requires GitHub OAuth credentials to function properly. For security reasons, these credentials are not included in the repository.

### 1. Setup GitHub OAuth Application

1. Go to GitHub → Settings → Developer settings → OAuth Apps
2. Click "New OAuth App"
3. Fill in the application details:
   - **Application name**: Your choice (e.g., "GitHubDevOps Local")
   - **Homepage URL**: Your choice (e.g., http://localhost)
   - **Application description**: Your choice
   - **Authorization callback URL**: `com.alphafish.GitHubDevOps://oauth/callback` (or your custom scheme)

4. After creating the app, note down:
   - **Client ID**
   - **Client Secret**

### 2. Setup Local Configuration

1. Copy the template file:
   ```bash
   cp GitHubDevOps/PropertyFiles/Keys.plist.template GitHubDevOps/PropertyFiles/Keys.plist
   ```

2. Edit `GitHubDevOps/PropertyFiles/Keys.plist` and replace the placeholder values:
   ```xml
   <key>client_id</key>
   <string>YOUR_ACTUAL_GITHUB_CLIENT_ID</string>
   <key>client_secret</key>
   <string>YOUR_ACTUAL_GITHUB_CLIENT_SECRET</string>
   <key>redirect_uri</key>
   <string>com.alphafish.GitHubDevOps://oauth/callback</string>
   <key>GitHubToken</key>
   <string>OPTIONAL_PERSONAL_ACCESS_TOKEN</string>
   ```

3. **Important**: Never commit the actual `Keys.plist` file to version control. It's already in `.gitignore`.

### 3. Security Features

This app implements comprehensive security practices:

- ✅ **OAuth credentials**: Stored locally in `Keys.plist` (excluded from git)
- ✅ **Bearer tokens**: Stored securely in iOS Keychain using KeychainHelper utility
- ✅ **Automatic cleanup**: Tokens are securely deleted on logout via ViewerView
- ✅ **Session persistence**: Secure authentication state maintained across app launches
- ✅ **Error handling**: Graceful handling of keychain operations with fallbacks

### 4. Development

After setup, the app will:
1. Read OAuth credentials from your local `Keys.plist`
2. Use them to authenticate with GitHub using updated redirect URI
3. Store the resulting bearer token securely in iOS Keychain via KeychainHelper
4. Use the bearer token for GraphQL API requests with enhanced user profile data
5. Provide secure logout functionality that clears all stored credentials

The OAuth flow remains the same but with improved security and expanded user profile features.

## Troubleshooting

- **Login not working**: Check that your `Keys.plist` has the correct OAuth credentials
- **Build errors**: Ensure `Keys.plist` exists and has the correct format
- **OAuth errors**: Verify your callback URL matches your GitHub OAuth app settings