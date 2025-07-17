/// Provides encode and decode functions for the otpauth-migration URI format used to import into and export 2FA secrets from the Google Authenticator app
library otpauth_migration;

import 'dart:convert';
import 'dart:typed_data';
import 'generated/GoogleAuthenticatorImport.pb.dart';

/// A stateless class (not a singleton) that provides encode and decode functions for the otpauth-migration URI format used to import into and export 2FA secrets from the Google Authenticator app
class OtpAuthMigration {
  final List<String> _rfc3548 = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7"
  ];

  /// encode given list of optauth URIs into a single otpauth-migration URI
  String encode(List<String> otpAuths,
      {bool debug = false,
      int version = -1,
      int batchSize = -1,
      int batchIndex = -1,
      int batchId = -1}) {
    var gai = GoogleAuthenticatorImport();
    for (var otp in otpAuths) {
      var uri = Uri.parse(otp);
      //uri.queryParameters.forEach((k, v) {
      //  print('key: $k - value: $v');
      //  });
      var gaip = GoogleAuthenticatorImport_OtpParameters();
      gaip.name = Uri.decodeFull(uri.path.substring(1));
      //print("name = ${gaip.name}");
      try {
        gaip.secret = _encodeBase32(uri.queryParameters['secret']);
      } catch (e) {
        return "";
      }
      //print("issuer = ${uri.queryParameters['issuer']}");
      var issuer = uri.queryParameters['issuer'];
      if (issuer != null && issuer != "") {
        gaip.issuer = issuer;
      }
      gaip.type = GoogleAuthenticatorImport_OtpType.OTP_TYPE_TOTP;
      gaip.algorithm = GoogleAuthenticatorImport_Algorithm.ALGORITHM_SHA1;
      gaip.digits = GoogleAuthenticatorImport_DigitCount.DIGIT_COUNT_SIX;
      gai.otpParameters.add(gaip);
      if (debug) print(gaip);
    }
    if (version >= 0) gai.version = version;
    if (batchSize >= 0) gai.batchSize = batchSize;
    if (batchIndex >= 0) gai.batchIndex = batchIndex;
    if (batchId >= 0) gai.batchId = batchId;
    final bytes = gai.writeToBuffer();
    return "otpauth-migration://offline?data=${base64.encode(bytes)}";
  }
  
  int batchSize(String value) {
  	RegExp exp = RegExp(r"otpauth-migration\:\/\/offline\?data=(.*)$");
    final match = exp.firstMatch(value);
    final encodedUrl = match?.group(1);
    if (encodedUrl != null) {
      final encoded = Uri.decodeComponent(encodedUrl);
      var decoded = base64.decode(encoded);

      try {
        final gai = GoogleAuthenticatorImport.fromBuffer(decoded);
        return gai.batchSize;
      } catch(e) {
      	return -1;
      }
    } else {
    	return -1;
    }
  }
  
  int batchIndex(String value) {
  	RegExp exp = RegExp(r"otpauth-migration\:\/\/offline\?data=(.*)$");
    final match = exp.firstMatch(value);
    final encodedUrl = match?.group(1);
    if (encodedUrl != null) {
      final encoded = Uri.decodeComponent(encodedUrl);
      var decoded = base64.decode(encoded);

      try {
        final gai = GoogleAuthenticatorImport.fromBuffer(decoded);
        return gai.batchIndex;
      } catch(e) {
      	return -1;
      }
    } else {
    	return -1;
    }
  }

  /// decode a given otpauth-migration URI into a list of one or more otpauth URIs
  List<String> decode(String value, {bool debug = false}) {
    // check prefix "otpauth-migration://offline?data="
    // extract suffix - Base64 encode
    List<String> results = [];

    RegExp exp = RegExp(r"otpauth-migration\:\/\/offline\?data=(.*)$");
    final match = exp.firstMatch(value);
    final encodedUrl = match?.group(1);
    if (encodedUrl != null) {
      final encoded = Uri.decodeComponent(encodedUrl);
      var decoded = base64.decode(encoded);

      try {
        final gai = GoogleAuthenticatorImport.fromBuffer(decoded);

        if (debug) print(gai);

        //print(gai.otpParameters.length);
        for (var param in gai.otpParameters) {
          //print(param);
          var base32 = _decodeBase32(param.secret);
          //print("otpauth://totp/${param.name}?secret=${base32}");
          final name = Uri.encodeFull(param.name);
          final issuer = Uri.encodeComponent(param.issuer);
          String algorithm = "";
          switch(param.algorithm) {
          case GoogleAuthenticatorImport_Algorithm.ALGORITHM_SHA1:
          	algorithm = "&algorithm=SHA1";
          	break;
          case GoogleAuthenticatorImport_Algorithm.ALGORITHM_SHA256:
          	algorithm = "&algorithm=SHA256";
          	break;
          case GoogleAuthenticatorImport_Algorithm.ALGORITHM_SHA512:
          	algorithm = "&algorithm=SHA512";
          	break;
          case GoogleAuthenticatorImport_Algorithm.ALGORITHM_MD5:
          	algorithm = "&algorithm=MD5";
          	break;
          default:
          	algorithm = "";
          	break;
          }
          String digits = "";
          switch(param.digits) {
          case GoogleAuthenticatorImport_DigitCount.DIGIT_COUNT_SIX:
          	digits = "&digits=6";
          	break;
          case GoogleAuthenticatorImport_DigitCount.DIGIT_COUNT_EIGHT:
          	digits = "&digits=8";
          	break;
          default:
          	digits = "";
          	break;
          }
          results.add("otpauth://totp/$name?secret=$base32&issuer=$issuer$algorithm$digits&period=30");
        }

        //print("good");
        return results;
      } catch (e) {
        return results;
      }
    } else {
      //print("bad");
      return [];
    }
  }

  List<int> _encodeBase32(String? s) {
    int i = 0;
    var j = 0;

    if (s != null) {
      Uint8List result = Uint8List((s.length * 5) ~/ 8);
      while (i < s.length) {
        // ZERO
        var c = s[i];
        var k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = k << 3;
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | (k >> 2);

        //print("---> ${result[j]}");
        j++;

        // ONE
        result[j] = k << 6;
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | (k << 1);
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | (k >> 4);

        //print("---> ${result[j]}");
        j++;

        // TWO
        result[j] = k << 4;
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | (k >> 1);

        //print("---> ${result[j]}");
        j++;

        // THREE
        result[j] = k << 7;
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | (k << 2);
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | (k >> 3);

        //print("---> ${result[j]}");
        j++;

        // FOUR
        result[j] = k << 5;
        i++;

        c = s[i];
        k = _rfc3548.indexOf(c);
        //print(k);
        result[j] = result[j] | k;
        i++;

        //print("---> ${result[j]}");
        j++;
      }
      //print(result);
      return result;
    }
    return Uint8List(0);
  }

  String _decodeBase32(List<int> s) {
    //print(s);
    Uint8List ulist = s as Uint8List;
    String result = "";

    var i = 0;
    while (i < ulist.length) {
      var q0 = ulist[i] & 0xF8;
      q0 = q0 >> 3;
      //print(_rfc3548[q0]);
      result += _rfc3548[q0];

      var q1 = ulist[i++] & 0x07;
      q1 = q1 << 2;
      var temp = ulist[i] & 0xC0;
      temp = temp >> 6;
      q1 = q1 + temp;
      //print(_rfc3548[q1]);
      result += _rfc3548[q1];

      var q2 = ulist[i] & 0x3E;
      q2 = q2 >> 1;
      //print(_rfc3548[q2]);
      result += _rfc3548[q2];

      var q3 = ulist[i++] & 0x01;
      q3 = q3 << 4;
      temp = ulist[i] & 0xF0;
      temp = temp >> 4;
      q3 = q3 + temp;
      //print(_rfc3548[q3]);
      result += _rfc3548[q3];

      var q4 = ulist[i++] & 0x0F;
      q4 = q4 << 1;
      temp = ulist[i] & 0x80;
      temp = temp >> 7;
      q4 = q4 + temp;
      //print(_rfc3548[q4]);
      result += _rfc3548[q4];

      var q5 = ulist[i] & 0x7c;
      q5 = q5 >> 2;
      //print(_rfc3548[q5]);
      result += _rfc3548[q5];

      var q6 = ulist[i++] & 0x03;
      q6 = q6 << 3;
      temp = ulist[i] & 0xE0;
      temp = temp >> 5;
      q6 = q6 + temp;
      //print(_rfc3548[q6]);
      result += _rfc3548[q6];

      var q7 = ulist[i++] & 0x1F;
      //print(_rfc3548[q7]);
      result += _rfc3548[q7];
    }

    //print(result);
    return result;
  }
}
