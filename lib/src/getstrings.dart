import 'dart:io';

import 'package:args/args.dart';

import 'i18n_getstrings.dart';
import 'io/export.dart';

void main(List<String> arguments) async {
  const outputFileOption = "output-file";
  const sourceDirOption = "source-dir";

  var parser = ArgParser()
    ..addOption(outputFileOption,
        abbr: "f",
        defaultsTo: "strings.pot",
        valueHelp: "Supported formats: ${exporters.keys.join(", ")}")
    ..addOption(sourceDirOption, abbr: "s", defaultsTo: "./lib");

  ArgResults results = parser.parse(arguments);

  String outputFilename = results[outputFileOption];
  var fileFormat = outputFilename.split(".").last;
  if (!exporters.containsKey(fileFormat)) {
    print("Unable to write to $outputFilename.");
    print("Supported formats: ${exporters.keys.join(", ")}");
    exit(1);
  }

  String? sourceDir = results[sourceDirOption];
  List<ExtractedString> strings = GetI18nStrings(sourceDir).run();

  var outputFile = File(outputFilename);
  await outputFile.create();
  exporters[fileFormat]!(strings).exportTo(outputFile);

  print("Wrote ${strings.length} strings to template $outputFilename");
}