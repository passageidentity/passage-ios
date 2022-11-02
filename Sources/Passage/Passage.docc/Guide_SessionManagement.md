# Session Management

This guide provides an overview of how session management is handled using Passage and how to use passage-ios to handle refresh tokens.

## Overview

Passage supports a variety of session management capabilities that improve security and end user experience by enabling long-lived sessions and token revocation support. Learn more about session management with Passage through the [online documentation](https://docs.passage.id/auth-configuration/session-management).

## Using Refresh Token in Your Application

Once refresh tokens are enabled, future login requests will include a `refresh_token` in the `AuthResult`. If you are using the default `PassageTokenStore` then the storage of this token will be handled. You only want to use refresh tokens when an auth token is expired. You should NOT refresh the token on every API request. You can use the `getAuthToken()` functions of PassageAuth to get teh correct auth token to send to your application. This checks if the auth token is expired and tries to refresh it silently as needed.


```
// Unmanaged tokens
do {
    let result = try await PassageAuth.authToken(authToken: authToken, refreshToken: refreshToken)
    print("users auth token: \(result.auth_token)")
    print("users refresh token: \(result.refresh_token)")
    // store your tokens and proceed with backend API call
}
} catch PassageSessionError.loginRequired {
    // refresh token has expired, need to log user in again
}
```

```
// Managed tokens
do {

    let Passage = PassageAuth(tokenStore: PassageStore.shared)

    let authToken = try await passage.getAuthToken()
    print("users auth token: \(authResult.auth_token)")
    // proceed with backend API call
}
} catch PassageSessionError.loginRequired {
    // refresh token has expired, need to log user in again
}

```

When a user logs out of your application call the `signOut()` instance method or static function to revoke the refresh token for the current session.
