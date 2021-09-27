import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:passcard_hub/providers/app_config_provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  void _openGitHub() async {
    String url = "https://github.com/JGeek00";
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      enableJavaScript: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<AppConfigProvider>(context);

    return SafeArea(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/icon/passcard_hub-icon-only.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                "PassCard Hub",
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Tema",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile(
                      value: 'system', 
                      groupValue: configProvider.themeValue, 
                      onChanged: (value) => configProvider.setTheme(value.toString()),
                      title: const Text("Definido por el sistema"),
                    ),
                    RadioListTile(
                      value: 'light', 
                      groupValue: configProvider.themeValue, 
                      onChanged: (value) => configProvider.setTheme(value.toString()),
                      title: const Text("Claro"),
                    ),
                    RadioListTile(
                      value: 'dark', 
                      groupValue: configProvider.themeValue, 
                      onChanged: (value) => configProvider.setTheme(value.toString()),
                      title: const Text("Oscuro"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Acerca de",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ListTile(
                        title: const Text("Versión de la app"),
                        subtitle: Text(configProvider.appVersion),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ListTile(
                        title: const Text("Creado por"),
                        subtitle: const Text("JGeek00"),
                        trailing: const Icon(Icons.launch),
                        onTap: _openGitHub,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}