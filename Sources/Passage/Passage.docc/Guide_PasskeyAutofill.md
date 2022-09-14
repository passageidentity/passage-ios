# Guide PasskeyAutofill

Enable Passkey autofill to make it easier for your users to login with Passkeys.

## Overview

Passkey autofill makes it easy for your users to use Passkeys. If the user already has a passkey on their device they will be able to select it from the keyboard autofill as soon as the focus the identifier input.

![Passkey Autofill](autofill)

### How to enable

### Setup Your Input

You will need to set the textContentType of your identifier input to be "username"

You can set this in interface builder, or in code:

If you have a reference in your controller to identifierField:

```swift
identifierField.textContentType = "username" 
```

### Start the Autofill Service
”””
You will need to start the autofill service as early in the process as you can on the View that is rendering your identifier field.

For example when a view appears:

```swift
    override func viewDidAppear(_ animated: Bool) {
        guard let window = self.view.window else { fatalError("The view was not in the app's view hierarchy!") }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                try await PassageAuth.beginAutoFill(anchor: window, onSuccess: self.onAutofillSuccess, onError: self.onAutofillError, onCancel: nil)
            }
        }
        // other code
    }
```

You will need to pass onSuccess, onError, and onCancel methods to handle autofill callbacks, all three are optional but it is recommended you handle onSuccess and OnError at a minimum. So you can respond to the results if they select the passkey to autofill.

```swift
func onAutofillSuccess(authResult: AuthResult) {
    if let token = authResult.auth_token {
        DispatchQueue.main.async {
            self.pushWelcomeViewController(token: token)
        }
    }
}
```

```swift
func onAutofillError(error: Error) {
    DispatchQueue.main.async {
        self.displayError(message: "Error logging in with autofill")
    }
}    
```
