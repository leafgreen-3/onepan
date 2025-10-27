// Simple DI placeholder for app-wide dependencies.
// This keeps structure ready without pulling extra packages yet.

class AppDependencies {
  const AppDependencies();
  // Add service getters or factories here when needed.
}

// Global singleton for now; replace with a proper container later.
const appDependencies = AppDependencies();

