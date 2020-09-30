import 'dart:io';

import 'package:crc_graphics_id_converter/crc_graphics_id_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

const _title = 'Graphics ID converter';

const _padding = 32.0;
const _maxWidth = 256.0;

const _initialWidth = 400;
const _initialHeight = 500;

void main() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    WidgetsFlutterBinding.ensureInitialized();

    setWindowTitle(_title);
    setWindowMinSize(const Size(300, (2 * _padding) + _maxWidth));

    final windowFrame = (await getWindowInfo()).frame;
    final hCenter = windowFrame.left + (windowFrame.width / 2);
    final vCenter = windowFrame.top + (windowFrame.height / 2);

    setWindowFrame(
      Rect.fromLTRB(
        (hCenter - (_initialWidth / 2)).toDouble(),
        (vCenter - (_initialHeight / 2)).toDouble(),
        (hCenter + (_initialWidth / 2)).toDouble(),
        (vCenter + (_initialHeight / 2)).toDouble(),
      ),
    );
  }

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  int _validatedBaseId;
  String result;

  String _validate(String value) {
    try {
      _validatedBaseId = int.parse(value);
      return null;
    } on FormatException {
      return 'Given base ID is not a number.';
    }
  }

  void _calculateAndShow(_) {
    if (!_formKey.currentState.validate()) return;

    final hash = convertGraphicsBaseId(_validatedBaseId);
    setState(() {
      result = hash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _maxWidth,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    validator: _validate,
                    onFieldSubmitted: _calculateAndShow,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Base ID',
                    ),
                  ),
                  if (result != null) const SizedBox(height: 24),
                  if (result != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 32),
                        Text(
                          result,
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: result));
                          },
                        ),
                        // const SizedBox(width: 32),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
