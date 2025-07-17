import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons, ListTile, Material, ThemeMode, SimpleDialogOption, SimpleDialog, showDialog, SwitchListTile;
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../ui/adaptive.dart' show AppScaffold, isPlatformAndroid;
import '../helper/url.dart' show launchURL;
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import '../config/routes.dart';
import '../l10n/constants.dart';
import 'package:provider/provider.dart';

/// Settings page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.settingsTitle),
      body: Column(
        children: <Widget>[
          // App Info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // App image
                Container(
                  height: 125,
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('graphics/icon.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Name
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(AppLocalizations.of(context)!.appName,
                              style: const TextStyle(fontSize: 25))),
                      // Version of app
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context,
                            AsyncSnapshot<PackageInfo> snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.version,
                                style: const TextStyle(fontSize: 14));
                          }
                          return Text(AppLocalizations.of(context)!.loading);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 5),

          // List of options
          Expanded(
            child: Material(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Theme selection
                  Consumer<AppState>(
                    builder: (context, appState, _) {
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.brightness_6),
                        title: Text(AppLocalizations.of(context)!.themeMode ?? 'Theme', style: const TextStyle(fontSize: 15)),
                        subtitle: Text(
                          appState.themeMode == ThemeMode.system
                              ? (AppLocalizations.of(context)!.themeSystem ?? 'System')
                              : appState.themeMode == ThemeMode.light
                                  ? (AppLocalizations.of(context)!.themeLight ?? 'Light')
                                  : (AppLocalizations.of(context)!.themeDark ?? 'Dark'),
                        ),
                        onTap: () async {
                          final selected = await showDialog<ThemeMode>(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text(AppLocalizations.of(context)!.themeMode ?? 'Theme'),
                                children: [
                                  SimpleDialogOption(
                                    child: Text(AppLocalizations.of(context)!.themeSystem ?? 'System'),
                                    onPressed: () => Navigator.pop(context, ThemeMode.system),
                                  ),
                                  SimpleDialogOption(
                                    child: Text(AppLocalizations.of(context)!.themeLight ?? 'Light'),
                                    onPressed: () => Navigator.pop(context, ThemeMode.light),
                                  ),
                                  SimpleDialogOption(
                                    child: Text(AppLocalizations.of(context)!.themeDark ?? 'Dark'),
                                    onPressed: () => Navigator.pop(context, ThemeMode.dark),
                                  ),
                                ],
                              );
                            },
                          );
                          if (selected != null) {
                            appState.setThemeMode(selected);
                          }
                        },
                      );
                    },
                  ),
                  // Screen capture prevention
                  Consumer<AppState>(
                    builder: (context, appState, _) {
                      return SwitchListTile(
                        dense: true,
                        secondary: const Icon(Icons.security),
                        title: Text(AppLocalizations.of(context)!.preventScreenCapture ?? 'Prevent screen capture', style: const TextStyle(fontSize: 15)),
                        value: appState.screenCapturePrevented,
                        onChanged: (val) => appState.setScreenCapturePrevented(val),
                      );
                    },
                  ),
                  // Source
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.code),
                    title: Text(AppLocalizations.of(context)!.source,
                        style: const TextStyle(fontSize: 15)),
                    onTap: () {
                      launchURL(Constants.repoUrl);
                    },
                  ),
                  // Acknowledgements
                  ListTile(
                    dense: true,
                    leading: isPlatformAndroid()
                        ? const Icon(Icons.book)
                        : const Icon(CupertinoIcons.book),
                    title: Text(AppLocalizations.of(context)!.licenses,
                        style: const TextStyle(fontSize: 15)),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.settingAcknowledgements);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
