import 'dart:io';

import '../../crc_graphics_id_converter/lib/crc_graphics_converter.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) displayError('Please specify the base ID.');
  if (arguments.length > 1) displayError('Too many arguments! Please specify the base ID only.');

  try {
    print(convertGraphicsBaseId(int.parse(arguments[0])));
  } on FormatException {
    displayError('Invalid base ID. are you sure that\'s a number?');
  }
}

void displayError(String errorMsg, [int errorCode = 1]) {
  print(errorMsg);
  exit(errorCode);
}
