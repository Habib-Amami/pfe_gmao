import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditableRowWithSlidable extends StatelessWidget {
  final String title;
  final double titleContentSeperator;
  final String content;
  final TextStyle? contentStyle;
  final Function(BuildContext) onEditPressed;

  const EditableRowWithSlidable({
    required this.title,
    this.contentStyle,
    required this.content,
    required this.titleContentSeperator,
    required this.onEditPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          dragDismissible: true,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              onPressed: (context) {
                onEditPressed(context);
              },
              icon: Icons.edit_outlined,
              label: "Edit",
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (contextFromLayoutBuilder, constraints) => Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: titleContentSeperator,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(content),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                onPressed: () =>
                    Slidable.of(contextFromLayoutBuilder)?.openStartActionPane(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
