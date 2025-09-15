import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_pos/core/providers/auth_providers.dart';
import '../views/login_page.dart';
// import '../views/admins/cashier_mgmt_page.dart';
// import '../views/admins/ingredient_mgmt_page.dart';
// import '../views/admins/product_mgmt_page.dart';
// import '../views/admins/report_page.dart';
// import '../shared/profile_page.dart';

class RADrawer extends StatelessWidget {
  const RADrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProviders>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              'RESTO',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          /*
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Kelola Kasir'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CashierMgmtPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Kelola Produk'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ProductMgmtPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.grain),
            title: Text('Kelola Bahan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => IngredientMgmtPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text('Laporan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ReportPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
          */
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              auth.logout();
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
