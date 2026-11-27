# Wanderly — AI Integration Report

**Deliverable 3 — Tool transparency, prompt engineering and code validation**

| Field | Value |
|---|---|
| AI tool | OpenCode AI coding assistant |
| Model | `hy4-flash-free` |
| Project | Wanderly — Flutter travel bucket list |
| Date | 27 November 2026 |
| Scope | Data layer, UI layer, theme and verification support |

This report documents three concrete uses of AI assistance during construction.
For each, the submitted prompt, the generated output, and the team's refinement
and validation work are recorded. All AI output was treated as a **draft**, never
as trusted production code: every snippet was read, compiled, tested and changed.

---

## Instance 1 — Domain model and repository

### Prompt submitted

> Create a Flutter/Dart domain model `Destination` with fields: id, name, country,
> an enum `Category` (beach, city, mountain, culture), description, imagePath,
> latitude, longitude, optional websiteUrl, rating, isFavourite, isVisited.
> Make it immutable with `copyWith`, add `toJson`/`fromJson` and value equality.
> Then create a `DestinationRepository` that holds a `ValueNotifier<List<Destination>>`
> with deterministic seed data and methods `add`, `remove`, `update`,
> `toggleFavourite`, `setVisited`, `search`. Use constructor injection — no globals.

### AI-generated output (initial draft, abridged)

```dart
import 'package:flutter/foundation.dart';
import '../models/category.dart';

enum Category { beach, city, mountain, culture }

class Destination {
  final String id;
  final String name;
  final Category category;
  final String? websiteUrl;
  final bool isFavourite;

  const Destination({required this.id, required this.name,
      required this.category, this.websiteUrl, this.isFavourite = false});

  Destination copyWith({String? name, bool? isFavourite}) => Destination(
        id: id,
        name: name ?? this.name,
        category: category,
        websiteUrl: websiteUrl,
        isFavourite: isFavourite ?? this.isFavourite,
      );
}

class DestinationRepository {
  final ValueNotifier<List<Destination>> _items = ValueNotifier([]);
  void add(Destination d) => _items.value = [..._items.value, d];
  void remove(String id) =>
      _items.value = _items.value.where((d) => d.id != id).toList();
}
```

### Team refinement and validation

| Issue found | Fix applied |
|---|---|
| `import 'package:flutter/foundation.dart'` collides with our `Category` enum — 18 `ambiguous_import` analyzer errors | Narrowed to `import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;` |
| Draft `copyWith` dropped most fields, silently resetting data | Rewrote to preserve all 12 fields; added `clearWebsiteUrl` flag so a nullable URL can be explicitly removed |
| `fromJson` trusted malformed input | Added defensive parsing with fallbacks (`CategoryX.fromName`, `?? ''`, `?? 0`) |
| Draft exposed a mutable list | `all` now returns `List.unmodifiable(...)` |
| No deterministic reset for tests | Added `reset()` and constructor-injected seed data |

**Validation.** Wrote `test/models/destination_test.dart` and
`test/repositories/destination_repository_test.dart` (10 unit tests) covering
`copyWith` immutability, JSON round-trip, unknown category fallback, add/remove/
update, favourite toggling and case-insensitive search. `flutter analyze` reported
no issues after the import fix; `flutter test` passed 10/10.

---

## Instance 2 — Explore screen and gesture-enabled card

### Prompt submitted

> Build a Flutter `StatefulWidget` `ExploreScreen` with an `AppBar`, a search
> `TextField` that filters as the user types, a `ValueListenableBuilder` over the
> repository, and a `LayoutBuilder` + `GridView.builder` of destination cards.
> The card should use `GestureDetector` with tap, double-tap and long-press,
> a `Stack` with `Image.asset`, a gradient overlay, an `InkWell` heart, a
> category chip and star rating. Add a FAB that pushes `AddDestinationScreen`
> and awaits a returned `Destination`. Add a bookmark button to open Saved.

### AI-generated output (initial draft, abridged)

```dart
Future<void> _openDetail(Destination destination) async {
  final edited = await Navigator.push<Destination>(
    context,
    MaterialPageRoute<void>(
      builder: (_) => DestinationDetailScreen(destination: destination),
    ),
  );
  if (edited != null) widget.repository.update(edited);
}

// card footer
Row(
  children: [
    CategoryChip(category: destination.category),
    const Spacer(),
    RatingStars(rating: destination.rating),
  ],
)
```

### Team refinement and validation

| Issue found | Fix applied |
|---|---|
| `MaterialPageRoute<void>` cannot be assigned to `Route<Destination>` (`argument_type_not_assignable`, 2 errors) | Changed to `MaterialPageRoute<Destination>` in both push sites |
| Missing `mounted` checks after `await` | Added `if (!mounted || edited == null) return;` before repository mutation |
| Widget tests showed the card footer overflowing by **80–115 px** at narrow widths (`RenderFlex overflowed`) | Replaced the `Row` with `Wrap(spacing: 8, runSpacing: 6)` so content flows to a second line |
| Five full-size stars + numeric rating still too wide | Added `iconSize` to `RatingStars` and used `showValue: false, iconSize: 14` on cards; detail keeps the full version |
| No accessibility metadata | Added `Semantics` labels on cards, chips, stars and the favourite button; tooltips on icon buttons |
| Single tap was delayed because `onDoubleTap` holds the gesture arena | Verified with widget tests requiring two `pumpAndSettle()` calls; documented in the test with a comment |

**Validation.** Added `test/widget_test.dart` with three widget tests: catalogue
rendering, live search filtering, and tap-through-navigation to Detail. Full suite:
**13/13 tests passed**, `flutter analyze` → **No issues found**. Visual confirmation
came from the captured Explore and Detail screenshots.

---

## Instance 3 — Theme and platform actions on Detail

### Prompt submitted

> Create a Material 3 `AppTheme` with an ocean-teal seed colour and warm-coral
> accent, light and dark variants, 16 dp card radius and 48 dp minimum button
> size. Then create a stateless `DestinationDetailScreen` with a `Stack` hero
> image, gradient overlay, back and favourite buttons, description, and buttons
> that open Google Maps and the website via `url_launcher` and share via
> `share_plus`.

### AI-generated output (initial draft, abridged)

```dart
Future<void> _launch(Uri uri) async {
  final messenger = ScaffoldMessenger.maybeOf(navigatorKey.currentContext!);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Text(destination.description, style: textTheme.bodyLarge?.height(1.5));
```

### Team refinement and validation

| Issue found | Fix applied |
|---|---|
| `navigatorKey` does not exist in this project | Passed `BuildContext` into `_launch` and used `ScaffoldMessenger.of(context)` |
| Unhandled launch failure would silently do nothing | Wrapped in try/catch, checked the `bool` returned by `launchUrl`, and showed a SnackBar on failure |
| `context` used after `await` without a mount check | Added `if (!context.mounted) return;` |
| `TextStyle.height` is a property, not a method | Replaced `.height(1.5)` with `.copyWith(height: 1.5)` |
| `withOpacity` deprecated in Flutter 3.50 | Replaced with `withValues(alpha: 0.6)` |
| Flutter 3.50 marks `flutter/material.dart` deprecated in favour of an unbundled `material_ui` package | Kept the course-required Material API and documented the single `deprecated_member_use` ignore in `analysis_options.yaml` |

**Validation.** `flutter analyze` clean; Detail screen screenshot confirms hero
stack, category/rating row, coordinates and all three action buttons render
correctly. The website button is conditional on `websiteUrl != null`, so no link
is fabricated for destinations without one.

---

## Critical evaluation

**What the AI assistant did well.** It produced structurally sensible widget trees,
correct use of `ValueNotifier`, and plausible widget/API names. It accelerated the
first draft of all four screens and the reusable widgets substantially.

**Where it was wrong.** Every draft required changes: one ambiguous import caused
18 analyzer errors; two route generics were invalid; a deprecated gesture/route
pattern was used; a non-existent `navigatorKey` was invented; a `TextStyle` API was
misused; and the card layout overflowed in a real test. This demonstrates why AI
output cannot be accepted without compilation and automated verification.

**Verification evidence (final run).**

```text
$ flutter analyze
Analyzing Wanderly...
No issues found! (ran in 14.5s)

$ flutter test
00:13 +13: All tests passed!
```

**Transparency and limitations.** The assistant did not invent metrics or data:
all seed destinations use hand-written descriptions and real coordinates, image
sources are recorded in `assets/images/SOURCES.md`, and missing URLs remain `null`.
The AI was used for code drafting and debugging guidance only; design decisions,
the specification, screenshots and this evaluation were written and checked by the
team. No generated output was committed without being read, built and tested.
