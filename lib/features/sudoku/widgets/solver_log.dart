import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum LogType { arc, removed, singleton, summary }

class LogEntry {
  final String message;
  final LogType type;

  const LogEntry({required this.message, required this.type});
}

class SolverLog extends StatefulWidget {
  final List<LogEntry> entries;

  const SolverLog({super.key, required this.entries});

  @override
  State<SolverLog> createState() => _SolverLogState();
}

class _SolverLogState extends State<SolverLog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(SolverLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto scroll to bottom when new entries arrive
    if (widget.entries.length != oldWidget.entries.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gridBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: AppColors.primary, size: 14),
                const Gap(6),
                Text(
                  'Solver Log',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.entries.length} entries',
                  style: AppTextStyles.body.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.gridBorder, height: 1),
          // Log entries
          Expanded(
            child: widget.entries.isEmpty
                ? Center(
                    child: Text(
                      'Tap Solve to start...',
                      style: AppTextStyles.body.copyWith(fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.entries.length,
                    itemBuilder: (context, index) {
                      return _LogLine(entry: widget.entries[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogLine extends StatelessWidget {
  final LogEntry entry;

  const _LogLine({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color indicator
          Container(
            width: 3,
            height: 14,
            margin: const EdgeInsets.only(right: 8, top: 1),
            decoration: BoxDecoration(
              color: _indicatorColor(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Text(
              entry.message,
              style: AppTextStyles.log.copyWith(color: _textColor()),
            ),
          ),
        ],
      ),
    );
  }

  Color _indicatorColor() {
    switch (entry.type) {
      case LogType.arc:
        return AppColors.primary;
      case LogType.removed:
        return AppColors.danger;
      case LogType.singleton:
        return AppColors.success;
      case LogType.summary:
        return AppColors.warning;
    }
  }

  Color _textColor() {
    switch (entry.type) {
      case LogType.arc:
        return AppColors.textSecondary;
      case LogType.removed:
        return AppColors.danger;
      case LogType.singleton:
        return AppColors.success;
      case LogType.summary:
        return AppColors.warning;
    }
  }
}
