import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/maintenance_model.dart';
import '../../widgets/app_button.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preventive Maintenance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scheduled Maintenance Tasks', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            _buildMaintenanceCard('EL-101', 'Building A', 'Next: Oct 22, 2026', true),
            _buildMaintenanceCard('EL-205', 'Building B', 'Next: Oct 25, 2026', false),
            _buildMaintenanceCard('EL-312', 'Building C', 'Overdue - URGENT', true),
            const SizedBox(height: 24),
            const Text('Maintenance Types', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            AppButton(label: 'Daily Maintenance', onPressed: () => _showMaintenanceWorkflow(context, 'Daily')),
            const SizedBox(height: 12),
            AppButton(label: 'Weekly Maintenance', onPressed: () => _showMaintenanceWorkflow(context, 'Weekly'), backgroundColor: AppColors.info),
            const SizedBox(height: 12),
            AppButton(label: 'Monthly Maintenance', onPressed: () => _showMaintenanceWorkflow(context, 'Monthly'), backgroundColor: AppColors.warning),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceCard(String elevatorId, String building, String dueDate, bool isUrgent) {
    return Container(
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
              Text(elevatorId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUrgent ? AppColors.danger.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(isUrgent ? 'URGENT' : 'SCHEDULED', style: TextStyle(color: isUrgent ? AppColors.danger : AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(building, style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Text(dueDate, style: AppTextStyles.body2),
          const SizedBox(height: 12),
          AppButton(
            label: 'Start Maintenance',
            width: 150,
            isFullWidth: false,
            onPressed: () => _showMaintenanceWorkflow(context, 'Preventive'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceWorkflow(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Maintenance Checklist'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _checklistItem('Lubricate guide rails', true),
              _checklistItem('Check door operation', true),
              _checklistItem('Inspect safety devices', true),
              _checklistItem('Test emergency brake', true),
              _checklistItem('Clean car exterior', false),
              _checklistItem('Check electrical connections', false),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maintenance report submitted')));
              Navigator.pop(context);
            },
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  Widget _checklistItem(String task, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(value: completed, onChanged: (val) {}),
          Expanded(child: Text(task, style: AppTextStyles.body2)),
        ],
      ),
    );
  }
}
