import 'dart:io';

import 'package:args/args.dart';

import 'i18n_getstrings.dart';
import 'io/export.dart';

void main(List<String> arguments) async {
  const outputFile = "output-file";
  const sourceDir = "source-dir";

  var parser = ArgParser()
    ..addOption(outputFile,
        abbr: "f",
        defaultsTo: "strings.pot",
        valueHelp: "Supported formats: ${exporters.keys.join(", ")}")
    ..addOption(sourceDir, abbr: "s", defaultsTo: "./lib");

  ArgResults results = parser.parse(arguments);

  String outputFilename = results[outputFile];
  var fileFormat = outputFilename.split(".").last;
  if (!exporters.containsKey(fileFormat)) {
    print("Unable to write to $outputFilename.");
    print("Supported formats: ${exporters.keys.join(", ")}");
    exit(1);
  }

  String? sourceDir = results[sourceDir];
  List<ExtractedString> strings = GetI18nStrings(sourceDir).run();

  var outputFile = File(outputFilename);
  await outputFile.create();
  exporters[fileFormat]!(strings).exportTo(outputFile);

  print("Wrote ${strings.length} strings to template $outputFilename");
}
