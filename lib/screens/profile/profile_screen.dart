import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_store_ui/screens/profile/header.dart';
import 'package:fresh_store_ui/screens/profile/order_view_screen.dart';

typedef ProfileOptionTap = void Function();

class ProfileOption {
  String title;
  IconData icon;
  Color? titleColor;
  ProfileOptionTap? onClick;
  Widget? trailing;

  ProfileOption({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor,
    this.trailing,
  });

  ProfileOption.arrow({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor = const Color(0xFF212121),
    this.trailing = const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.orange),
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String route() => '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _isDark = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final userId = _currentUser?.uid;
    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      setState(() {
        _isAdmin = userDoc['role'] == 'admin';
      });
    }
  }

  List<ProfileOption> get datas {
    final options = <ProfileOption>[
      ProfileOption.arrow(
        title: 'View Orders',
        icon: Icons.shopping_basket,
        onClick: () {
          final loggedInUserId = _currentUser?.uid;
          if (loggedInUserId != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderViewScreen(userId: loggedInUserId),
              ),
            );
          }
        },
      ),
      ProfileOption.arrow(
        title: 'Notification',
        icon: Icons.notifications,
      ),
      _languageOption(),
      _darkModeOption(),
    ];

    // Admin-specific options
    if (_isAdmin) {
      options.addAll([
        ProfileOption.arrow(
          title: 'Add Products',
          icon: Icons.add_shopping_cart,
          onClick: () {
            Navigator.of(context).pushNamed('/addProduct');
          },
        ),
        ProfileOption.arrow(
          title: 'View Products',
          icon: Icons.shopping_basket,
          onClick: () {
            Navigator.of(context).pushNamed('/viewproduct');
          },
        ),
        ProfileOption.arrow(
          title: 'Add Categories',
          icon: Icons.category,
          onClick: () {
            Navigator.of(context).pushNamed('/addcategorie');
          },
        ),
        ProfileOption.arrow(
          title: 'View Categories',
          icon: Icons.grid_view,
          onClick: () {
            Navigator.of(context).pushNamed('/viewcategorie');
          },
        ),
        ProfileOption.arrow(
          title: 'Order Details',
          icon: Icons.grid_view,
          onClick: () {
            Navigator.of(context).pushNamed('/orderdetails');
          },
        ),
          ProfileOption.arrow(
          title: 'Approved Orders',
          icon: Icons.check_circle,
          onClick: () {
            Navigator.of(context).pushNamed('/approvedetails');
          },
        ),
        ProfileOption.arrow(
          title: 'Rejected Orders',
          icon: Icons.cancel,
          onClick: () {
            Navigator.of(context).pushNamed('/rejectdetails');
          },
        ),
        ProfileOption.arrow(
          title: 'Delieverd Orders',
          icon: Icons.delivery_dining,
          onClick: () {
            Navigator.of(context).pushNamed('/deliverdetails');
          },
        ),
      ]);
    }

    options.add(
      ProfileOption(
        title: 'Logout',
        icon: Icons.logout,
        titleColor: const Color(0xFFF75555),
        onClick: _logout,
      ),
    );

    return options;
  }

  _languageOption() => ProfileOption(
        title: 'Language',
        icon: Icons.language,
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'English (US)',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.orange),
            ],
          ),
        ),
      );

  _darkModeOption() => ProfileOption(
        title: 'Dark Mode',
        icon: Icons.dark_mode,
        trailing: Switch(
          value: _isDark,
          activeColor: const Color(0xFF212121),
          onChanged: (value) {
            setState(() {
              _isDark = value;
            });
          },
        ),
      );

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ProfileHeader(
                  userName: _isAdmin ? 'Admin' : 'User',
                  userEmail: _currentUser?.email ?? 'No email found',
                ),
              ),
            ]),
          ),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 10.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final data = datas[index];
            return _buildOption(context, index, data);
          },
          childCount: datas.length,
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, ProfileOption data) {
    return ListTile(
      leading: Icon(data.icon, color: Colors.orange), // Icon color set to orange
      title: Text(
        data.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: data.titleColor,
        ),
      ),
      trailing: data.trailing,
      onTap: data.onClick,
    );
  }
}
