import 'package:flutter/material.dart';
import 'package:flutter_websockets/NestedScrollViewTest.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _messageController = TextEditingController();
  final WebSocketChannel channel = IOWebSocketChannel.connect('wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self');
  List<String> messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        print("init called");
    channel.stream.listen((event) {
      setState(() {
        print(event);
        messages.add(event.toString());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose called");
    channel.sink.close();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NestedScrollViewTest()));
          }, icon: Icon(Icons.next_plan))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _messageController,
                onFieldSubmitted: (message){
                  _sendMessage();
                },
                decoration: InputDecoration(
                  hintText: "Your Message",
                  border: UnderlineInputBorder()),
                
              ),
              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height * 0.70,
                child: _getMessagesListView(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage(){
    channel.sink.add(_messageController.text);
    _messageController.clear();
  }

  _getMessagesListView (){
    List<Widget> messageWidget = [];

    for(var msg in messages){
      messageWidget.add(
        ListTile(title: Text(msg),)
      );
    }

    return ListView(children: messageWidget,);
  }
}
