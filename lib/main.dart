// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dartpad_shared/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_strategy/url_strategy.dart';
import 'package:vtable/vtable.dart';
import 'editor/editor.dart';
import 'execution/execution.dart';
import 'extensions.dart';
import 'keys.dart' as keys;
import 'model.dart';
import 'samples.g.dart';
import 'services/gpt_api_service.dart';
import 'theme.dart';
import 'utils.dart';
import 'versions.dart';
import 'widgets.dart';
import 'widgets/custom_dropdown_widget.dart';
import 'widgets/custom_pallete_selector.dart';
import 'widgets/custom_title_widget.dart';

const appName = 'FLUTTER GEN';

void main() async {
  setPathUrlStrategy();

  runApp(const DartPadApp());
}

class DartPadApp extends StatefulWidget {
  const DartPadApp({
    super.key,
  });

  @override
  State<DartPadApp> createState() => _DartPadAppState();
}

class _DartPadAppState extends State<DartPadApp> {
  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: _homePageBuilder,
      ),
    ],
  );

  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    router.routeInformationProvider.addListener(_setTheme);
    _setTheme();
  }

  @override
  void dispose() {
    router.routeInformationProvider.removeListener(_setTheme);

    super.dispose();
  }

  // Changes the `themeMode` from the system default to either light or dark.
  // Also changes the `theme` query parameter in the URL.
  void handleBrightnessChanged(BuildContext context, bool isLightMode) {
    if (isLightMode) {
      GoRouter.of(context).replaceQueryParam('theme', 'light');
    } else {
      GoRouter.of(context).replaceQueryParam('theme', 'dark');
    }
    _setTheme();
  }

  void _setTheme() {
    final params = router.routeInformationProvider.value.uri.queryParameters;
    final themeParam = params.containsKey('theme') ? params['theme'] : null;

    setState(() {
      switch (themeParam) {
        case 'dark':
          setState(() {
            themeMode = ThemeMode.dark;
          });
        case 'light':
          setState(() {
            themeMode = ThemeMode.light;
          });
        case _:
          setState(() {
            themeMode = ThemeMode.light;
          });
      }
    });
  }

  Widget _homePageBuilder(BuildContext context, GoRouterState state) {
    final idParam = state.uri.queryParameters['id'];
    final sampleParam = state.uri.queryParameters['sample'];
    final channelParam = state.uri.queryParameters['channel'];
    final embedMode = state.uri.queryParameters['embed'] == 'true';

    return DartPadMainPage(
      title: appName,
      initialChannel: channelParam,
      embedMode: embedMode,
      sampleId: sampleParam,
      gistId: idParam,
      handleBrightnessChanged: handleBrightnessChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appName,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: lightPrimaryColor).copyWith(
          surface: lightSurfaceColor,
        ),
        brightness: Brightness.light,
        dividerColor: lightSurfaceColor,
        dividerTheme: DividerThemeData(
          color: lightSurfaceColor,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: darkPrimaryColor,
        brightness: Brightness.dark,
        dividerColor: darkSurfaceColor,
        dividerTheme: DividerThemeData(
          color: darkSurfaceColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        scaffoldBackgroundColor: darkScaffoldColor,
      ),
    );
  }
}

class DartPadMainPage extends StatefulWidget {
  final String title;
  final String? initialChannel;
  final String? sampleId;
  final String? gistId;
  final bool embedMode;
  final void Function(BuildContext, bool) handleBrightnessChanged;

  DartPadMainPage({
    required this.title,
    required this.initialChannel,
    required this.embedMode,
    required this.handleBrightnessChanged,
    this.sampleId,
    this.gistId,
  }) : super(key: ValueKey('sample:$sampleId gist:$gistId'));

  @override
  State<DartPadMainPage> createState() => _DartPadMainPageState();
}

class _DartPadMainPageState extends State<DartPadMainPage> {
  late final SplitViewController mainSplitter;
  final GptApiService gptApiService = GptApiService();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AppModel appModel;
  late AppServices appServices;
  final List<String> previewModes = ['Web', 'iOS', 'Android'];
  String? selectedPreviewMode;

  @override
  void initState() {
    super.initState();

    mainSplitter = SplitViewController(weights: [0.5, 0.25, 0.25])
      ..addListener(() {
        appModel.splitDragStateManager.handleSplitChanged();
      });

    final channel = widget.initialChannel != null
        ? Channel.forName(widget.initialChannel!)
        : null;

    appModel = AppModel();
    appServices = AppServices(
      appModel,
      channel ?? Channel.defaultChannel,
    );

    appServices.populateVersions();

    appServices.performInitialLoad(
      sampleId: widget.sampleId,
      gistId: widget.gistId,
      fallbackSnippet: Samples.getDefault(type: 'dart'),
    );
  }

  @override
  void dispose() {
    appServices.dispose();
    appModel.dispose();

    super.dispose();
  }

  Future<void> _handleGptRequest(String prompt) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showLoadingDialog(context, 'Generando código');
    final response = await gptApiService.getGptResponse(prompt);
    Navigator.of(context).pop();
    if (response != null) {
      final message = response.choices[0].message.content;
      final formattedMessage = formatIaResponse(message);
      if (formattedMessage.isEmpty) {
        showErrorDialog(context, 'Hubo un problema al generar código');
        return;
      }
      appModel.sourceCodeController.text = formattedMessage;
      showSuccessDialog(context, 'Código generado');
    } else {
      showErrorDialog(context, 'Hubo un problema al generar código');
    }
  }

  Future<void> _onSelectedColorPalette(ColorPalette palette) async {
    // validate if has code to format
    if (appModel.sourceCodeController.text.isEmpty) {
      showErrorDialog(
          context, 'No hay código para aplicar la paleta de colores');
      return;
    }
    appModel.sourceCodeController.text = formatFlutterCodeWithPalette(
        appModel.sourceCodeController.text, palette);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffold = Scaffold(
      appBar: widget.embedMode
          ? null
          : AppBar(
              backgroundColor: theme.dividerColor,
              title: const SizedBox(
                height: toolbarItemHeight,
                child: Row(
                  children: [
                    Text(appName),
                    SizedBox(width: defaultSpacing * 4),
                    // NewSnippetWidget(appServices: appServices),
                    SizedBox(width: denseSpacing),
                    ListSamplesWidget(),
                    SizedBox(width: defaultSpacing),
                  ],
                ),
              ),
              actions: [
                const SizedBox(width: denseSpacing),
                _BrightnessButton(
                  handleBrightnessChange: widget.handleBrightnessChanged,
                ),
                // const OverflowMenu(),
              ],
            ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SplitView(
                viewMode: SplitViewMode.Horizontal,
                gripColor: theme.dividerTheme.color!,
                gripColorActive: theme.dividerTheme.color!,
                gripSize: defaultGripSize,
                controller: mainSplitter,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // add a text field to enter a prompt for the user
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(denseSpacing),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese un prompt';
                                    }
                                    return null;
                                  },
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: 'Prompt',
                                      contentPadding:
                                          EdgeInsets.all(defaultGripSize)),
                                ),
                              ),
                            ),
                            const SizedBox(width: defaultSpacing),
                            SizedBox(
                              height: 45,
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                onPressed: () {
                                  _handleGptRequest(_controller.text);
                                },
                                child: const Text('Generar',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: defaultSpacing),
                          ],
                        ),
                        Expanded(
                          child: SectionWidget(
                            child: Stack(
                              children: [
                                EditorWidget(
                                  appModel: appModel,
                                  appServices: appServices,
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(denseSpacing),
                                  child: StatusWidget(
                                    status: appModel.editorStatus,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Run action
                            ValueListenableBuilder<bool>(
                              valueListenable: appModel.compilingBusy,
                              builder: (_, bool value, __) {
                                return PointerInterceptor(
                                  child: RunButton(
                                    onPressed:
                                        value ? null : _performCompileAndRun,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const CustomTitleWidget(
                          title: 'Modo de previzualización'),
                      CustomDropdownButton(
                          models: previewModes,
                          onChanged: (value) {
                            setState(() {
                              selectedPreviewMode = value;
                            });
                          },
                          selectedModel: selectedPreviewMode),
                      const CustomTitleWidget(title: 'Paleta de colores'),
                      CustomPaletteSelector(
                          onPaletteChanged: _onSelectedColorPalette)
                    ],
                  ),
                  Stack(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: appModel.layoutMode,
                        builder: (context, LayoutMode mode, _) {
                          return LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            final domHeight =
                                mode.calcDomHeight(constraints.maxHeight);
                            final consoleHeight =
                                mode.calcConsoleHeight(constraints.maxHeight);

                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  height:
                                      MediaQuery.of(context).size.height - 100,
                                  child: ListenableBuilder(
                                      listenable: appModel.splitViewDragState,
                                      builder: (context, _) {
                                        return ExecutionWidget(
                                          appServices: appServices,
                                          // Ignore pointer events while the Splitter
                                          // is being dragged.
                                          ignorePointer: appModel
                                                  .splitViewDragState.value ==
                                              SplitDragState.active,
                                        );
                                      }),
                                )
                              ],
                            );
                          });
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: appModel.compilingBusy,
                        builder: (_, bool compiling, __) {
                          final color = theme.colorScheme.surface;

                          return AnimatedContainer(
                            color: compiling
                                ? color.withOpacity(0.8)
                                : color.withOpacity(0.0),
                            duration: animationDelay,
                            curve: animationCurve,
                            child: compiling
                                ? const GoldenRatioCenter(
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox(width: 1),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // if (widget.embedMode) const StatusLineWidget(),
        ],
      ),
    );

    return Provider<AppServices>.value(
      value: appServices,
      child: Provider<AppModel>.value(
        value: appModel,
        child: CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            keys.reloadKeyActivator: () {
              if (!appModel.compilingBusy.value) {
                _performCompileAndRun();
              }
            },
            keys.findKeyActivator: () {
              // TODO:
              unimplemented(context, 'find');
            },
            keys.findNextKeyActivator: () {
              // TODO:
              unimplemented(context, 'find next');
            },
            keys.codeCompletionKeyActivator: () {
              appServices.editorService?.showCompletions();
            },
            keys.quickFixKeyActivator: () {
              appServices.editorService?.showQuickFixes();
            },
          },
          child: Focus(
            autofocus: true,
            child: scaffold,
          ),
        ),
      ),
    );
  }

  Future<void> _handleFormatting() async {
    try {
      final value = appModel.sourceCodeController.text;
      final result = await appServices.format(SourceRequest(source: value));

      if (result.source == value) {
        appModel.editorStatus.showToast('No formatting changes');
      } else {
        appModel.editorStatus.showToast('Format successful');
        appModel.sourceCodeController.text = result.source;
      }
    } catch (error) {
      appModel.editorStatus.showToast('Error formatting code');
      appModel.appendLineToConsole('Formatting issue: $error');
      return;
    }
  }

  Future<void> _performCompileAndRun() async {
    final source = appModel.sourceCodeController.text;
    final progress =
        appModel.editorStatus.showMessage(initialText: 'Compiling…');

    try {
      final response =
          await appServices.compileDDC(CompileRequest(source: source));
      appModel.clearConsole();
      appServices.executeJavaScript(
        response.result,
        modulesBaseUrl: response.modulesBaseUrl,
        engineVersion: appModel.runtimeVersions.value?.engineVersion,
      );
    } catch (error) {
      appModel.clearConsole();

      appModel.editorStatus.showToast('Compilation failed');

      if (error is ApiRequestError) {
        appModel.appendLineToConsole(error.message);
        appModel.appendLineToConsole(error.body);
      } else {
        appModel.appendLineToConsole('$error');
      }
    } finally {
      progress.close();
    }
  }
}

class StatusLineWidget extends StatelessWidget {
  const StatusLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final textColor = colorScheme.onPrimaryContainer;

    final appModel = Provider.of<AppModel>(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.dividerColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: denseSpacing,
        horizontal: defaultSpacing,
      ),
      child: Row(
        children: [
          Tooltip(
            message: 'Keyboard shortcuts',
            waitDuration: tooltipDelay,
            child: IconButton(
              icon: const Icon(Icons.keyboard),
              iconSize: smallIconSize,
              splashRadius: defaultIconSize,
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              padding: const EdgeInsets.all(2),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return MediumDialog(
                      title: 'Keyboard shortcuts',
                      smaller: true,
                      child: KeyBindingsTable(bindings: keys.keyBindings),
                    );
                  },
                );
              },
              color: textColor,
            ),
          ),
          const SizedBox(width: defaultSpacing),
          TextButton(
            onPressed: () {
              const url = 'https://dart.dev/tools/dartpad/privacy';
              url_launcher.launchUrl(Uri.parse(url));
            },
            child: const Row(
              children: [
                Text('Privacy notice'),
                SizedBox(width: denseSpacing),
                Icon(Icons.launch, size: 16),
              ],
            ),
          ),
          const SizedBox(width: defaultSpacing),
          TextButton(
            onPressed: () {
              const url = 'https://github.com/dart-lang/dart-pad/issues';
              url_launcher.launchUrl(Uri.parse(url));
            },
            child: const Row(
              children: [
                Text('Feedback'),
                SizedBox(width: denseSpacing),
                Icon(Icons.launch, size: 16),
              ],
            ),
          ),
          const Expanded(child: SizedBox(width: defaultSpacing)),
          VersionInfoWidget(appModel.runtimeVersions),
          const SizedBox(width: defaultSpacing),
          const SizedBox(
            height: 26,
            child: SelectChannelWidget(),
          ),
        ],
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String? title;
  final Widget? actions;
  final Widget child;

  const SectionWidget({
    this.title,
    this.actions,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var c = child;

    if (title != null || actions != null) {
      c = Column(
        children: [
          Row(
            children: [
              if (title != null) Text(title!, style: subtleText),
              const Expanded(child: SizedBox(width: defaultSpacing)),
              if (actions != null) actions!,
            ],
          ),
          const Divider(),
          Expanded(child: child),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(denseSpacing),
      child: c,
    );
  }
}

class NewSnippetWidget extends StatelessWidget {
  final AppServices appServices;

  const NewSnippetWidget({
    required this.appServices,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: toolbarItemHeight,
      child: TextButton.icon(
        icon: const Icon(Icons.add_circle),
        label: const Text('New'),
        onPressed: () async {
          final selection =
              await _showMenu(context, calculatePopupMenuPosition(context));
          if (selection != null) {
            _handleSelection(appServices, selection);
          }
        },
      ),
    );
  }

  Future<bool?> _showMenu(BuildContext context, RelativeRect position) {
    return showMenu<bool>(
      context: context,
      position: position,
      items: <PopupMenuEntry<bool>>[
        PopupMenuItem(
          value: true,
          child: PointerInterceptor(
            child: ListTile(
              leading: dartLogo(),
              title: const Text('New Dart snippet'),
            ),
          ),
        ),
        PopupMenuItem(
          value: false,
          child: PointerInterceptor(
            child: ListTile(
              leading: flutterLogo(),
              title: const Text('New Flutter snippet'),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSelection(AppServices appServices, bool dartSample) {
    appServices.resetTo(type: dartSample ? 'dart' : 'flutter');
  }
}

class ListSamplesWidget extends StatelessWidget {
  const ListSamplesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: toolbarItemHeight,
      child: TextButton.icon(
        icon: const Icon(Icons.playlist_add_outlined),
        label: const Text('Ejemplos'),
        onPressed: () async {
          final selection =
              await _showMenu(context, calculatePopupMenuPosition(context));
          if (selection != null && context.mounted) {
            _handleSelection(context, selection);
          }
        },
      ),
    );
  }

  Future<String?> _showMenu(BuildContext context, RelativeRect position) {
    final categories = Samples.categories.keys;

    final menuItems = <PopupMenuEntry<String?>>[
      for (final category in categories) ...[
        const PopupMenuDivider(),
        PopupMenuItem(
          value: null,
          enabled: false,
          child: PointerInterceptor(
            child: ListTile(title: Text(category)),
          ),
        ),
        ...Samples.categories[category]!.map((sample) {
          return PopupMenuItem(
            value: sample.id,
            child: PointerInterceptor(
              child: ListTile(
                leading: sample.isDart ? dartLogo() : flutterLogo(),
                title: Text(sample.name),
              ),
            ),
          );
        }),
      ],
    ];

    return showMenu<String?>(
      context: context,
      position: position,
      items: menuItems.skip(1).toList(),
    );
  }

  void _handleSelection(BuildContext context, String sampleId) {
    GoRouter.of(context).replaceQueryParam('sample', sampleId);
  }
}

class SelectChannelWidget extends StatelessWidget {
  const SelectChannelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appServices = Provider.of<AppServices>(context);

    return ValueListenableBuilder<Channel>(
      valueListenable: appServices.channel,
      builder: (context, Channel value, _) {
        return SizedBox(
          height: toolbarItemHeight,
          child: TextButton.icon(
            icon: const Icon(Icons.tune, size: smallIconSize),
            label: Container(
              constraints: const BoxConstraints(minWidth: 95),
              child: Text('${value.displayName} channel'),
            ),
            onPressed: () async {
              final selection = await _showMenu(
                context,
                calculatePopupMenuPosition(context, growUpwards: true),
                value,
              );
              if (selection != null && context.mounted) {
                _handleSelection(context, selection);
              }
            },
          ),
        );
      },
    );
  }

  Future<Channel?> _showMenu(
      BuildContext context, RelativeRect position, Channel current) {
    const itemHeight = 46.0;

    final menuItems = <PopupMenuEntry<Channel>>[
      for (final channel in Channel.valuesWithoutLocalhost)
        PopupMenuItem<Channel>(
          value: channel,
          child: PointerInterceptor(
            child: ListTile(
              title: Text(channel.displayName),
            ),
          ),
        )
    ];

    return showMenu<Channel>(
      context: context,
      position: position.shift(Offset(0, -1 * menuItems.length * itemHeight)),
      items: menuItems,
    );
  }

  void _handleSelection(BuildContext context, Channel channel) async {
    final appServices = Provider.of<AppServices>(context, listen: false);

    // update the url
    GoRouter.of(context).replaceQueryParam('channel', channel.name);

    final version = await appServices.setChannel(channel);

    appServices.appModel.editorStatus.showToast(
      'Switched to Dart ${version.dartVersion} '
      'and Flutter ${version.flutterVersion}',
    );
  }
}

class OverflowMenu extends StatelessWidget {
  const OverflowMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      splashRadius: defaultSplashRadius,
      onPressed: () async {
        final selection =
            await _showMenu(context, calculatePopupMenuPosition(context));
        if (selection != null) {
          url_launcher.launchUrl(Uri.parse(selection));
        }
      },
    );
  }

  Future<String?> _showMenu(BuildContext context, RelativeRect position) {
    return showMenu<String?>(
      context: context,
      position: position,
      items: <PopupMenuEntry<String?>>[
        PopupMenuItem(
          value: 'https://dart.dev',
          child: PointerInterceptor(
            child: const ListTile(
              title: Text('dart.dev'),
              trailing: Icon(Icons.launch),
            ),
          ),
        ),
        PopupMenuItem(
          value: 'https://flutter.dev',
          child: PointerInterceptor(
            child: const ListTile(
              title: Text('flutter.dev'),
              trailing: Icon(Icons.launch),
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'https://github.com/dart-lang/dart-pad/wiki/Sharing-Guide',
          child: PointerInterceptor(
            child: const ListTile(
              title: Text('Sharing guide'),
              trailing: Icon(Icons.launch),
            ),
          ),
        ),
        PopupMenuItem(
          value: 'https://github.com/dart-lang/dart-pad',
          child: PointerInterceptor(
            child: const ListTile(
              title: Text('DartPad on GitHub'),
              trailing: Icon(Icons.launch),
            ),
          ),
        ),
      ],
    );
  }
}

class KeyBindingsTable extends StatelessWidget {
  final List<(String, ShortcutActivator)> bindings;

  const KeyBindingsTable({
    required this.bindings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        Expanded(
          child: VTable<(String, ShortcutActivator)>(
            showToolbar: false,
            showHeaders: false,
            startsSorted: true,
            items: bindings,
            columns: [
              VTableColumn(
                label: 'Command',
                width: 100,
                grow: 0.5,
                transformFunction: (binding) => binding.$1,
              ),
              VTableColumn(
                label: 'Keyboard shortcut',
                width: 100,
                grow: 0.5,
                alignment: Alignment.centerRight,
                transformFunction: (binding) =>
                    (binding.$2 as SingleActivator).describe,
                styleFunction: (binding) => subtleText,
                renderFunction: (context, binding, _) {
                  return (binding.$2 as SingleActivator)
                      .renderToWidget(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VersionInfoWidget extends StatefulWidget {
  final ValueListenable<VersionResponse?> versions;

  const VersionInfoWidget(
    this.versions, {
    super.key,
  });

  @override
  State<VersionInfoWidget> createState() => _VersionInfoWidgetState();
}

class _VersionInfoWidgetState extends State<VersionInfoWidget> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VersionResponse?>(
      valueListenable: widget.versions,
      builder: (content, versions, _) {
        if (versions == null) {
          return const SizedBox();
        }

        return TextButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) {
                return MediumDialog(
                  title: 'Runtime versions',
                  child: VersionTable(version: versions),
                );
              },
            );
          },
          child: Text(versions.label),
        );
      },
    );
  }
}

class _BrightnessButton extends StatelessWidget {
  const _BrightnessButton({
    required this.handleBrightnessChange,
  });

  final void Function(BuildContext, bool) handleBrightnessChange;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      preferBelow: true,
      message: 'Toggle brightness',
      child: IconButton(
        icon: Theme.of(context).brightness == Brightness.light
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
        onPressed: () {
          handleBrightnessChange(context, !isBright);
        },
      ),
    );
  }
}
