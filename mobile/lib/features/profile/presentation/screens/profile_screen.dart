import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../subscription/presentation/providers/subscription_providers.dart';
import '../../../../core/auth/auth_gate.dart';
import '../../../../core/localization/locale_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardProfile());
  }

  Future<void> _guardProfile() async {
    final ok = await AuthGate.requireAuth(
      context,
      ref,
      message: AppLocalizations.of(context).loginToAccessProfile,
    );
    if (!ok && mounted) {
      context.pop();
    } else {
      _loadAccessInfo();
    }
  }

  Future<void> _loadAccessInfo() async {
    try {
      final dataSource = ref.read(subscriptionRemoteDataSourceProvider);
      final accessInfo = await dataSource.checkAccess();
      ref.read(accessInfoProvider.notifier).state = accessInfo;
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);
    final accessInfo = ref.watch(accessInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF6B4CE6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(
              user?.fullName ?? 'User',
              (user?.email != null && user!.email!.isNotEmpty)
                  ? user.email!
                  : (user?.phoneNumber ?? ''),
            ),
            if (accessInfo != null) _buildSubscriptionCard(accessInfo),
            const SizedBox(height: 16),
            _buildMenuSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    final displayName = name.isNotEmpty ? name : 'Not Set';
    final displayEmail = email.isNotEmpty ? email : 'Not Set';
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B4CE6), Color(0xFF9B6BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFC06BFF)],
              ),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayEmail,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(accessInfo) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6B4CE6).withOpacity(0.1),
            const Color(0xFF9B6BFF).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6B4CE6).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6B4CE6).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_membership,
              color: Color(0xFF6B4CE6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accessInfo.hasAccess
                      ? (accessInfo.accessType == 'trial' ? 'Free Trial' : 'Premium Member')
                      : 'No Active Plan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  accessInfo.hasAccess
                      ? '${accessInfo.daysLeft} days remaining'
                      : 'Subscribe to access premium content',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (!accessInfo.hasAccess || accessInfo.accessType == 'trial')
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.child_care,
          title: 'Child Profiles',
          subtitle: 'Manage your children\'s profiles',
          color: Colors.pink,
          onTap: () => context.push('/child-profiles'),
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Account Settings',
          subtitle: 'Update your account information',
          color: Colors.blue,
          onTap: () => context.push('/account-settings'),
        ),
        _buildMenuItem(
          icon: Icons.card_membership,
          title: 'Subscription',
          subtitle: 'Manage your subscription plan',
          color: Colors.orange,
          onTap: () => context.push('/subscription'),
        ),
        _buildMenuItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Notification preferences',
          color: Colors.purple,
          onTap: () => context.push('/notification-settings'),
        ),
        _buildMenuItem(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Manage your privacy settings',
          color: Colors.green,
          onTap: () => context.push('/privacy-settings'),
        ),
        _buildMenuItem(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          color: Colors.teal,
          onTap: () => context.push('/help-support'),
        ),
        _buildMenuItem(
          icon: Icons.info,
          title: 'About',
          subtitle: 'App version and information',
          color: Colors.indigo,
          onTap: () => context.push('/about'),
        ),
        const SizedBox(height: 16),
        _buildLogoutButton(context, ref),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: () => _showLogoutDialog(context, ref),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).state = null;
              ref.read(guestModeProvider.notifier).state = true;
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
