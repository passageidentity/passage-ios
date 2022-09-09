# Login

This guide will explain how to log in users with the passage-ios framework.

## Overview

Login will attempt to use a Passkey on the user's device if supported (iOS 16+) and if not supported will send the user a login magic link.

A Passkey login attempt can fail if the user does not have a valid Passkey on the device or if they cancel the Passkey prompt. In either of these cases a login magic link will be sent to the user. Upon successful activation of the magic link the user will be authenticated. We reccomend providing the option to add a Passkey to the device (using PassageAuth.addDevice if supported).


The login method returns a tuple with 2 optionals

```
(authResult: AuthResult?, magicLink: MagicLink?)
```

You will need to check whether the authResult or magicLink or none of these are returned. If authResult was returned, then the user was registered and authenticated, if magicLink was returned then the user was sent a magic link. If neither value is returned no action was performed.

```
// Unmanaged tokens
do {
    let result = try await PassageAuth.login(identifier: identifier)
    if let authResult = result.authResult {
        // user was logged in with a Passkey
    } else if let magicLink = result.magicLink {
        // user was sent a magic link
    } else {
        // no successful results
    }
} catch {
    // an error occured
}
```

```
// Managed tokens
do {
    let passage = PassageAuth(tokenStore: PassageStore.shared)
    let result = try await passage.login(identifier: identifier)
    if let authResult = result.authResult {
        // user was logged in with a Passkey
        // PassageStore.shared should contain their authToken
        print("token: \(PassageStore.shared.authToken)")
    } else if let magicLink = result.magicLink {
        // user was sent a magic link
    } else {
        // no successful results
    }
} catch {
    // an error occured
}
```
