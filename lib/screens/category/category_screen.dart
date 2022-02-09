import 'package:flutter/material.dart';
import 'package:rte_app/blocs/tags/tag_bloc.dart';
import 'package:rte_app/blocs/tags/tag_event.dart';
import 'package:rte_app/common/size_config.dart';
import 'package:rte_app/common/widgets/primary_button_widget.dart';
import 'package:rte_app/models/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  final List<Tag> tags;
  const CategoryScreen({Key? key, required this.tags}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> _tags = [];

  @override
  void initState() {
    _tags = widget.tags.map((tag) {
      return {
        'name': tag.name!,
        'selected': false,
      };
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Follow Topics",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w600,
                height: 2,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 30,
                children: _tags.map((tag) {
                  int index = _tags.indexOf(tag);
                  return _cardTopic(tag,
                    onTap: () {
                      _tags[index]['selected'] = !tag['selected'];
                      setState(() {});
                    },
                    elevation: tag['selected'] ? 0 : 3,
                  );
                }).toList(),
              ),
            ),
            PrimaryButtonWidget(
              onPressed: _filtered,
              child: Text(
                "Get Started",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: SizeConfig.blockSizeVertical! * 2.5, color: Colors.white, letterSpacing: 5),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardTopic (Map<String, dynamic>tag, {required Function onTap, double? elevation}) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: elevation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(),
            SizedBox(height: 10),
            Text(
              tag['name']!,
            )
          ],
        ),
      ),
    );
  }

  Future _filtered () async {
    var selectedTags = _tags.where((tag) => tag['selected'] == true);
    context.read<TagBloc>().add(FilterTags(selectedTags: List<Map<String, dynamic>>.from(selectedTags)));
    Navigator.pop(context);
  }
}
