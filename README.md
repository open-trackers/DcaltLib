# DcaltLib

Shared data and business logic layer for the _Daily Calorie Tracker_, presently available as iOS apps and independent watchOS apps.

For full details, including free download links from the App Store, visit:

* [_Open Trackers_](https://open-trackers.github.io) - product website for all the tracker apps
* [_Open Trackers_ Project](https://github.com/open-trackers) - Github site for the development project, including full source code

## Important Note

Do not add this package as a dependency to projects outside the _Open Trackers_ project!

The code in this package is not stable. It may change at any time, including removal, to support the apps and other packages in the _Open Trackers_ project.

You are nevertheless welcome to take what you need, provided you continue to meet the terms of the license (typically MPL-2.0). 

Better yet, spin the borrowed code off into its own stable package. Let us know, as we may wish to add it as a dependency.

## Implementation Details

### NOTES ON ADDING/EDITING PRESETS:

Corrections are welcome!

All presets are subject to change, including their removal.

### MEMBERSHIP QUALIFICATIONS

Presets should be based on foods that can be directly consumed, whether prepared, cooked, or raw.
They should NOT include foods that are typically ingredients to prepared recipes (enriched flour, e.g.).
Also excluded are foods of negligible caloric content (lettuce, celery sticks, e.g.).

Note that calorie counting users typically will be focused on preparations that minimize
caloric content, so favor the healthier preparations (baked vs fried, e.g.).

Avoid completionism and pedantry! Be practical and focus on the common situtations.
Users with idiosyncratic needs can do their own research to input their desired serving details.

### TITLE TEMPLATE FORMATTING

Template is currently: "Food Name [, Variation] [, qualifier] [([size,] preparation)]"

Please adhere to the existing formatting convention.

Variation: Should be included after a comma, to ensure sorting groups them together (see Ground Beef Patty).
Capitalize like a Movie Title.

qualifier: Format in ", lowercase". Note that "low fat", "reduced fat", "fat free", "nonfat", "skim", and
similar qualifiers are not necessarily synonymous. Ensure that the source is accurate and that you are using
the proper term. The lack of flavor (e.g., "plain" for yogurt or tortilla chips) may be needed as a qualifier.

size: Items available in various sizes (bagels, eggs, e.g.) are assumed to be the average (or typical) size,
unless otherwise noted. To reduced clutter, do not include "medium", "regular", or similar.

preparation: Include preparation notes in parentheses, in lower case.

### FUTURE OF TITLE

Voice support (Siri, e.g.) may be added at some point, and will likely make use of the naming conventions.

The title, now stored as a String, may be further broken up into components.

### LOCALIZATION

Use the US spelling conventions (e.g., "yogurt" vs "yoghurt"). Future localizations can support the alternate
spellings.

### SERVING SIZE

For volume (in mL) and weight (in g) target the typical serving size.

Note that serving size on nutrition labels on packages may not be realistic. (They may be trying to obfuscate
the high caloric content, e.g.)  Do some research, discuss with others, and use your best judgement!

Note that the 'ounce', used as a weight is equivalent to 28.35 grams. However in nutrition labels it can be
considered 30 grams! Try to use accurate metric sources where possible.

Variations of a food (Ground Beef Patty, e.g.) should typically share the same serving size, for comparison.

### APP NOTES

Preset group names may be different than the default MCategory.title(s) provided in settings and at
app bootstrapping. MCategory(ies) may include multiple preset groups.

## License

Copyright 2023 OpenAlloc LLC

All application code is licensed under the [Mozilla Public License 2](https://www.mozilla.org/en-US/MPL/2.0/), except where noted in individual modules.
