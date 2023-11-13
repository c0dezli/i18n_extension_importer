import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension_importer/i18n_extension_importer.dart';

void main() {
  test("Import JSON translation", () async {
    var jsonSource = File("test/fixtures/de_DE.json").readAsStringSync();
    await JSONImporter().fromString("de", jsonSource);
  });

  test("Import PO translation", () async {
    var poSource = File("test/fixtures/strings-de.po").readAsStringSync();
    await GettextImporter().fromString("de", poSource);
  });
}
