abstract interface class XboxAuthServiceInterface {
  Future<Map<String, String>> getXstsToken(String accessToken);
}
