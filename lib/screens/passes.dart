import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_flutter/pass_flutter.dart';
import 'package:provider/provider.dart';

import 'package:passcard_hub/providers/app_config_provider.dart';
import 'package:passcard_hub/providers/categories_provider.dart';
import 'package:passcard_hub/widgets/pass_page.dart';
import 'package:passcard_hub/providers/passes_provider.dart';
import 'package:passcard_hub/widgets/filters_menu.dart';


class Passes extends StatefulWidget {
  const Passes({Key? key,}) : super(key: key);

  @override
  State<Passes> createState() => _PassesState();
}

class _PassesState extends State<Passes> {
  final PageController controller = PageController();

  void animatePassStatusChange({
    required PassFile passFile, 
    required PassesProvider passesProvider, 
    required String action,
    required int pageIndex
  }) async {
    if (pageIndex != passesProvider.getPasses.length-1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 250), 
        curve: Curves.easeInOut
      );
      await Future.delayed(const Duration(milliseconds: 250), () {
        if (action == 'delete') {
          passesProvider.deletePass(context, passFile);
        }
        else {
          passesProvider.changePassStatus(passFile, action);
        }
      });
    }
    else {
      if (passesProvider.getPasses.length > 1) {
        controller.previousPage(
          duration: const Duration(milliseconds: 250), 
          curve: Curves.easeInOut
        );
      }
      await Future.delayed(const Duration(milliseconds: 250), () {
        if (action == 'delete') {
          passesProvider.deletePass(context, passFile);
        }
        else {
          passesProvider.changePassStatus(passFile, action);
        }
      });
    }
  }

  void _showFiltersCard() {
    final configProvider = Provider.of<AppConfigProvider>(context, listen: false);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      context: context, 
      builder: (context) => const FiltersMenu(),
    ).whenComplete(() => configProvider.setModalBottomSheetStatus(false));

    configProvider.setModalBottomSheetStatus(true);
  }

  @override
  Widget build(BuildContext context) {
    final passesProvider = Provider.of<PassesProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final configProvider = Provider.of<AppConfigProvider>(context);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoriesProvider.categoryTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (categoriesProvider.selectedStatus == 'archived') Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Archivados",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: configProvider.themeMode == ThemeMode.light ? (
                              Colors.white
                            ) : (
                              Colors.black
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  IconButton(
                    onPressed: _showFiltersCard, 
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              )
            ],
          ),
        ),
        passesProvider.getPasses.isNotEmpty ? (
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return false;
              },
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: controller,
                itemBuilder: (context, index) => PassPage(
                    passFile: passesProvider.getPasses[index], 
                    selectedStatus: categoriesProvider.selectedStatus,
                    removePass: (passFile) => animatePassStatusChange(
                      passFile: passFile, 
                      passesProvider: passesProvider, 
                      action: 'delete',
                      pageIndex: index,
                    ),
                    archivePass: (passFile) => categoriesProvider.selectedStatus == 'active' ? (
                      animatePassStatusChange(
                        passFile: passFile, 
                        passesProvider: passesProvider, 
                        action: 'archived',
                        pageIndex: index,
                      )
                    ) : (
                      animatePassStatusChange(
                        passFile: passFile, 
                        passesProvider: passesProvider, 
                        action: 'active',
                        pageIndex: index,
                      )
                    ),
                  ),
                itemCount: passesProvider.getPasses.length,
              ),
            ),
          )
        ) : (
          Expanded(
            child: (
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.local_activity,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No hay pases para mostrar",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey
                    ),
                  ),
                ],
              )
            ),
          )
        ),
      ],
    );
  }
}