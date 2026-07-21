import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/sync_provider.dart';
import '../../core/services/sync/sync_service.dart';

class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);

    return syncStateAsync.when(
      data: (state) {
        if (state == SyncState.online) return const SizedBox.shrink();
        
        Color bgColor;
        String text;
        IconData icon;

        switch (state) {
          case SyncState.offline:
            bgColor = Colors.red.shade800;
            text = 'You are offline. Changes saved locally.';
            icon = Icons.cloud_off;
            break;
          case SyncState.syncing:
            bgColor = Colors.blue.shade800;
            text = 'Syncing changes...';
            icon = Icons.sync;
            break;
          case SyncState.error:
            bgColor = Colors.orange.shade800;
            text = 'Sync error. Will retry soon.';
            icon = Icons.error_outline;
            break;
          default:
            return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: bgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
