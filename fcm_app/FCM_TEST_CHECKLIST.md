# FCM Test Checklist

Use this after every fix.

## 1. Foreground Test
- Keep the app open and visible.
- Send a message from Firebase Console to the current token.
- Verify the log appears and the UI changes immediately.

## 2. Background Test
- Send the app to the background without force closing it.
- Send a notification message and tap it.
- Verify the app reopens and processes the payload.

## 3. Terminated Test
- Fully close the app.
- Send a message, then launch by tapping the notification.
- Verify `getInitialMessage()` behavior is reflected in the UI.

## 4. Payload Accuracy Test
- Send one valid payload and one intentionally incomplete payload.
- Confirm valid keys update the expected UI element.
- Confirm missing keys do not crash the app.

## 5. Permission Test
- Deny permission once and observe behavior.
- Grant permission and retest delivery.
- Document what changes when permission is denied.

## 6. Regression Test
- After every fix, repeat the full working path.
- Use hot reload for UI changes.
- Use hot restart for plugin or init changes.
- Retest the token if you reinstall the app, because the token may change.

## Quick Rules
- UI-only change: hot reload.
- Firebase init, permissions, service, or plugin change: hot restart.
- Reinstall app: copy the new FCM token and retest.
