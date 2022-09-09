# Getting Started

This guide provides a high level view of the passage-ios framework and how to get started with it.

## Overview

The passage-ios framewok includes classes that provide everything you need to create and authenticate, and manage users in your application.

### PassageAuth

PassageAuth is the primary class you will work with. It provides the following:

- Registration
- Login
- Sign Out (if you use a Passage Token Store)
- User Management
- App Details
- And More

There are 2 ways of using PassageAuth depending on how you want to manage your user's tokens.

#### Type Methods

PassageAuth exposes all methods as Type Methods if you want to manage your user's token yourself. Using this approach the storage of the user's tokens is up to you. The methods which return tokens will simply return the tokens for you to manage. To use the type methods simply call the methods on the type:

```
// register
let result = try await PassageAuth.register(identifier: 'emailORPhone')

// login
let result = try await PassageAuth.login(identifier: 'emailOrPhone')
```

#### Instance Methods

PassageAuth also exposes methods through an Instance. When creating a new instance you can either pass a class that implements the PassageTokenStore protocol or use the shared instance of PassageStore (which is the default if you don't instantiate with a store). Using this approach the methods will still return the tokens but will also manage the tokens by setting or deleting the tokens in the store for you. To use the instance methods:

```
// instantiate with your own store
let passage = PassageAuth(store: yourStore)

// or instantiate using the PassageStore shared instance
let passage = PassageAuth()

// register
let result = try await passage.register(identifier: 'emailOrPhone')

// login
let result = try await passage.login(identifier: 'emailOrPhone')
```

#### PassageStore

The PassageStore class implements the PassageTokenStore protocol and can be used with PassageAuth to manage the storage/retrieval of your user's tokens. It is a Singleton class and you use a 'shared' instance of it. If you instantiate PassageAuth without a tokenStore, it will use PassageStore.shared to manage your tokens for you.

- Implements PassageAuthToken store so it can be used by PassageAuth to manage your tokens for you
- Wraps Keychain to securely store your user's tokens

#### PassageTokenUtils

This class contains both instance and type methods to use when working with a user's tokens.

- Decode tokens
- Check token expiration

Use the type methods you pass a token to each type method.

```
let decodedToken = PassageTokenUtils.decode(jwtToken: 'tokenstring')

let isExpired = PassageTokenUtils.isTokenExpired(decodedToken: decodedToken)
```

If you want to use the instance methods then you pass the token to the initializer:

```
 let token = PassageTokenUtils(token: 'tokenString')
 let decodedToken = token.decodedToken

 let isExpired = token.isExpired
```

### Async / Handling errors

Passage methods are all async functions that can throw errors. So you should wrap the calls in a do...catch

If the wrapping code is async simply use try await:

```
do {
    let result = try await PassageAuth.login()
} catch {
    // handle error
}
```

Or you can wrap it in a task:

```
Task {
    do {
        let result = try await PassageAuth.login()
    } catch {
        // handle error
    }
}
```
