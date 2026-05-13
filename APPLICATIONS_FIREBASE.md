# Firebase Applications Documentation

## Overview
Applications submitted to projects are now stored in Firebase Firestore, allowing project owners to view and manage applicants.

## Collection Structure

### `applications` Collection
Each document represents a single application from a user for a specific project role.

**Fields:**
- `userId` (string): Firebase UID of the applicant
- `projectId` (string): ID of the project being applied to
- `projectName` (string): Name of the project
- `role` (string): The role the user applied for
- `status` (string): Application status - "PENDING", "ACCEPTED", or "REJECTED"
- `appliedDate` (string): Date in YYYY-MM-DD format
- `createdAt` (timestamp): Server timestamp for sorting

## Usage

### For Applicants

#### Submit an Application
```dart
final appService = ApplicationService();
try {
  await appService.submitApplication(
    projectId: 'p1',
    projectName: 'Neo-Surrealist Gallery',
    role: '3D Artist',
  );
  // Success - show feedback to user
} catch (e) {
  // Handle error (e.g., already applied, not authenticated)
}
```

#### View Your Applications
Applications are fetched and displayed in real-time:
```dart
// In ApplicationsPage - uses StreamBuilder
StreamBuilder<List<Application>>(
  stream: appService.streamUserApplications(),
  builder: (context, snapshot) {
    // Display applications list
  },
)
```

### For Project Owners (Future)

#### Get All Applications for a Project
```dart
final appService = ApplicationService();
final applications = await appService.getProjectApplications('p1');
// applications is List<Map<String, dynamic>> containing all applicants
```

#### Update Application Status
```dart
await appService.updateApplicationStatus(applicationId, 'ACCEPTED');
```

## Security Considerations

### Firestore Security Rules (Recommended)
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /applications/{document=**} {
      // Users can read their own applications
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      
      // Users can only create new applications
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      
      // Only project owners can update application status
      // (This would require a users/owners collection or similar)
      allow update: if request.auth != null;
      
      // Deny deletes to keep application history
      allow delete: if false;
    }
  }
}
```

## Error Handling

The application service handles these scenarios:
- **User not authenticated**: Throws "User not authenticated"
- **Duplicate application**: Throws "You have already applied for this role"
- **Network errors**: Throws error message from Firestore

All errors are caught and displayed to the user via snackbar notifications.

## Real-Time Features

Applications page uses `StreamBuilder` for real-time updates:
- New applications appear instantly
- Status changes are reflected immediately
- Automatic connection management
- Loading and error states handled

## Testing

To test the implementation:
1. Create a test account
2. Navigate to Explore page
3. Select a project and apply for a role
4. Navigate to Applications - should see the submitted application
5. Application status starts as "PENDING"
6. Check Firestore console to verify data structure

## Future Enhancements

1. **Project Owner Dashboard**: View all applications for their projects
2. **Status Management**: Accept/reject applications with comments
3. **Notifications**: Email alerts for applicants and project owners
4. **Bulk Operations**: Accept/reject multiple applications
5. **Analytics**: Application statistics by project and role
