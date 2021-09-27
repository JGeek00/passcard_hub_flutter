import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:passhub/providers/app_config_provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
                'assets/icon/buswallet-logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                "PassHub",
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
              )
            ],
          ),
        ),
      )
    );
  }
}