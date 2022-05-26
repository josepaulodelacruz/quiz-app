import 'package:flutter/material.dart';
import 'package:rte_app/blocs/articles/articles_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rte_app/blocs/articles/articles_event.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/models/article.dart';
import 'package:rte_app/models/violation.dart';

class ReportFormWidget extends StatefulWidget {
  final List<Violation> violations;
  final Article article;
  const ReportFormWidget({Key? key, required this.violations, required this.article}) : super(key: key);

  @override
  _ReportFormWidgetState createState() => _ReportFormWidgetState();
}

class _ReportFormWidgetState extends State<ReportFormWidget> {
  TextEditingController reasonText = TextEditingController();
  bool isHide = true;
  late Violation selectedViolation;

  @override
  void initState () {
    super.initState();
    selectedViolation = widget.violations[0];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        content: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Report article",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                Text(
                  "Report an article if you think it violates any of the Community guidelines",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: SizeConfig.blockSizeVertical! * 1.8,
                        color: COLOR_DARK_GRAY,
                      ),
                ),
                SizedBox(height: 20),
                Text(
                  "Reason(optional)",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: SizeConfig.blockSizeVertical! * 1.8,
                    color: COLOR_DARK_GRAY,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: reasonText,
                    maxLines: 3,
                    decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(
                        borderSide: const BorderSide(color: COLOR_DARK_GRAY, width: 2.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: COLOR_DARK_GRAY, width: 2.0),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Select criteria that you think this article violates",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: SizeConfig.blockSizeVertical! * 1.8,
                    color: COLOR_DARK_GRAY,
                  ),
                ),
                DropdownButtonFormField(
                  hint: Text(selectedViolation.violation),
                  items: widget.violations.map((val) {
                    return DropdownMenuItem(
                        value: val,
                        child: Text(val.violation));
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedViolation = v as Violation;
                    });
                  },
                ),
                InkWell(
                  onTap: () {
                    isHide = !isHide;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        value: isHide,
                        onChanged: (val) {
                          isHide = val!;
                          setState(() {});
                        },
                      ),
                      Text(
                        "You want to hide this article?",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: SizeConfig.blockSizeVertical! * 1.8,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ArticlesBloc>().add(ShowViolationList(isShow: false));
            },
            child: Text(
              "Cancel",
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ArticlesBloc>().add(ShowViolationList(isShow: false));
              context.read<ArticlesBloc>().add(ReportArticle(
                id: widget.article.id!,
                violationId: selectedViolation.id,
                reason: reasonText.text,
                hide: isHide,
              ));
              Navigator.pop(context);
            },
            child: Text(
              "Okay",
            ),
          ),
        ],
      ),
    );
  }
}
