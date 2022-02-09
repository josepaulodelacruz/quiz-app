import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/blocs/tags/tag_state.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/string_routes.dart';
import 'package:rte_app/common/widgets/chip_widget.dart';
import 'package:rte_app/models/article.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      builder: (context, state) {
        List<Tag> tags = state.tags;
        List<Tag> selectedTag = state.selectedTags;
        if(state.status == TagStatus.loading) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: LinearProgressIndicator()
          );
        } else if(state.status == TagStatus.success) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "Category",
                      style: Theme.of(context).textTheme.headline5!.copyWith(),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, categories_screen, arguments: tags);
                        },
                        child: Text('Filter', style: Theme.of(context).textTheme.subtitle1!.copyWith(color: COLOR_PURPLE))
                    )
                  ],
                ),
              ),
              if(selectedTag.length <= 0) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "No Categories Selected",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: COLOR_PURPLE,
                    ),
                  ),
                )
              ],
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: selectedTag.map((tag) {
                    return ChipWidget(title: tag.name!);
                  }).toList(),
                ),
              )
            ],
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: COLOR_PURPLE,
              ),
            ),
          );
        }
      },
    );
  }
}
