import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../repositories/destination_repository.dart';
import '../widgets/destination_card.dart';
import '../widgets/empty_state.dart';
import 'add_destination_screen.dart';
import 'destination_detail_screen.dart';
import 'saved_screen.dart';

/// Catalogue screen. Stateful because it owns the search query and coordinates
/// navigation results; the destination list itself lives in the repository.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.repository});

  final DestinationRepository repository;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  Future<void> _addDestination() async {
    final created = await Navigator.push<Destination>(
      context,
      MaterialPageRoute<Destination>(
        builder: (_) => const AddDestinationScreen(),
      ),
    );
    if (!mounted || created == null) return;
    widget.repository.add(created);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${created.name} added to your list')),
    );
  }

  Future<void> _confirmDelete(Destination destination) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove destination?'),
        content: Text('Remove ${destination.name} from your list?'),
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
    if (confirmed == true) widget.repository.remove(destination.id);
  }

  void _openSaved() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SavedScreen(repository: widget.repository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wanderly'),
        actions: [
          IconButton(
            tooltip: 'Saved destinations',
            icon: const Icon(Icons.bookmark_border),
            onPressed: _openSaved,
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Destination>>(
        valueListenable: widget.repository.listenable,
        builder: (context, _, __) {
          final results = widget.repository.search(_query);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search by place or country',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${results.length} destination${results.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? EmptyState(
                        title: 'No destinations found',
                        message: _query.isEmpty
                            ? 'Add your first place to start a bucket list.'
                            : 'Try a different name or country.',
                        actionLabel: _query.isEmpty ? 'Add a place' : null,
                        onAction: _query.isEmpty ? _addDestination : null,
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final columns =
                              (constraints.maxWidth / 190).floor().clamp(2, 4);
                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: results.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemBuilder: (context, index) {
                              final destination = results[index];
                              return DestinationCard(
                                destination: destination,
                                onTap: () => _openDetail(destination),
                                onDoubleTap: () => widget.repository
                                    .toggleFavourite(destination.id),
                                onLongPress: () =>
                                    _confirmDelete(destination),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDestination,
        tooltip: 'Add destination',
        child: const Icon(Icons.add),
      ),
    );
  }
}
