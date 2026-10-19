import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/job_provider.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({Key? key}) : super(key: key);

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<JobProvider>().loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs')),
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          final jobs = _getFilteredJobs(provider);

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: ['All', 'Today', 'Pending', 'In Progress', 'Completed']
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(f),
                              selected: _filter == f,
                              onSelected: (_) => setState(() => _filter = f),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: jobs.isEmpty
                    ? const Center(child: Text('No jobs found'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) => _buildJobCard(context, jobs[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job) {
    return GestureDetector(
      onTap: () => _showJobDetails(context, job),
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
                Expanded(child: Text(job.jobNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(job.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(job.priority, style: TextStyle(color: _getStatusColor(job.priority), fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(job.building, style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(job.description, style: AppTextStyles.body2, maxLines: 2, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColorBg(job.status),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(job.status, style: TextStyle(color: _getStatusColor(job.status), fontSize: 11)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getFilteredJobs(JobProvider provider) {
    switch (_filter) {
      case 'Today':
        return provider.todayJobs;
      case 'Pending':
        return provider.pendingJobs;
      case 'In Progress':
        return provider.inProgressJobs;
      case 'Completed':
        return provider.completedJobs;
      default:
        return provider.jobs;
    }
  }

  void _showJobDetails(BuildContext context, dynamic job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job.jobNumber),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Building:', job.building),
              _detailRow('Category:', job.category),
              _detailRow('Priority:', job.priority),
              _detailRow('Status:', job.status),
              _detailRow('Customer:', job.customerName),
              _detailRow('Address:', job.siteAddress),
              _detailRow('Elevator ID:', job.elevatorId),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          if (job.isPending)
            ElevatedButton(
              onPressed: () {
                context.read<JobProvider>().acceptJob(job.id);
                Navigator.pop(context);
              },
              child: const Text('Accept Job'),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppTextStyles.body2)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Resolved' || status == 'Closed') return AppColors.success;
    if (status == 'Assigned' || status == 'Accepted') return AppColors.info;
    if (status == 'In Progress' || status == 'On Site') return AppColors.warning;
    return AppColors.danger;
  }

  Color _getStatusColorBg(String status) => _getStatusColor(status).withOpacity(0.1);
}
