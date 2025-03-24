class ApiConfig {
  final String baseUrl;
  final int timeout;
  final String apiVersion;

  ApiConfig({
    this.baseUrl = 'http://127.0.0.1:8000/api',
    this.timeout = 30,
    this.apiVersion = 'v1',
  });
}
