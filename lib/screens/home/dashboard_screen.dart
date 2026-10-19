import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/app_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<JobProvider>().loadJobs();
      context.read<AuthProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('elevatorX Technician'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          if (jobProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => jobProvider.loadJobs(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF2C5AA0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${context.watch<AuthProvider>().technician?.name?.split(' ').first}!',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Today: ${jobProvider.todayJobs.length} jobs',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Work Summary', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildKPICard('Today', jobProvider.todayJobs.length.toString(), Icons.calendar_today, AppColors.primary),
                      _buildKPICard('Pending', jobProvider.pendingJobs.length.toString(), Icons.pending_actions, AppColors.warning),
                      _buildKPICard('In Progress', jobProvider.inProgressJobs.length.toString(), Icons.hourglass_top, AppColors.info),
                      _buildKPICard('Completed', jobProvider.completedJobs.length.toString(), Icons.check_circle, AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (jobProvider.urgentJobs.isNotEmpty) ...[
                    const Text('Urgent Jobs', style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.1),
                        border: Border.all(color: AppColors.danger),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${jobProvider.urgentJobs.length} urgent job${jobProvider.urgentJobs.length > 1 ? 's' : ''} awaiting attention',
                        style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Maintenance'),
          BottomNavigationBarItem(icon: Icon(Icons.emergency), label: 'Breakdown'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Reports'),
        ],
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _navigateToSection(index);
        },
      ),
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _navigateToSection(int index) {
    switch (index) {
      case 1:
        GoRouter.of(context).pushNamed('my-jobs');
        break;
      case 2:
        GoRouter.of(context).pushNamed('maintenance');
        break;
      case 3:
        GoRouter.of(context).pushNamed('breakdown');
        break;
      case 4:
        GoRouter.of(context).pushNamed('reports');
        break;
    }
  }
}
