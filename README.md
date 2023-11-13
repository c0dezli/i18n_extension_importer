# i18n_extension_importer

This is the standalone repo for importer library created by <a href="https://github.com/bauerj">Johann Bauer</a> for <a href="https://github.com/bauerj">[i18n_extension](https://pub.dev/packages/i18n_extension)

#### Importing

Currently, only `.PO` and `.JSON` importers are supported out-of-the-box.

**Note:** Those importers were contributed by <a href="https://github.com/bauerj">Johann Bauer</a>.
If you want to help creating importers for any of the other formats above, please PR
here: https://github.com/marcglasberg/i18n_extension.

Add your translation files as assets to your app in a directory structure like this:

```
app
 \_ assets
    \_ locales
       \_ de.po
       \_ fr.po
        ...
```

Then you can import them using `GettextImporter` or `JSONImporter`:

```
import 'package:i18n_extension/io/import.dart';
import 'package:i18n_extension/i18n_extension.dart';

class MyI18n {
  static TranslationsByLocale translations = Translations.byLocale("en");

  static Future<void> loadTranslations() async {
    translations +=
        await GettextImporter().fromAssetDirectory("assets/locales");
  }
}

extension Localization on String {
  String get i18n => localize(this, MyI18n.translations);
  String plural(value) => localizePlural(value, this, MyI18n.translations);
  String fill(List<Object> params) => localizeFill(this, params);
}
```

For usage in main.dart,
see <a href="https://github.com/marcglasberg/i18n_extension/issues/63#issuecomment-770056237">
here</a>.

**Note**: When using .po files, make sure not to include the country code, because the locales are
generated from the filenames which don't contain the country code and if you'd include the country
codes, you'll get errors like this: `There are no translations in 'en_us' for "Hello there"`.

**Note:** If you need to import any other custom format, remember importing is easy to do because
the Translation constructors use maps as input. If you can generate a map from your file format, you
can then use the `Translation()`
or `Translation.byLocale()` constructors to create the translation objects.

#### The GetStrings exporting utility

An utility script to automatically export all translatable strings from your project was contributed
by <a href="https://github.com/bauerj">Johann Bauer</a>. Simply
run `flutter pub run i18n_extension_importer:getstrings` in your project root directory and you will get a
list of strings to translate in `strings.json`. This file can then be sent to your translators or be
imported in translation services like _Crowdin_, _Transifex_ or _Lokalise_. You can use it as part
of your CI pipeline in order to always have your translation templates up to date.

Note the tool simply searches the source code for strings to which getters like `.i18n` are applied.
Since it is not very smart, you should not make it too hard:

```
print("Hello World!".i18n); // This would work.

// But the tool would not be able to spot this 
// since it doesn't execute the code.
var x = "Hello World";
print(x.i18n);
```
