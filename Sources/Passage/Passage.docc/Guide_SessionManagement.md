# Session Management

This guide provides an overview of how session management is handled using Passage and how to use passage-ios to handle refresh tokens.

## Overview

Passage supports a variety of session management capabilities that improve security and end user experience by enabling long-lived sessions and token revocation support.

### Stateless Session Management
Stateless session management means that the session token is not stored anywhere on the server (the Passage server or your application server). This is done in the form of JSON Web Tokens (JWTs), which are JSON-formatted tokens that are cryptographically signed by Passage to ensure they have not been tampered with. To verify a session, an application can use the public key provided by Passage to check the signature on the token. If it passes, the data in the JWT can be trusted.

JWTs provide great session security with low latency because they can be verified without contacting the Passage API. The downside to stateless sessions is that revocation and long lived sessions (common in mobile applications) can be difficult, if not impossible, to implement.

## Refresh Tokens
Passage also supports a hybrid session management solution that provide the low latency of stateless JWT-based sessions, with the revocation capabilities of stateful sessions.

Here’s how it works: When a user logs into your application with Passage, they are issued an auth token and a refresh token. The auth token is a stateless JWT that can be verified using a public key from Passage and grants users access to your application. It is designed to be short-lived. The refresh token is a long-lived stateful token that can be used to get a new auth token when one has expired.

Behind the scenes, Passage isn’t storing these sensitive tokens in our database. A cryptographic hash (HMAC) is stored that allows validation of an authentic data signature without holding any additional data linked to your customer accounts.

### Refresh Token Rotation
To provide additional security out of the box, Passage has also introduced refresh token rotation that is enabled by default whenever you use refresh tokens. Rotation means that every time a refresh token is used to get a new auth token, a new refresh token is also issued and the original refresh token is invalidated.

The main reason for this is to prevent replay attacks - someone gaining access to the original refresh token and trying to use it to get an auth token. Passage provides an additional layer of security by detecting when an old refresh token has been compromised, invalidating all tokens related to the compromised refresh token, and requiring the user to re-authenticate.

### Configuring Refresh Tokens
Refresh tokens are disabled by default. To enable this functionality visit Authentication → Session Management in the Passage Console. From there, choose your session timeouts.
* The auth token lifetime should be short when enabling refresh tokens, from seconds to about 10 minutes.
* The absolute expiration corresponds to the expiration of a refresh token and should be the maximum session length that you want to enforce.
* The inactivity timeout will expire refresh tokens of users who have been inactive on your site for the specified period of time, so users will be required to re-authenticate on next visit.

### Suggested Token Lifetimes
Here are some suggestions based on the type of application:
* For most consumer applications, you can typically use the defaults: 1 hour auth token lifetime, 30 day absolute lifetime, and 5 day inactivity timeout.
* For applications requiring higher security due to sensitive data or transactions, consider lowering the thresholds to 5 minute auth token lifetime, 24 hour absolute timeout, 30 minute inactivity timeout.
* For long lived applications, you can use a 1 hour auth token lifetime, 180 day absolute lifetime, and no inactivity timeout. These are typically apps where users may not log in often, but you don't want to make them re-authenticate.

### Using Refresh Tokens in Your Application
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
