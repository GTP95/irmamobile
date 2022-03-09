import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/history/history_screen.dart';
import 'package:irmamobile/src/screens/scanner/scanner_screen.dart';
import 'package:irmamobile/src/screens/settings/settings_screen.dart';
import 'package:irmamobile/src/theme/theme.dart';

class IrmaNavBar extends StatefulWidget {
  const IrmaNavBar({Key? key}) : super(key: key);

  @override
  _IrmaNavBarState createState() => _IrmaNavBarState();
}

class _IrmaNavBarState extends State<IrmaNavBar> {
  String selectedTab = 'home';

  Widget _buildNavButton(IconData iconData, String label, [String? routeName]) => Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              selectedTab = label;
            });
            if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 28,
                color:
                    selectedTab == label ? IrmaTheme.of(context).themeData.colorScheme.primary : Colors.grey.shade600,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                FlutterI18n.translate(context, 'home.nav_bar.$label'),
                style: TextStyle(
                    color: selectedTab == label
                        ? IrmaTheme.of(context).themeData.colorScheme.primary
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );

  Widget _buildQrButton() => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade600.withOpacity(0.5),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 7))
          ],
        ),
        child: CircleAvatar(
          backgroundColor: IrmaTheme.of(context).themeData.colorScheme.primary,
          radius: 36,
          child: IconButton(
              tooltip: FlutterI18n.translate(context, 'home.nav_bar.open_scanner'),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, ScannerScreen.routeName);
              },
              icon: const Icon(Icons.qr_code, size: 34)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      height: 110,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade600.withOpacity(0.5),
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: const Offset(0, 7))
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(Icons.home_filled, 'home'),
          _buildNavButton(Icons.folder_shared, 'data'),
          _buildQrButton(),
          _buildNavButton(Icons.history, 'activity', HistoryScreen.routeName),
          _buildNavButton(Icons.smartphone, 'app', SettingsScreen.routeName),
        ],
      ),
    );
  }
}
