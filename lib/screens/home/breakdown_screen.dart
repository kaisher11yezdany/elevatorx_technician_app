import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/app_button.dart';

class BreakdownScreen extends StatefulWidget {
  const BreakdownScreen({Key? key}) : super(key: key);

  @override
  State<BreakdownScreen> createState() => _BreakdownScreenState();
}

class _BreakdownScreenState extends State<BreakdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breakdown Repair')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.danger),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Breakdown Calls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.danger)),
                  SizedBox(height: 8),
                  Text('2 urgent jobs awaiting response', style: TextStyle(color: AppColors.danger)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Breakdown Reports', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            _buildBreakdownCard('BK-2301', 'EL-101', 'Doors not opening', 'Critical', true),
            _buildBreakdownCard('BK-2302', 'EL-205', 'Unusual noise', 'High', false),
            _buildBreakdownCard('BK-2303', 'EL-312', 'Power loss', 'Emergency', true),
            const SizedBox(height: 24),
            AppButton(
              label: 'Create New Breakdown Report',
              onPressed: () => _showBreakdownForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(String reportId, String elevatorId, String issue, String priority, bool isUrgent) {
    return GestureDetector(
      onTap: () => _showBreakdownDetail(context, reportId, elevatorId, issue),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isUrgent ? AppColors.danger : AppColors.border),
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 8)],
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
                    color: _getPriorityColor(priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(priority, style: TextStyle(color: _getPriorityColor(priority), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Elevator: $elevatorId', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Text(issue, style: AppTextStyles.body2),
            const SizedBox(height: 12),
            AppButton(
              label: 'View & Update',
              width: 120,
              isFullWidth: false,
              onPressed: () => _showBreakdownDetail(context, reportId, elevatorId, issue),
            ),
          ],
        ),
      ),
    );
  }

  void _showBreakdownForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Breakdown Report'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Issue Category:', style: AppTextStyles.caption),
              SizedBox(height: 8),
              Text('• Doors not opening', style: AppTextStyles.body2),
              Text('• Doors not closing', style: AppTextStyles.body2),
              Text('• Abnormal noise', style: AppTextStyles.body2),
              Text('• Power failure', style: AppTextStyles.body2),
              SizedBox(height: 16),
              Text('Troubleshooting completed', style: AppTextStyles.caption),
              SizedBox(height: 8),
              Text('✓ Checked power supply', style: TextStyle(color: AppColors.success)),
              Text('✓ Reset control panel', style: TextStyle(color: AppColors.success)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted')));
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showBreakdownDetail(BuildContext context, String reportId, String elevatorId, String issue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report: $reportId'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Elevator:', elevatorId),
              _detailRow('Issue:', issue),
              _detailRow('Status:', 'In Progress'),
              _detailRow('Arrived:', '10:30 AM'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated')));
              Navigator.pop(context);
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppTextStyles.body2)),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'Emergency' || priority == 'Critical') return AppColors.danger;
    if (priority == 'High') return AppColors.warning;
    return AppColors.info;
  }
}
