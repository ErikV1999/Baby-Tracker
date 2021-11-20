import 'package:flutter/material.dart';

class Milestones extends StatefulWidget {
  const Milestones({Key? key}) : super(key: key);

  @override
  _MilestonesState createState() => _MilestonesState();
}

class _MilestonesState extends State<Milestones> {
  late Color activeColor;
  late String selectedTitle = '';
  int currentSelection = -1;
  List<String> titles = ['First steps', 'Said mama', 'Said dada', 'Slept through the night',
                          'First word', 'Crawls', 'Stands up', 'First tooth', 'Holds head steady'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milestones'),
        actions: [
          IconButton(
              onPressed: () {Navigator.pop(context, selectedTitle);},
              icon: Icon(Icons.check),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Container(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  style: TextStyle(fontSize: 32),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:  BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 2,
                          style: BorderStyle.solid,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),

                    hintText: 'Other Title',
                  ),
                  onChanged: (val) {
                    setState(() {
                      selectedTitle = val;
                      currentSelection = -1;
                    });
                  },
                ),
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return CardWidget(title: titles[index], selected: index == currentSelection,
                    onSelect: () {
                      setState(() {
                        currentSelection = index;
                        selectedTitle = titles[index];
                      });
                    },
                  );
                }
                ),
          ],
        ),
      ),
    );
  }
}


class CardWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onSelect;
  const CardWidget({Key? key, required this.title, required this.selected, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color cardColor;
    if(selected == true)
      cardColor = Colors.blue;
    else
      cardColor = Theme.of(context).cardColor;

    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 95,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          onSelect();
        },
        child: Card(
          color: cardColor,
          child: Text(
            title,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
