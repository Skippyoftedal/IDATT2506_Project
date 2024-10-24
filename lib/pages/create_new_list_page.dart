import 'package:flutter/material.dart';
import 'package:idatt2506_project/services/input_validator.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/view/error/critical_error.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateNewListPage extends StatefulWidget {
  const CreateNewListPage({super.key});

  @override
  State<CreateNewListPage> createState() => _CreateNewListPageState();
}

class _CreateNewListPageState extends State<CreateNewListPage> {
  final textController = TextEditingController();
  int selectedIconCodePoint = Icons.list.codePoint;


  static final List<IconData> available = [
    Icons.list,
    Icons.shopping_cart,
    Icons.cabin,
    Icons.attach_money_rounded,
    Icons.computer,
    Icons.garage,
    Icons.train,
    Icons.fastfood,
    Icons.local_pizza_rounded,
    Icons.diamond_outlined,
    Icons.school,
    Icons.work,
    Icons.apartment_sharp
  ];

  @override
  Widget build(BuildContext context) {
    return StandardScaffold(
      title: AppLocalizations.of(context)!.addNewList,
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 50),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Card(
                    elevation: 10,
                    child: TextField(
                      controller: textController,
                      onSubmitted: (_) {
                        createListAndPush();
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.createListInputHint,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLowest,
                        filled: true,
                        prefixIcon: Icon(
                          IconData(selectedIconCodePoint,
                              fontFamily: 'MaterialIcons'),
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            createListAndPush();
                          },
                          icon: Icon(Icons.add_circle_outline,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.selectListIcon,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              iconSelector()
            ],
          ),
        ),
      ),
    );
  }

  Widget iconSelector() {

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: available.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return iconSelectorButton(available[index].codePoint);
        },
      ),
    );
  }

  Widget iconSelectorButton(int iconCodePoint) {
    var isSelected = (selectedIconCodePoint == iconCodePoint);
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            width: 5.0,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerLowest),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: () {
          setState(
            () {
              selectedIconCodePoint = iconCodePoint;
            },
          );
        },
        icon: Icon(
          IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void createListAndPush() async {
    final NavigatorState navigator = Navigator.of(context);
    final title = textController.text;
    String? errorMessage;
    try {
      InputValidator.validListName(title);
      await ListService.createEmptyList(name: title, iconCodePoint: selectedIconCodePoint);
      navigator.push(
        MaterialPageRoute(builder: (_) => ListPage(listName: title)),
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    if (errorMessage != null) {
      showError(errorMessage);
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CriticalError(errorMessage: message);
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
