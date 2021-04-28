class Settings {
  String? appName;
  String? appVersion;
  int? focusMode;
  String? appLanguage;

  Settings({this.appName, this.appVersion, this.focusMode, this.appLanguage});

  Settings.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    appVersion = json['appVersion'];
    focusMode = json['focusMode'];
    appLanguage = json['appLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appName'] = this.appName;
    data['appVersion'] = this.appVersion;
    data['focusMode'] = this.focusMode;
    data['appLanguage'] = this.appLanguage;
    return data;
  }

  @override
  String toString() {
    return 'Settings(appName: $appName, appVersion: $appVersion, focusMode: $focusMode, appLanguage: $appLanguage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.appName == appName &&
        other.appVersion == appVersion &&
        other.focusMode == focusMode &&
        other.appLanguage == appLanguage;
  }

  @override
  int get hashCode {
    return appName.hashCode ^
        appVersion.hashCode ^
        focusMode.hashCode ^
        appLanguage.hashCode;
  }
}
