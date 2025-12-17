# Firestore Security Rules

Copy and paste these rules exactly into Firebase Console → Firestore → Rules tab:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create, update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /clubs/{clubId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Alternative: Simpler Test Mode Rules (for development only)

If you're still getting errors, use these simpler rules for testing:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**⚠️ Warning:** The simpler rules allow any authenticated user to read/write all documents. Only use for development/testing!

## How to Apply:

1. Go to Firebase Console → Firestore Database → Rules tab
2. Delete all existing rules
3. Copy the rules above (starting from `rules_version`)
4. Paste into the rules editor
5. Click "Publish"
6. Wait for confirmation message

## Common Errors:

- **Parse error on line 1**: Make sure you're copying from `rules_version` (not including markdown code blocks)
- **Missing quotes**: Ensure `'2'` has single quotes
- **Extra characters**: Don't copy the triple backticks (```) if copying from markdown

