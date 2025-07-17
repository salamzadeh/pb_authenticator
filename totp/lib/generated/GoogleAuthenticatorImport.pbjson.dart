///
//  Generated code. Do not modify.
//  source: GoogleAuthenticatorImport.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use googleAuthenticatorImportDescriptor instead')
const GoogleAuthenticatorImport$json = const {
  '1': 'GoogleAuthenticatorImport',
  '2': const [
    const {
      '1': 'otp_parameters',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.KeePassOTP.GoogleAuthenticatorImport.OtpParameters',
      '10': 'otpParameters'
    },
    const {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'batch_size', '3': 3, '4': 1, '5': 5, '10': 'batchSize'},
    const {'1': 'batch_index', '3': 4, '4': 1, '5': 5, '10': 'batchIndex'},
    const {'1': 'batch_id', '3': 5, '4': 1, '5': 5, '10': 'batchId'},
  ],
  '3': const [GoogleAuthenticatorImport_OtpParameters$json],
  '4': const [
    GoogleAuthenticatorImport_Algorithm$json,
    GoogleAuthenticatorImport_DigitCount$json,
    GoogleAuthenticatorImport_OtpType$json
  ],
};

@$core.Deprecated('Use googleAuthenticatorImportDescriptor instead')
const GoogleAuthenticatorImport_OtpParameters$json = const {
  '1': 'OtpParameters',
  '2': const [
    const {'1': 'secret', '3': 1, '4': 1, '5': 12, '10': 'secret'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'issuer', '3': 3, '4': 1, '5': 9, '10': 'issuer'},
    const {
      '1': 'algorithm',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.KeePassOTP.GoogleAuthenticatorImport.Algorithm',
      '10': 'algorithm'
    },
    const {
      '1': 'digits',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.KeePassOTP.GoogleAuthenticatorImport.DigitCount',
      '10': 'digits'
    },
    const {
      '1': 'type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.KeePassOTP.GoogleAuthenticatorImport.OtpType',
      '10': 'type'
    },
    const {'1': 'counter', '3': 7, '4': 1, '5': 3, '10': 'counter'},
  ],
};

@$core.Deprecated('Use googleAuthenticatorImportDescriptor instead')
const GoogleAuthenticatorImport_Algorithm$json = const {
  '1': 'Algorithm',
  '2': const [
    const {'1': 'ALGORITHM_UNSPECIFIED', '2': 0},
    const {'1': 'ALGORITHM_SHA1', '2': 1},
    const {'1': 'ALGORITHM_SHA256', '2': 2},
    const {'1': 'ALGORITHM_SHA512', '2': 3},
    const {'1': 'ALGORITHM_MD5', '2': 4},
  ],
};

@$core.Deprecated('Use googleAuthenticatorImportDescriptor instead')
const GoogleAuthenticatorImport_DigitCount$json = const {
  '1': 'DigitCount',
  '2': const [
    const {'1': 'DIGIT_COUNT_UNSPECIFIED', '2': 0},
    const {'1': 'DIGIT_COUNT_SIX', '2': 1},
    const {'1': 'DIGIT_COUNT_EIGHT', '2': 2},
  ],
};

@$core.Deprecated('Use googleAuthenticatorImportDescriptor instead')
const GoogleAuthenticatorImport_OtpType$json = const {
  '1': 'OtpType',
  '2': const [
    const {'1': 'OTP_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'OTP_TYPE_HOTP', '2': 1},
    const {'1': 'OTP_TYPE_TOTP', '2': 2},
  ],
};

/// Descriptor for `GoogleAuthenticatorImport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List googleAuthenticatorImportDescriptor =
    $convert.base64Decode(
        'ChlHb29nbGVBdXRoZW50aWNhdG9ySW1wb3J0EloKDm90cF9wYXJhbWV0ZXJzGAEgAygLMjMuS2VlUGFzc09UUC5Hb29nbGVBdXRoZW50aWNhdG9ySW1wb3J0Lk90cFBhcmFtZXRlcnNSDW90cFBhcmFtZXRlcnMSGAoHdmVyc2lvbhgCIAEoBVIHdmVyc2lvbhIdCgpiYXRjaF9zaXplGAMgASgFUgliYXRjaFNpemUSHwoLYmF0Y2hfaW5kZXgYBCABKAVSCmJhdGNoSW5kZXgSGQoIYmF0Y2hfaWQYBSABKAVSB2JhdGNoSWQayQIKDU90cFBhcmFtZXRlcnMSFgoGc2VjcmV0GAEgASgMUgZzZWNyZXQSEgoEbmFtZRgCIAEoCVIEbmFtZRIWCgZpc3N1ZXIYAyABKAlSBmlzc3VlchJNCglhbGdvcml0aG0YBCABKA4yLy5LZWVQYXNzT1RQLkdvb2dsZUF1dGhlbnRpY2F0b3JJbXBvcnQuQWxnb3JpdGhtUglhbGdvcml0aG0SSAoGZGlnaXRzGAUgASgOMjAuS2VlUGFzc09UUC5Hb29nbGVBdXRoZW50aWNhdG9ySW1wb3J0LkRpZ2l0Q291bnRSBmRpZ2l0cxJBCgR0eXBlGAYgASgOMi0uS2VlUGFzc09UUC5Hb29nbGVBdXRoZW50aWNhdG9ySW1wb3J0Lk90cFR5cGVSBHR5cGUSGAoHY291bnRlchgHIAEoA1IHY291bnRlciJ5CglBbGdvcml0aG0SGQoVQUxHT1JJVEhNX1VOU1BFQ0lGSUVEEAASEgoOQUxHT1JJVEhNX1NIQTEQARIUChBBTEdPUklUSE1fU0hBMjU2EAISFAoQQUxHT1JJVEhNX1NIQTUxMhADEhEKDUFMR09SSVRITV9NRDUQBCJVCgpEaWdpdENvdW50EhsKF0RJR0lUX0NPVU5UX1VOU1BFQ0lGSUVEEAASEwoPRElHSVRfQ09VTlRfU0lYEAESFQoRRElHSVRfQ09VTlRfRUlHSFQQAiJJCgdPdHBUeXBlEhgKFE9UUF9UWVBFX1VOU1BFQ0lGSUVEEAASEQoNT1RQX1RZUEVfSE9UUBABEhEKDU9UUF9UWVBFX1RPVFAQAg==');
