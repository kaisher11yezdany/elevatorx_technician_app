import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/app_button.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedTab = 'Draft';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Reports')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: ['Draft', 'Submitted', 'Approved'].map((tab) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tab),
                  selected: _selectedTab == tab,
                  onSelected: (_) => setState(() => _selectedTab = tab),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _buildReportCard('SR-001', 'EL-101', 'Maintenance', 'Draft', false),
                _buildReportCard('SR-002', 'EL-205', 'Breakdown Repair', 'Submitted', true),
                _buildReportCard('SR-003', 'EL-312', 'Installation', 'Approved', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String reportId, String elevatorId, String reportType, String status, bool isApproved) {
    return GestureDetector(
      onTap: () => _showReportDetail(context, reportId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                Text(reportId, style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isApproved ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: isApproved ? AppColors.success : AppColors.warning, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$elevatorId • $reportType', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'View Report',
              width: 140,
              isFullWidth: false,
              onPressed: () => _showReportDetail(context, reportId),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDetail(BuildContext context, String reportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report: $reportId'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Report Type: Service Maintenance', style: AppTextStyles.body2),
              SizedBox(height: 12),
              Text('Checklist Items Completed:', style: AppTextStyles.caption),
              SizedBox(height: 8),
              Text('✓ Safety devices tested', style: TextStyle(color: AppColors.success)),
              Text('✓ All components lubricated', style: TextStyle(color: AppColors.success)),
              Text('✓ Electrical connections verified', style: TextStyle(color: AppColors.success)),
              SizedBox(height: 12),
              Text('Photographs: 5 uploaded', style: AppTextStyles.caption),
              SizedBox(height: 12),
              Text('Parts Used: Door opener relay, Grease (2 liters)', style: AppTextStyles.caption),
              SizedBox(height: 12),
              Text('Status: Ready for submission', style: AppTextStyles.body2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted for approval')));
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
