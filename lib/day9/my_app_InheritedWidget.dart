import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_journey/day5/anim/encapsulate/flutter_container.dart';
import 'package:flutter_journey/utils/color_utils.dart';
import 'package:flutter_journey/utils/common_path.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'InheritedWidget Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
   var home= Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            PanelClockWidget(),
          ],
        ),
      ),
      floatingActionButton: CounterButton(),
    );
    return CountData(//使用InheritedWidget包裹需要共享数据的节点
      child: home,
      model: CountModel(_counter,_incrementCounter),//传递数据模型
    );
  }
}

//--------------InheritedWidget使用----------------------------------------------

/// 数据模型
class CountModel {
  final int count;//计数器
  final VoidCallback increment;//增长函数
  const CountModel(this.count,this.increment);
}


class CountData extends InheritedWidget {
  final CountModel model;
  CountData({
    Key key,
    @required this.model,
    @required Widget child,
  }) : super(key: key, child: child);

  static CountData of(BuildContext context) {//提供数据模型方法
    return context.inheritFromWidgetOfExactType(CountData);
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(CountData oldWidget) {
    return model.count != oldWidget.model.count;
  }
}
//-------------------------------------------------------------------------------


//对计数器面板组件进行提取
class PanelClockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var child = Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(3),
        child: CounterWidget(),
        width: 100,
        decoration:
            BoxDecoration(
                color: randomColor(),
                borderRadius: BorderRadius.all(Radius.circular(20))));

    return child;
  }
}

//button
class CounterWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var count=CountData.of(context).model.count;//获取数据
    var text = Text(
      '$count',
      style: Theme.of(context).textTheme.display1,
    );
    var result = Wrap(
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.timer, color: Colors.blue, size: 30,),
        text],
    );
    return FlutterContainer(
      child: result,
      config: AnimConfig(),
    );
  }
}


//对计数器按钮组件进行提取
class CounterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var increment=CountData.of(context).model.increment;//获取数据
    var btn = FloatingActionButton(
      onPressed: increment,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 4,
      shape:StarBorder() ,
    );
    return btn;
  }
}


/// 边线形状类
class StarBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var r=rect.right/2;
    return nStarPath(12, r,r* cos((360 / 9 / 2)*pi / 180),dx: rect.height/2,dy: rect.width/2);
  }
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {

  }

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}