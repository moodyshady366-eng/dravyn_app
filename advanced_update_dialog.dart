import 'package:flutter/material.dart';
import 'update_service.dart';
import 'update_localization.dart';

class UpdateTheme {
  final Color background;
  final Color primary;
  final Color text;
  final Color textSecondary;
  final Gradient? gradient;

  const UpdateTheme({
    required this.background,
    required this.primary,
    required this.text,
    required this.textSecondary,
    this.gradient,
  });

  static const dark = UpdateTheme(
    background: Color(0xFF1A1A2E),
    primary: Color(0xFFD4AF37),
    text: Colors.white,
    textSecondary: Colors.white70,
    gradient: LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
  );

  static const light = UpdateTheme(
    background: Colors.white,
    primary: Color(0xFF6366F1),
    text: Colors.black87,
    textSecondary: Colors.black54,
  );

  static const gaming = UpdateTheme(
    background: Color(0xFF0F0F23),
    primary: Color(0xFF00F5FF),
    text: Colors.white,
    textSecondary: Color(0xFFB4B4B4),
    gradient: LinearGradient(colors: [Color(0xFF0F0F23), Color(0xFF1A0B2E)]),
  );
}

class AdvancedUpdateDialog extends StatefulWidget {
  final UpdateConfig config;
  final bool isForce;
  final String currentVersion;
  final VoidCallback onUpdate;
  final VoidCallback onSkip;
  final VoidCallback onLater;
  final UpdateTheme theme;

  const AdvancedUpdateDialog({
    super.key,
    required this.config,
    required this.isForce,
    required this.currentVersion,
    required this.onUpdate,
    required this.onSkip,
    required this.onLater,
    this.theme = UpdateTheme.dark,
  });

  @override
  State<AdvancedUpdateDialog> createState() => _AdvancedUpdateDialogState();
}

class _AdvancedUpdateDialogState extends State<AdvancedUpdateDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  int _countdown = 5;
  bool _showCountdown = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _scaleController.forward();

    if (widget.isForce) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _showCountdown = true;
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdown--);
      if (_countdown <= 0) {
        widget.onUpdate();
        return false;
      }
      return true;
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: widget.theme.background,
            borderRadius: BorderRadius.circular(24),
            gradient: widget.theme.gradient,
            boxShadow: [
              BoxShadow(
                color: widget.theme.primary.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildContent(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.theme.primary.withOpacity(0.2),
            widget.theme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          _buildAnimatedIcon(),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UpdateLocalization.title,
                  style: TextStyle(
                    color: widget.theme.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.theme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'v${widget.config.latestVersion}',
                    style: TextStyle(
                      color: widget.theme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.theme.primary.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      widget.theme.primary.withOpacity(0),
                      widget.theme.primary.withOpacity(0.5),
                      widget.theme.primary.withOpacity(0),
                    ],
                    stops: [0.0, _shimmerController.value, 1.0],
                  ),
                ),
              );
            },
          ),
          Icon(
            widget.isForce? Icons.warning_rounded : Icons.system_update_alt,
            color: widget.theme.primary,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UpdateLocalization.message,
            style: TextStyle(
              color: widget.theme.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20),
          _buildChangelogCard(),
          if (widget.config.vipGiftDays > 0 &&!widget.isForce)...[
            SizedBox(height: 16),
            _buildGiftCard(),
          ],
          if (widget.isForce && _showCountdown)...[
            SizedBox(height: 16),
            _buildCountdownCard(),
          ],
          SizedBox(height: 16),
          _buildVersionInfo(),
        ],
      ),
    );
  }

  Widget _buildChangelogCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.theme.text.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.theme.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: widget.theme.primary, size: 20),
              SizedBox(width: 8),
              Text(
                UpdateLocalization.whatsNew,
                style: TextStyle(
                  color: widget.theme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...widget.config.changelog.split('\n').map((line) {
            if (line.trim().isEmpty) return SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: widget.theme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      line.replaceAll('•', '').trim(),
                      style: TextStyle(
                        color: widget.theme.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGiftCard() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.theme.primary.withOpacity(0.3),
                widget.theme.primary.withOpacity(0.1),
              ],
              stops: [0, _shimmerController.value],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.theme.primary.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.theme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  color: widget.theme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هدية حصرية',
                      style: TextStyle(
                        color: widget.theme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${widget.config.vipGiftDays} أيام VIP مجاناً',
                      style: TextStyle(
                        color: widget.theme.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountdownCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Text(
            'تحديث إجباري خلال $_countdown ثواني',
            style: TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildVersionChip(UpdateLocalization.currentVersionLabel, widget.currentVersion, Colors.grey),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, color: widget.theme.primary, size: 16),
        ),
        _buildVersionChip(UpdateLocalization.newVersionLabel, widget.config.latestVersion, widget.theme.primary),
      ],
    );
  }

  Widget _buildVersionChip(String label, String version, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
          ),
          SizedBox(width: 6),
          Text(
            version,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.theme.text.withOpacity(0.03),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          if (!widget.isForce)...[
            Expanded(
              child: TextButton(
                onPressed: widget.onSkip,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  UpdateLocalization.skip,
                  style: TextStyle(color: widget.theme.textSecondary),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextButton(
                onPressed: widget.onLater,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  UpdateLocalization.later,
                  style: TextStyle(color: widget.theme.textSecondary),
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
          Expanded(
            flex: widget.isForce? 1 : 2,
            child: ElevatedButton(
              onPressed: widget.onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.theme.primary,
                foregroundColor: widget.theme.background,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    UpdateLocalization.updateNow,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
