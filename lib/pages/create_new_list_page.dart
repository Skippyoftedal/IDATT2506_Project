import 'package:flutter/material.dart';
import 'package:idatt2506_project/error/already_exists_error.dart';
import 'package:idatt2506_project/error/empty_input_error.dart';
import 'package:idatt2506_project/error/only_whitespace_error.dart';
import 'package:idatt2506_project/model/todo_list.dart';
import 'package:idatt2506_project/services/list_service.dart';
import 'package:idatt2506_project/pages/list_page.dart';
import 'package:idatt2506_project/view/error/critical_error.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The page used to create a new [TodoList] with an icon and name.
///
/// On creation the user is transferred to a [ListPage] for further interaction
/// with the list.
class CreateNewListPage extends StatefulWidget {
  const CreateNewListPage({super.key});

  @override
  State<CreateNewListPage> createState() => _CreateNewListPageState();
}

class _CreateNewListPageState extends State<CreateNewListPage> {

  /// [TextEditingController] for the title input
  final titleInputController = TextEditingController();

  /// The selected [int] value of the selected icon
  int selectedIconCodePoint = Icons.list.codePoint;

  /// A list of all available icons
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
                      controller: titleInputController,
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

  /// Grid view of the icon buttons
  Widget iconSelector() {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
      ),
    );
  }

  /// Button containing a single icon, with a border that changes color when
  /// selected.
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

  /// Creates a new list and pushes the router to a [ListPage] with the list of
  /// the created list.
  ///
  /// If an error is encountered an error is shown in a modal
  void createListAndPush() async {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    final NavigatorState navigator = Navigator.of(context);
    final title = titleInputController.text;
    String? errorMessage;
    try {
      await ListService.createEmptyList(
          name: title, iconCodePoint: selectedIconCodePoint);
      navigator.push(
        MaterialPageRoute(builder: (_) => ListPage(listName: title)),
      );
    } on EmptyInputError catch (_) {
      errorMessage = appLocalizations!.emptyTitleError;
    } on OnlyWhitespaceError catch (_) {
      errorMessage = appLocalizations!.whitespaceTitleError;
    } on AlreadyExistsError catch (e){
      errorMessage = appLocalizations!.itemAlreadyExits(e.toString());
    } catch (e) {
      errorMessage = e.toString();
    }

    if (errorMessage != null && mounted) {
      CriticalError(errorMessage: errorMessage).show(context);
    }
  }



  @override
  void dispose() {
    titleInputController.dispose();
    super.dispose();
  }
}
