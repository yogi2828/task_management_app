Gig Task Manager App
A mobile application designed to help gig workers efficiently manage their tasks, clients, and schedules. Stay organized, prioritize your work, and keep track of your gigs with ease.

✨ Features
User Authentication: Secure sign-up and login for gig workers.

Task Management: Create, read, update, and delete tasks.

Task Prioritization: Assign priority levels (High, Medium, Low) to tasks.

Task Status: Mark tasks as complete or incomplete.

Due Dates: Set due dates for tasks to ensure timely completion.

Filtering: Filter tasks by priority and completion status.

Real-time Updates: Tasks update in real-time across devices.

Intuitive UI: Clean and user-friendly interface designed for productivity.

🛠️ Technologies Used
Flutter: Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

Dart: The programming language used by Flutter.

Firebase Authentication: For secure user registration and login.

Cloud Firestore: A NoSQL cloud database for storing and syncing task data in real-time.

BLoC (Business Logic Component): For state management, ensuring a clear separation of concerns.

GetIt: A simple Service Locator for Dart and Flutter projects.

Equatable: For easily comparing Dart objects.

Dartz: For functional programming paradigms, especially Either for error handling.

UUID: For generating unique IDs for tasks.

Intl: For date and time formatting.

📸 Screenshots
Here are some screenshots showcasing the Gig Task Manager app's interface and features:

Login Page

Registration Page

Task List

Create/Edit Task

Filtered Tasks

Task Detail (Example)

(Note: Replace path/to/your/*.png with the actual paths or URLs to your screenshots.)

🚀 Setup & Installation
Follow these steps to get a copy of the project up and running on your local machine for development and testing purposes.

Prerequisites
Flutter SDK installed.

Firebase CLI installed.

A Firebase project set up.

Installation Steps
Clone the repository:

git clone https://github.com/your-username/gig_task_manager.git
cd gig_task_manager

Install Flutter dependencies:

flutter pub get

Set up Firebase for your project:

Make sure you have a Firebase project created in the Firebase Console.

Run the FlutterFire configuration command to link your Flutter project to Firebase:

flutterfire configure

Follow the prompts to select your Firebase project and the platforms you want to configure (Android, iOS, Web). This will generate lib/firebase_options.dart.

🔥 Firebase Setup (Important!)
For the app to function correctly, especially for task creation and authentication, you MUST configure Firebase Firestore security rules and enable authentication methods.

Firestore Security Rules
For development/testing, you might use permissive rules. However, for production, implement strict rules.

For Testing (Highly INSECURE - Use with Caution!):
Go to your Firebase project -> Firestore Database -> Rules tab, and replace your rules with:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // WARNING: This rule allows ANYONE (authenticated or not) to read and write ALL documents
    // in this database. This is EXTREMELY INSECURE and should ONLY be used for temporary testing.
    match /{document=**} {
      allow read, write: if true;
    }
  }
}

Publish these rules.

Authentication Methods
Go to your Firebase project -> Authentication -> Sign-in method, and enable:

Email/Password

If you plan to implement social logins (Google, Facebook, Apple), you will also need to:

Enable them in Firebase Authentication.

Follow the platform-specific setup guides (e.g., for Google Sign-In, configure OAuth consent screen, client IDs, and SHA-1 fingerprints in Google Cloud Console).
(The current app UI for social login buttons are placeholders and require further code implementation and platform setup.)

▶️ Usage
Run the app:

flutter run

Register a new account using the email and password option.

Log in with your newly created credentials.

You will be directed to the Task List page.

Use the + Floating Action Button to create new tasks.

Tap on existing tasks to edit them.

Swipe left on a task to delete it.

Use the filter chips at the top to sort tasks by priority or status.

Click the logout icon in the AppBar to log out.

✉️ Contact & Support
If you have any questions, suggestions, or encounter issues, feel free to reach out or open an issue on the GitHub repository.

Author: Your Name/Organization

Email: your.email@example.com

GitHub Issues: Link to your GitHub Issues (if applicable)