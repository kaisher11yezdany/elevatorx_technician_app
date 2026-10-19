import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/app_button.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String? _scannedElevatorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Elevator QR Code')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_2, size: 80, color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text('Point camera at QR code', style: AppTextStyles.body2),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Open Camera',
                      width: 150,
                      isFullWidth: false,
                      onPressed: () => _scanQRCode(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_scannedElevatorId != null) ...[
              const Text('Scanned Elevator:', style: AppTextStyles.h4),
              const SizedBox(height: 16),
              _buildElevatorCard(_scannedElevatorId!),
            ],
            const SizedBox(height: 24),
            const Text('Recent Scans', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            _buildRecentScanCard('EL-101', 'Building A', 'Oct 20, 2026'),
            _buildRecentScanCard('EL-205', 'Building B', 'Oct 19, 2026'),
            _buildRecentScanCard('EL-312', 'Building C', 'Oct 18, 2026'),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatorCard(String elevatorId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(elevatorId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Operational', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _detailRow('Location:', 'Building A, Floor 5'),
          _detailRow('Model:', 'Variomodern 100'),
          _detailRow('Capacity:', '1000 kg'),
          _detailRow('Warranty:', 'Active until Dec 2027'),
          _detailRow('AMC:', 'Active - Monthly'),
          const SizedBox(height: 16),
          AppButton(
            label: 'View Full Details',
            onPressed: () => _showElevatorDetails(context, elevatorId),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScanCard(String elevatorId, String location, String date) {
    return GestureDetector(
      onTap: () => setState(() => _scannedElevatorId = elevatorId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(elevatorId, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(location, style: AppTextStyles.caption),
              ],
            ),
            Text(date, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.body2),
        ],
      ),
    );
  }

  void _scanQRCode() {
    setState(() => _scannedElevatorId = 'EL-101');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QR Code scanned successfully')));
  }

  void _showElevatorDetails(BuildContext context, String elevatorId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Elevator $elevatorId - Full Details'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Installation Date: Jan 15, 2020', style: AppTextStyles.body2),
              SizedBox(height: 8),
              Text('Commissioning Date: Jan 20, 2020', style: AppTextStyles.body2),
              SizedBox(height: 8),
              Text('Last Maintenance: Oct 15, 2026', style: AppTextStyles.body2),
              SizedBox(height: 8),
              Text('Service History: 45 visits', style: AppTextStyles.body2),
              SizedBox(height: 16),
              Text('Documents Available:', style: AppTextStyles.caption),
              SizedBox(height: 8),
              Text('• Installation drawings', style: AppTextStyles.body2),
              Text('• Wiring diagrams', style: AppTextStyles.body2),
              Text('• Technical manual', style: AppTextStyles.body2),
              Text('• Previous service reports', style: AppTextStyles.body2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}
