import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;
import '../../state/app_state.dart';
import '/l10n/app_localizations.dart';
import '../shared/list_item_base.dart' show TotpListItemBase;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'dart:async';

// Top-level cache variables (no 'static' keyword needed)
Map<String, dynamic>? _iconPackCache;
List<String>? _allSvgIconsCache;
Future<void>? _iconPackLoadFuture;


class IconSelectorDialog extends StatefulWidget {
  final List<String> allSvgIcons;
  final Map<String, dynamic>? iconPack;
  const IconSelectorDialog({required this.allSvgIcons, required this.iconPack, super.key});

  @override
  State<IconSelectorDialog> createState() => _IconSelectorDialogState();
}

class _IconSelectorDialogState extends State<IconSelectorDialog> {
  static const int batchSize = 50;
  String search = '';
  List<String> filteredIcons = [];
  int loadedCount = batchSize;
  Timer? _debounce;
  final Map<String, Widget> _svgCache = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    filteredIcons = widget.allSvgIcons;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (loadedCount < filteredIcons.length) {
        setState(() {
          loadedCount = (loadedCount + batchSize).clamp(0, filteredIcons.length);
        });
      }
    }
  }

  void _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        search = val;
        filteredIcons = widget.allSvgIcons.where((iconPath) {
          final filename = iconPath.split('/').last.toLowerCase();
          if (widget.iconPack != null && widget.iconPack!['icons'] is List) {
            final iconMeta = (widget.iconPack!['icons'] as List).firstWhere(
                  (icon) => icon is Map && icon['filename'] == filename,
              orElse: () => null,
            );
            final issuers = iconMeta is Map && iconMeta['issuer'] is List
                ? (iconMeta['issuer'] as List).join(' ').toLowerCase()
                : '';
            return filename.contains(val.toLowerCase()) || issuers.contains(val.toLowerCase());
          }
          return filename.contains(val.toLowerCase());
        }).toList();
        loadedCount = batchSize;
      });
    });
  }

  Widget _buildSvg(String iconPath) {
    if (_svgCache.containsKey(iconPath)) {
      return _svgCache[iconPath]!;
    }
    final assetPath = iconPath.replaceAll('\\', '/');
    final widgetSvg = SvgPicture.asset(
      assetPath,
      height: 32,
      width: 32,
      placeholderBuilder: (context) => Icon(Icons.shield_outlined, size: 32),
    );
    _svgCache[iconPath] = widgetSvg;
    return widgetSvg;
  }

  @override
  Widget build(BuildContext context) {
    // If filteredIcons is small, load all at once
    if (filteredIcons.length <= batchSize && loadedCount != filteredIcons.length) {
      loadedCount = filteredIcons.length;
    }
    final iconsToShow = filteredIcons.take(loadedCount).toList();
    return AlertDialog(
      title: Text('Choose Icon'),
      content: SizedBox(
        width: 400,
        height: 440,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by issuer or name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: iconsToShow.length,
                itemBuilder: (context, index) {
                  final iconPath = iconsToShow[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(iconPath);
                    },
                    child: _buildSvg(iconPath),
                  );
                },
              ),
            ),
            if (loadedCount < filteredIcons.length)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

/// Home page list item (Android).
class HomeListItem extends TotpListItemBase {
  const HomeListItem(super.item, {required Key super.key});

  @override
  State<StatefulWidget> createState() => _TOTPListItemState();
}

class _TOTPListItemState extends State<HomeListItem>
    with SingleTickerProviderStateMixin {
  // Dimension of progress indicator
  static const double _progressIndicatorDimension = 25;

  // Animation for indicator/code
  late AnimationController _controller;
  late Animation<double> _animation;

  // Code that is being displayed
  String _code = "";

  // Path to the selected icon (SVG asset)
  String? _iconPath;
  Map<String, dynamic>? _iconPack;
  List<String> _allSvgIcons = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final showIcons = Provider.of<AppState>(context, listen: false).showIcons;
    if (showIcons) {
      _loadIconPackAndIcons();
    }
    setState(() {
      _code = widget.code;
    });

    // Define animation
    // Adapted from progress_indicator_demo.dart from flutter examples
    _controller = AnimationController(
      duration: Duration(seconds: widget.item.totp.period),
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    _controller.forward(from: widget.indicatorValue);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener(
        (AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            // Set code
            setState(() {
              _code = widget.code;
            });
            // Reset animation
            _controller.forward(from: widget.indicatorValue);
          }
        },
      );
  }

  @override
  void didUpdateWidget(covariant HomeListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final showIcons = Provider.of<AppState>(context, listen: false).showIcons;
    if (showIcons && _allSvgIcons.isEmpty) {
      print('didUpdateWidget: showIcons is true and _allSvgIcons is empty, loading icons...');
      _loadIconPackAndIcons();
    }
  }

  Future<void> _loadIconPackAndIcons() async {
    final showIcons = Provider.of<AppState>(context, listen: false).showIcons;
    print('_loadIconPackAndIcons called. showIcons: $showIcons');
    if (!showIcons) return;

    bool usedCache = false;
    if (_iconPackCache != null && _allSvgIconsCache != null) {
      setState(() {
        _iconPack = _iconPackCache;
        _allSvgIcons = _allSvgIconsCache!;
      });
      print('Using cached icon pack and icon list.');
      usedCache = true;
    } else {
      // Only one load at a time
      _iconPackLoadFuture ??= () async {
        try {
          final packJsonStr = await rootBundle.loadString('graphics/aegis-icons-outline/pack.json');
          final packJson = jsonDecode(packJsonStr);
          _iconPackCache = packJson;
          if (packJson['icons'] is List) {
            final icons = (packJson['icons'] as List)
                .map((icon) => icon['filename'] as String?)
                .where((filename) => filename != null)
                .map((filename) => 'graphics/aegis-icons-outline/$filename')
                .toList();
            _allSvgIconsCache = icons;
            print('Loaded ${icons.length} icons. First: ${icons.take(5).toList()}');
          }
        } catch (e) {
          print('Failed to load icon pack: $e');
        }
      }();
      await _iconPackLoadFuture;
      setState(() {
        _iconPack = _iconPackCache;
        _allSvgIcons = _allSvgIconsCache ?? [];
      });
      print('Icon pack and icons set in state. _allSvgIcons.length: ${_allSvgIcons.length}');
    }

    // After setting _iconPack and _allSvgIcons, always do icon assignment:
    if (widget.item.iconPath == null && _iconPath == null && _iconPack != null) {
      final autoIcon = _findIconForItem(_iconPack!);
      if (autoIcon != null) {
        setState(() {
          _iconPath = autoIcon;
        });
        // Persist the auto-assigned iconPath
        final appState = Provider.of<AppState>(context, listen: false);
        final items = appState.items;
        if (items != null) {
          final idx = items.indexWhere((i) => i.id == widget.item.id);
          if (idx != -1) {
            items[idx].iconPath = autoIcon;
            await appState.replaceItems(List.from(items));
          }
        }
        print('Auto-matched iconPath set: $_iconPath');
      }
    } else if (widget.item.iconPath != null && _iconPath == null) {
      setState(() {
        _iconPath = widget.item.iconPath;
      });
      print('Loaded iconPath from item: $_iconPath');
    }
  }

  // Helper to normalize issuer/account/icon names for matching
  String _normalizeIssuer(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp(r'\\.com|\\.net|\\.org|\\.io|\\.co'), '')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  // Find icon path based on issuer/accountName with improved normalization and matching
  String? _findIconForItem(Map<String, dynamic> packJson) {
    final issuerRaw = widget.item.totp.issuer.trim();
    final accountRaw = widget.item.totp.accountName.trim();
    final issuerNorm = _normalizeIssuer(issuerRaw);
    final accountNorm = _normalizeIssuer(accountRaw);
    // print('Issuer: "$issuerRaw" (normalized: "$issuerNorm")');
    // print('Account: "$accountRaw" (normalized: "$accountNorm")');
    if (packJson['icons'] is List) {
      // 1. Try exact normalized match
      for (final icon in packJson['icons']) {
        if (icon is Map && icon['issuer'] is List) {
          for (final i in icon['issuer']) {
            if (i is String) {
              final iconIssuerNorm = _normalizeIssuer(i);
              if (issuerNorm == iconIssuerNorm || accountNorm == iconIssuerNorm) {
                // print('Exact match: $iconIssuerNorm for icon ${icon['filename']}');
                return p.join('graphics', 'aegis-icons-outline', icon['filename']);
              }
            }
          }
        }
      }
      // 2. Try substring match
      for (final icon in packJson['icons']) {
        if (icon is Map && icon['issuer'] is List) {
          for (final i in icon['issuer']) {
            if (i is String) {
              final iconIssuerNorm = _normalizeIssuer(i);
              if (issuerNorm.contains(iconIssuerNorm) || iconIssuerNorm.contains(issuerNorm) ||
                  accountNorm.contains(iconIssuerNorm) || iconIssuerNorm.contains(accountNorm)) {
                // print('Substring match: $iconIssuerNorm for icon ${icon['filename']}');
                return p.join('graphics', 'aegis-icons-outline', icon['filename']);
              }
            }
          }
        }
      }
      // 3. Fallback: first letter icon if available
      if (issuerNorm.isNotEmpty) {
        final firstLetter = issuerNorm[0];
        for (final icon in packJson['icons']) {
          if (icon is Map && icon['issuer'] is List) {
            for (final i in icon['issuer']) {
              if (i is String && _normalizeIssuer(i) == firstLetter) {
                // print('First letter fallback: $firstLetter for icon ${icon['filename']}');
                return p.join('graphics', 'aegis-icons-outline', icon['filename']);
              }
            }
          }
        }
      }
    }
    print('No icon match found, using default.');
    return null;
  }

  // Helper to ensure asset path is correct
  String _iconPathFromAsset(String path) {
    return path.replaceAll('\\', '/');
  }



  void _onIconLongPress() async {
    if (_allSvgIcons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No icons found.')),
      );
      return;
    }
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => IconSelectorDialog(allSvgIcons: _allSvgIcons, iconPack: _iconPack),
    );
    if (selected != null) {
      setState(() {
        _iconPath = selected;
      });
      // Save to storage (update AppState/repository as needed)
      final appState = Provider.of<AppState>(context, listen: false);
      final items = appState.items;
      if (items != null) {
        final idx = items.indexWhere((i) => i.id == widget.item.id);
        if (idx != -1) {
          items[idx].iconPath = selected;
          await appState.replaceItems(List.from(items));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showIcons = Provider.of<AppState>(context, listen: false).showIcons;
    // Use Consumer to get forceMonochromeIcons
    print('BUILD: _iconPath=$_iconPath, _allSvgIcons.length=${_allSvgIcons.length}, _iconPack loaded=${_iconPack != null}');
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final forceMono = appState.forceMonochromeIcons;
        return Hero(
          tag: widget.item.id,
          child: Card(
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.codeUnformatted));
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.clipboard),
                    duration: const Duration(seconds: 1)));
              },
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Row for icon and issuer
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (showIcons)
                                GestureDetector(
                                  onLongPress: _onIconLongPress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: _iconPath != null
                                        ? Builder(
                                            builder: (context) {
                                              final assetPath = _iconPathFromAsset(_iconPath!);
                                              // print('Trying to load asset: ' + assetPath);
                                              return SvgPicture.asset(
                                                assetPath,
                                                height: 32,
                                                width: 32,
                                                color: forceMono ? Theme.of(context).colorScheme.onSurface : null,
                                                placeholderBuilder: (context) =>
                                                    Icon(Icons.shield_outlined, size: 32),
                                              );
                                            },
                                          )
                                        : Icon(Icons.shield_outlined, size: 32),
                                  ),
                                ),
                              if (showIcons) const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.item.totp.issuer,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          // Generated code
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(_code,
                                  style: Theme.of(context).textTheme.displaySmall)),
                          // Account name
                          Text(widget.item.totp.accountName,
                              style: Theme.of(context).textTheme.bodyMedium)
                        ],
                      ),
                      // Progress indicator at bottom right
                      Positioned(
                          right: 0,
                          bottom: 0,
                          height: _progressIndicatorDimension,
                          width: _progressIndicatorDimension,
                          child: AnimatedBuilder(
                              animation: _animation,
                              builder: (BuildContext context, Widget? child) =>
                                  CircularProgressIndicator(
                                    value: _animation.value,
                                    strokeWidth: 2.5,
                                  )))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
