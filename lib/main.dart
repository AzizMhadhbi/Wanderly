import 'package:flutter/material.dart';

import 'repositories/destination_repository.dart';
import 'screens/explore_screen.dart';
import 'theme/app_theme.dart';

/// The repository is created once, outside the widget tree, so every screen
/// receives the same source of truth through constructor injection.
final DestinationRepository repository = DestinationRepository();

void main() => runApp(const WanderlyApp());

class WanderlyApp extends StatelessWidget {
  const WanderlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanderly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: ExploreScreen(repository: repository),
    );
  }
}
