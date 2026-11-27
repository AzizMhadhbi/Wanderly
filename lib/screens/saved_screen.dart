import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../repositories/destination_repository.dart';
import '../widgets/empty_state.dart';
import 'destination_detail_screen.dart';

/// Favourites screen. Stateful so it can react to edits returned by the detail
/// screen; the underlying data is shared through the injected repository.
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key, required this.repository});

  final DestinationRepository repository;

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  Future<void> _openDetail(Destination destination) async {
    final edited = await Navigator.push<Destination>(
      context,
      MaterialPageRoute<Destination>(
        builder: (_) => DestinationDetailScreen(
          destination: destination,
          repository: widget.repository,
        ),
      ),
    );
    if (!mounted || edited == null) return;
    widget.repository.update(edited);
  }

  Future<bool?> _confirmRemove(Destination destination) => showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Remove from saved?'),
          content: Text('${destination.name} will be removed from your list.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Remove'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved places'),
        actions: [
          IconButton(
            tooltip: 'Back to explore',
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Destination>>(
        valueListenable: widget.repository.listenable,
        builder: (context, _, __) {
          final favourites = widget.repository.favourites;
          if (favourites.isEmpty) {
            return const EmptyState(
              icon: Icons.bookmark_border,
              title: 'Nothing saved yet',
              message: 'Double-tap a destination card to add it here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: favourites.length,
            itemBuilder: (context, index) {
              final destination = favourites[index];
              return Dismissible(
                key: ValueKey<String>(destination.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmRemove(destination),
                onDismissed: (_) {
                  widget.repository.remove(destination.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${destination.name} removed')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset(
                          destination.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Theme.of(context).colorScheme.primary,
                            child: const Icon(Icons.place, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      destination.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(destination.country),
                    trailing: Checkbox(
                      value: destination.isVisited,
                      onChanged: (value) => widget.repository.setVisited(
                        destination.id,
                        value ?? false,
                      ),
                    ),
                    onTap: () => _openDetail(destination),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
