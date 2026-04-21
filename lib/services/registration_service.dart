class RegistrationService {
  static List<Map> registeredEvents = [];

  static void registerEvent(Map event) {
    registeredEvents.add(event);
  }

  static List<Map> getRegisteredEvents() {
    return registeredEvents;
  }
}