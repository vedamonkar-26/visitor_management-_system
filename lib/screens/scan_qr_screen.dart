import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import 'checkout_visitor_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Align QR code within the frame',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            // Viewfinder Frame
            Expanded(
              child: Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Stack(
                    children: [
                      // Simulated Camera background grid
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            color: Colors.black45,
                            child: Center(
                              child: Icon(
                                Icons.qr_code_2,
                                size: 160,
                                color: Color(0xD9FFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Corner Brackets
                      const _CornerBracket(top: 0, left: 0, isTop: true, isLeft: true),
                      const _CornerBracket(top: 0, right: 0, isTop: true, isLeft: false),
                      const _CornerBracket(bottom: 0, left: 0, isTop: false, isLeft: true),
                      const _CornerBracket(bottom: 0, right: 0, isTop: false, isLeft: false),
                    ],
                  ),
                ),
              ),
            ),

            // Scan Action Buttons (Interactive frontend testing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Simulate Pre-Registered Check-In Scan'),
                    onPressed: () {
                      if (appState.visitors.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No registered visitors available to scan.')),
                        );
                        return;
                      }
                      final johnVisitor = appState.visitors.firstWhere(
                        (v) => v.name == 'John Smith',
                        orElse: () => appState.visitors.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutVisitorScreen(visitor: johnVisitor),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.purpleCheckedOut, width: 1.5),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    icon: const Icon(Icons.exit_to_app, color: AppColors.purpleCheckedOut),
                    label: const Text(
                      'Simulate Exit Check-Out QR Scan',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (appState.visitors.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No visitors available to check out.')),
                        );
                        return;
                      }
                      final insideVisitor = appState.visitorsInside.isNotEmpty
                          ? appState.visitorsInside.first
                          : appState.visitors.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutVisitorScreen(visitor: insideVisitor),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom Bar: Torch & Gallery Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ScanOptionButton(
                    icon: _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                    label: 'Torch',
                    onTap: () {
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                      });
                    },
                  ),
                  _ScanOptionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gallery opened for QR selection')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.isTop,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    const double length = 24.0;
    const double thickness = 4.0;
    const Color color = AppColors.primary;

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SizedBox(
        width: length,
        height: length,
        child: CustomPaint(
          painter: _CornerPainter(
            isTop: isTop,
            isLeft: isLeft,
            color: color,
            thickness: thickness,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final Color color;
  final double thickness;

  _CornerPainter({
    required this.isTop,
    required this.isLeft,
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ScanOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0x1FFFFFFF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
