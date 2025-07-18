import 'package:pb_authenticator_totp/totp.dart';
import 'package:uuid/uuid.dart';

class LegacyAuthenticatorItem {
  /// Legacy GUID id
  final String id;

  final TotpItem totp;
  String? iconPath;

  LegacyAuthenticatorItem(this.id, this.totp, {this.iconPath});

  static LegacyAuthenticatorItem newAuthenticatorItemFromUri(String uri, {String? iconPath}) {
    var id = Uuid().v4();
    return LegacyAuthenticatorItem(id, TotpItem.fromUri(uri), iconPath: iconPath);
  }

  static LegacyAuthenticatorItem newAuthenticatorItem(TotpItem item, {String? iconPath}) {
    var id = Uuid().v4();
    return LegacyAuthenticatorItem(id, item, iconPath: iconPath);
  }

  // static LegacyAuthenticatorItem newAuthenticatorItem(String secret,
  //     [int digits = 6,
  //     int period = 60,
  //     OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1,
  //     String issuer = "",
  //     String accountName = ""]) {
  //   var item = TotpItem(secret, digits, period, algorithm, issuer, accountName);
  //   var id = Uuid().v4();
  //   return LegacyAuthenticatorItem(id, item);
  // }

  /// Legacy decode.
  LegacyAuthenticatorItem.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        totp = TotpItem.fromJSON(json),
        iconPath = json['iconPath'];

  /// Legacy encode.
  Map<String, dynamic> toMap() => {
        'id': id,
        'accountName': totp.accountName,
        'issuer': totp.issuer,
        'secret': totp.secret,
        'digits': totp.digits,
        'period': totp.period,
        'algorithm': totp.algorithm.name,
        if (iconPath != null) 'iconPath': iconPath,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LegacyAuthenticatorItem && id == other.id && totp == other.totp && iconPath == other.iconPath;

  @override
  int get hashCode => id.hashCode ^ totp.hashCode ^ (iconPath?.hashCode ?? 0);
}
