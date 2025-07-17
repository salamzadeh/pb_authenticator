import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import '../state/app_state.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  final _pinController = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _biometricAvailable = false;
  String? _biometricError;
  bool _biometricInProgress = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometric(auto: true);
    });
  }

  Future<void> _checkBiometricAvailable() async {
    final localAuth = LocalAuthentication();
    final canCheck = await localAuth.canCheckBiometrics;
    final supported = await localAuth.isDeviceSupported();
    final enrolled = (await localAuth.getAvailableBiometrics()).isNotEmpty;
    setState(() {
      _biometricAvailable = canCheck && supported && enrolled;
    });
  }

  Future<void> _tryBiometric({bool auto = false}) async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (!appState.biometricEnabled || !_biometricAvailable || _biometricInProgress) return;
    setState(() { _loading = true; _biometricError = null; _biometricInProgress = true; });
    final localAuth = LocalAuthentication();
    try {
      final didAuth = await localAuth.authenticate(
        localizedReason: 'Authenticate to unlock',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      if (didAuth) {
        appState.updateLastUnlockTime();
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.of(context).pop(true);
          });
        }
        return;
      } else {
        setState(() { _biometricError = 'Biometric authentication failed.'; });
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
      setState(() { _biometricError = 'Biometric authentication unavailable. ($e)'; });
    }
    setState(() { _loading = false; _biometricInProgress = false; });
  }

  Future<void> _checkPin() async {
    setState(() { _loading = true; _error = null; });
    final appState = Provider.of<AppState>(context, listen: false);
    final pin = await appState.getPin();
    if (_pinController.text == pin) {
      appState.updateLastUnlockTime();
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.of(context).pop(true);
        });
      }
    } else {
      setState(() { _error = 'Incorrect PIN'; _loading = false; });
      // After PIN failure, offer biometric again if enabled
      if (appState.biometricEnabled && _biometricAvailable) {
        _tryBiometric();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 64),
              const SizedBox(height: 16),
              Text('Unlock PB Authenticator', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              if (appState.pinEnabled)
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  enabled: !_loading,
                  decoration: InputDecoration(
                    labelText: 'Enter PIN',
                    errorText: _error,
                  ),
                  onSubmitted: (_) => _checkPin(),
                ),
              const SizedBox(height: 16),
              if (appState.pinEnabled)
                ElevatedButton(
                  onPressed: _loading ? null : _checkPin,
                  child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Unlock'),
                ),
              if (appState.biometricEnabled)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Use biometrics'),
                        onPressed: (_loading || !_biometricAvailable) ? null : () => _tryBiometric(),
                      ),
                      if (_biometricError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_biometricError!, style: const TextStyle(color: Colors.red)),
                        ),
                      if (!_biometricAvailable)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('No biometrics enrolled or not available.', style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
} 