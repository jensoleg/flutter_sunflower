import 'package:flutter/material.dart';

void main() {
  runApp(
    new MaterialApp(
      title: "Flutter Debugger",
      routes: {
        // TODO: route is the isolate? isolate+frame?
        Navigator.defaultRouteName: (_) => new DebuggerDemo()
      }
    )
  );
}

class DebuggerDemo extends StatefulComponent {
  DebuggerState createState() => new DebuggerState();
}

class DebuggerState extends State<DebuggerDemo> {
  DebuggerState();

  final TabBarSelection _selection = new TabBarSelection(maxIndex: 1);

  double listScrollPos = 0.0;

  Widget build(BuildContext context) {
    return new Scaffold(
      toolBar: new ToolBar(
        center: new Text("main()"),
        right: <Widget>[
          new IconButton(
            icon: 'navigation/more_vert',
            onPressed: () {
              _toggleFPS();
              // showMenu(
              //   context: context,
              //   // TODO: How to position this better?
              //   position: new ModalPosition(
              //     top: 48.0,
              //     right: 0.0
              //   ),
              //   items: [
              //     new PopupMenuItem(
              //       child: new Text('Foo'),
              //       value: 'Foo'
              //     ),
              //     new PopupMenuItem(
              //       child: new Text('Bar'),
              //       value: 'Bar'
              //     )
              //   ]
              // );
            }
          )
        ],
        tabBar: new TabBar(
          labels: [
            new TabLabel(text: 'SOURCE'),
            new TabLabel(text: 'LOCALS')
          ],
          selection: _selection
        )
      ),
      body: new TabBarView<int>(
        selection: _selection,
        items: [0, 1],
        itemBuilder: (BuildContext context, int page, int index) {
          if (page == 0) {
            return new Container(
              child: new ScrollableViewport(
                child: new Text(
                  createLoremIpsum(4),
                  style: new TextStyle(fontFamily: 'monospace')
                )
              ),
              padding: const EdgeDims.all(12.0)
            );
          } else {
            return new Container(
              child: new MaterialList(
                items: ['this', 'widgetCount', 'elements'],
                itemBuilder: (BuildContext context, String item, int index) {
                  return new Text(
                    item,
                    key: new ObjectKey(item)
                  );
                },
                initialScrollOffset: listScrollPos,
                onScroll: (double scrollOffset) {
                  listScrollPos = scrollOffset;
                },
                type: MaterialListType.oneLineWithAvatar
              ),
              padding: const EdgeDims.all(12.0)
            );
          }
        }
      ),
      drawer: _buildDrawer(),
      floatingActionButton: new Row([
        new FloatingActionButton(
          child: new Icon(icon: 'navigation/expand_more'),
          onPressed: () => print('step in'),
          mini: true
        ),
        new Padding(
          child: new FloatingActionButton(
            child: new Icon(icon: 'navigation/expand_less'),
            onPressed: () => print('step out'),
            mini: true
          ),
          padding: new EdgeDims.symmetric(horizontal: 16.0)
        ),
        new FloatingActionButton(
          child: new Icon(icon: 'navigation/chevron_right'),
          onPressed: () {
            print('step over');
          }
        )
      ],
      justifyContent: FlexJustifyContent.end
    ));
  }

  Widget _buildDrawer() {
    List<Widget> items = <Widget>[
      new DrawerHeader(child: new Text('Isolate/0')),
    ];

    for (String str in ['Foo.bar()', 'baz()', 'main()']) {
      items.add(new DrawerItem(
        // onPressed: () {
        //   Navigator.pushNamed(context, demo.routeName);
        // },
        child: new Text(str),
        selected: str == 'main()'
      ));
    }

    return new Drawer(child: new Block(items));
  }

  OverlayEntry frameStats;

  void _toggleFPS() {
    OverlayState overlay = Overlay.of(context);
    if (frameStats != null) {
      frameStats.remove();
      frameStats = null;
    } else {
      frameStats = new OverlayEntry(builder:_buildStatiticsOverlay);
      overlay.insert(frameStats);
    }
  }

  Widget _buildStatiticsOverlay(BuildContext context) {
    return new StatisticsOverlay.allEnabled();
  }
}

final String loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing "
    "elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
    "ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit"
    " in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur"
    " sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt "
    "mollit anim id est laborum.";

String createLoremIpsum(int paragraphs) {
  return new List.filled(paragraphs, loremIpsum).join('\n\n');
}
