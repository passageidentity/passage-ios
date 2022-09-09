# User Registration

This guide will explain how to register new users with the passage-ios framework.

## Overview

Register a new user on your application. 

Registration will either prompt the user to create a new Passkey for your domain or it will send the user a Magic Link that when clicked will perform the registration. On success of either path it will register a new user on your Passage app. The method chooses the Passkey or Magic Link flow depending on the iOS Version and how your Passage application is configured.

If the version of iOS is less than v16 or you have your Passage application configured to require identifier verification a magic link will be sent.

If the version of iOS is v16+ and you do not require identifier verification the register method will attempt to create a new Passkey on the device. The user can cancel this action, and if they do, then the user will be sent a magic link.

If the magic link is set, your application must be configured to handle this link on the device so that registration can be completed and the user given the option to create a Passkey (if supported).

The registration method returns a tuple with two optionals

```
(authResult: AuthResult?, magicLink: MagicLink?)
```

You will need to check whether the authResult or magicLink or none of these are returned. If authResult was returned, then the user was registered and authenticated, if magicLink was returned then the user was sent a magic link. If neither value is returned no action was performed.

```
// Unmanaged tokens
do {
    let result = try await PassageAuth.register(identifier: identifier)


    if let authResult = result.authResult {
        print("users auth token: \(authResult.auth_token)")
        // user was registered
        // store your token and proceed with login
    } else if let magicLink = result.magicLink {
        print("users magic link id: \(magicLink.id)")
        // magic link was sent, prompt user to check for magic link.
    } else {
        // no successful results
    }
}
} catch {
    // an error occured
}
```

```
// Managed tokens
do {

    let Passage = PassageAuth(tokenStore: PassageStore.shared)

    let result = try await passage.register(identifier: identifier)

    if let authResult = result.authResult {
        print("users auth token: \(authResult.auth_token)")
        print("users auth token from store: \(PassageStore.shared.authToken)")
        // user was registered
    } else if let magicLink = result.magicLink {
        print("users magic link id: \(magicLink.id)")
        // magic link was sent, prompt user to check for magic link.
    } else {
        // no successful results
    }
}
} catch {
    // an error occured
}

```
