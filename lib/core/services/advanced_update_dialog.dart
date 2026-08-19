import 'package:flutter/material.dart';
import 'update_localization.dart';

class AdvancedUpdateDialog extends StatefulWidget {
  final String version;
  final String whatsNew;
  final String fileSize;
  final String downloadUrl;
  final String languageCode;
  final Function onUpdate;
  final Function onLater;

  const AdvancedUpdateDialog({
    super.key,
    required this.version,
    required this.whatsNew,
    required this.fileSize,
    required this.downloadUrl,
    required this.languageCode,
    required this.onUpdate,
    required this.onLater,
  });

  @override
  State<AdvancedUpdateDialog> createState() => _AdvancedUpdateDialogState();
}

class _AdvancedUpdateDialogState extends State<AdvancedUpdateDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;

  String _t(String key) {
    return UpdateLocalization.get(key, widget.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:!_isDownloading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.system_update, color: Colors.blue, size: 28),
            const SizedBox(width: 10),
            Text(_t('updateAvailable'), style: const TextStyle(fontSize: 20)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_t('newVersionAvailable'), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.new_releases, _t('version'), widget.version),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.storage, _t('fileSize'), widget.fileSize),
            const SizedBox(height: 16),
            Text(_t('whatsNew'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.whatsNew, style: const TextStyle(fontSize: 14)),
            ),
            if (_isDownloading)...[
              const SizedBox(height: 20),
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 8),
              Text('${_t('downloading')} ${(_progress * 100).toStringAsFixed(0)}%'),
            ],
          ],
        ),
        actions: _isDownloading
           ? []
            : [
                TextButton(
                  onPressed: () => widget.onLater(),
                  child: Text(_t('later')),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isDownloading = true);
                    widget.onUpdate((progress) {
                      setState(() => _progress = progress);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_t('update')),
                ),
              ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value),
      ],
    );
  }
}
