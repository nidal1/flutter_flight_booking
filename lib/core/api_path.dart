class APIPath {
  static String flight(String flightId) => 'flights/$flightId';
  static String flights() => 'flights';
  static String ticket(String ticketId) => 'tickets/$ticketId';
  static String tickets() => 'tickets';
}
