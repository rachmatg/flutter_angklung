import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class SoundsMap {
  int dicesSoundId;
  int dicesStreamId;
  int dicesSoundFromUriId;
  double volume = 1.0;
  bool playing = false;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  List<Soundpool> soundpools = [];
  Map<Soundpool, SoundsMap> soundsMap;
  Soundpool _selectedPool;
  int soundId;
  double last_x=0, last_y=0, last_z =0;
  int  lastupdate =DateTime.now().millisecondsSinceEpoch;
  int SHAKE_THRESHOLD = 800;


  Future<Null> initSoundsForPool(Soundpool pool, SoundsMap sounds) async {
    print("Loading sounds for pool ${pool.streamType}...");
    sounds.dicesSoundId =
    await rootBundle.load("sounds/a4-angklung.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    return;
  }


  void _incrementCounter() async {
    soundId = await rootBundle.load("sounds/a4-angklung.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    print(soundId);
    setState(() {
    });
  }

  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _incrementCounter();
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
     // print ("getar");
      int curTime = DateTime.now().millisecondsSinceEpoch;
      if ((curTime - lastupdate) > 100) {
        int diffTime = (curTime - lastupdate);
        lastupdate = curTime;

        double x = event.x;
        double y = event.y;
        double z = event.z;
        double speed = (x+y+z - last_x - last_y - last_z).abs() / diffTime * 10000;
        if (speed > SHAKE_THRESHOLD) {
          print("SHAKE");
          playSound();
        }
        last_x = x;
        last_y = y;
        last_z = z;

      }

     // print(event.toString());
//      playSound();
      setState(() {
        //acceleration = event;
      });

    });
/*    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
          //playSound();
      print ("getar");
      setState(() {
        //_accelerometerValues = <double>[event.x, event.y, event.z];

      });
    }).onError((error){}));*/
    /*    soundpools =
        StreamType.values.map((type) => Soundpool(streamType: type)).toList();
    soundsMap = Map.fromEntries(
        soundpools.map((soundpool) => MapEntry(soundpool, SoundsMap())));
    Future.wait(
        soundpools.map((pool) => initSoundsForPool(pool, soundsMap[pool])))
        .then((_) {
      setState(() {
        _selectedPool = soundpools[1];
      });
    });*/
  }

  Future<void> playSound() async {
    //print (soundsMap.toString());
/*    if (soundsMap[_selectedPool].dicesSoundId > -1) {
      if (soundsMap[_selectedPool].dicesStreamId != null) {
        await _selectedPool.resume(soundsMap[_selectedPool].dicesStreamId);

        print("Resume sound with stream id: $soundsMap[_selectedPool].dicesStreamId");
        soundsMap[_selectedPool].dicesStreamId = null; /**/
      } else {
        int streamId = soundsMap[_selectedPool].dicesStreamId =*/
//        await _selectedPool.play(soundsMap[_selectedPool].dicesSoundId);
        print (soundId);
        await pool.play(soundId);
//            repeat: 0);
//        soundsMap[_selectedPool].playing = true;
//        print("Playing sound with stream id: $streamId");
      //}
    //}
    setState(() {//_selectedPool = soundpools[_selectedIndex];
    //soundsMap[_selectedPool].playing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { playSound().then((_){print("selesai.");});
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
