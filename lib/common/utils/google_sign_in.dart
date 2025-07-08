// Helper method to map Firebase auth error codes to human-readable messages
String getFirebaseAuthErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'This user has been disabled.';
    case 'user-not-found':
      return 'No user found with this email.';
    case 'wrong-password':
      return 'Incorrect password.';
    case 'email-already-in-use':
      return 'This email is already in use.';
    case 'weak-password':
      return 'The password provided is too weak.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled.';
    case 'account-exists-with-different-credential':
      return 'An account already exists with the same email address but different sign-in credentials.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';
    default:
      return 'An unknown authentication error occurred.';
  }
}
