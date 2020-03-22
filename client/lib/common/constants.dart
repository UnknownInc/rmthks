enum Environment { DEV, STAGING, PROD }

class Constants {
  static Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.STAGING:
        _config = _Config.qaConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get APIPREFIX {
    return _config[_Config.APIPREFIX];
  }
}

class _Config {
  static const APIPREFIX = "APIPREFIX";

  static Map<String, dynamic> debugConstants = {
    APIPREFIX: "http://127.0.0.1:8080/",
  };

  static Map<String, dynamic> qaConstants = {
    APIPREFIX: "http://127.0.0.1:8080/",
  };

  static Map<String, dynamic> prodConstants = {
    APIPREFIX:"/"
  };
}