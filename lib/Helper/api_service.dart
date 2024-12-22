String get baseUrl => 'https://event-backend-11.onrender.com/api/v1/';
String get imageBaseUrl => 'https://event-backend-11.onrender.com/';

class Config {
  static const String loginUser = 'organizer/login';
  static const String register = 'organizer/signup';
  static const String updateDetail = 'organizer/update/profile';
  static const String getUserDetail = 'organizer/detail';
  static const String getActiveEvents = 'organizer/events/active';
  static const String getPendingEvents = 'organizer/events/pending';
  static const String getCompletedEvents = 'organizer/events/completed';
  static const String getRejectedEvents = 'organizer/events/rejected';
  static const String createEvent = 'event/create';
  static const String getAllEvents = 'organizer/dashboard/events';
  static const String getDashboardData = 'organizer/dashboard';
}
