import 'package:flutter/material.dart';

import 'package:passhub/widgets/insert_url_dialog.dart';

class AddPassMenu extends StatelessWidget {
  final void Function() fromDevice;
  final void Function(String url) fromUrl;

  const AddPassMenu({
    Key? key,
    required this.fromDevice,
    required this.fromUrl,
  }) : super(key: key);

  Future<void> _showFromUrlDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InsertUrlDialog(
          controller: controller, 
          getFromUrl: (String urlValue) => fromUrl(urlValue),
        );
      },
    );
  }

  Widget _listItem({
    required IconData icon, 
    required String title, 
    required String description, 
    required void Function() onTap
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const  TextStyle(
                      color: Colors.grey
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), 
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Fuente del pase",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          _listItem(
            icon: Icons.smartphone, 
            title: "Desde el dispositivo", 
            description: "Elegir un fichero desde del dispositivo",
            onTap: () async {
              Navigator.of(context).pop();
              fromDevice();
            }
          ),
          _listItem(
            icon: Icons.link, 
            title: "Desde un enlace", 
            description: "Introducir un enlace de internet",
            onTap: () {
              Navigator.of(context).pop();
              _showFromUrlDialog(context);
            }
          ),
        ],
      ),
    );
  }
}