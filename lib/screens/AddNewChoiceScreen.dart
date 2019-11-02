import 'package:flutter/material.dart';
import 'package:flutter_mobx_example/stores/choice.dart';
import 'package:flutter_mobx_example/widgets/AddQuestionDialog.dart';

class AddNewChoiceScreen extends StatefulWidget {
  final Choice choice;
  final List<String> categoryList;

  const AddNewChoiceScreen({Key key, this.choice, this.categoryList})
      : super(key: key);

  @override
  _AddNewChoiceScreenState createState() => _AddNewChoiceScreenState();
}

class _AddNewChoiceScreenState extends State<AddNewChoiceScreen> {
  TextEditingController _answerController = TextEditingController();
  List<String> _categoryList = [];
  String _selectedCategory;

  @override
  void initState() {
    super.initState();
    setState(() {
      _categoryList.addAll(widget.categoryList);
    });

    if (widget.choice == null) {
      print("Add new");
    } else {
      print("Edit existing");
      setState(() {
        _answerController.text = widget.choice.answer;
        _selectedCategory = widget.choice.category;
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem> _dropdownMenuItems() {
    return _categoryList
        .map((category) =>
            DropdownMenuItem(value: category, child: Text(category)))
        .toList();
  }

  Widget _buildForm() {
    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Text(
                "Question: ",
                style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
              Container(width: 16.0),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: _dropdownMenuItems(),
                  // items: _dropdownMenuItems(categoryList),
                  onChanged: (value) {
                    // setSelectedCategory(value);
                    print(value);
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
            ],
          ),
          RaisedButton(
            child: Text("Add a new question"),
            onPressed: () async {
              final String newQuestion = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return AddQuestionDialog();
                    return AddQuestionDialog(list: _categoryList);
                  });
              if (newQuestion != null) {
                setState(() {
                  _categoryList.add(newQuestion);
                  _selectedCategory = newQuestion;
                });
              }
            },
          ),
          Container(height: 32.0),
          Text(
            "What is your answer?",
            style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
          ),
          Container(height: 14.0),
          TextField(
            onChanged: (value) {
              setState(() {
                // _answer = value;
                _answerController.text = value;
                _answerController.selection = TextSelection.collapsed(
                    offset: _answerController.text.length);
              });
            },
            controller: _answerController,
            decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: 'Your Answer...',
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 21.0,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Choice"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (widget.choice?.id != null) {
                // editing mode
                Navigator.pop(
                    context,
                    Choice(
                        id: widget.choice.id,
                        answer: _answerController.text,
                        category: _selectedCategory));
              } else {
                // add new mode
                Navigator.pop(context, {
                  'category': _selectedCategory,
                  'answer': _answerController.text
                });
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
      body: _buildForm(),
    );
  }
}
