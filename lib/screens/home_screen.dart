import 'package:flutter/material.dart';
import 'package:youtube_flutter/data/data.dart';
import 'package:youtube_flutter/models/channel_model.dart';
import 'package:youtube_flutter/screens/channal_screen.dart';
import 'package:youtube_flutter/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Channel> _channelList = [];

  @override
  void initState() {
    super.initState();
    _getChannels();
  }

  void _getChannels() {
    channelIdList.forEach((channelId) async {
      Channel channel =
          await APIService.instance.fetchChannel(channelId: channelId);
      setState(() {
        _channelList.add(channel);
      });
    });
  }

  _buildProfileInfo(Channel _channel) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelScreen(channel: _channel,),)),
          child: Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 130.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35.0,
              backgroundImage: NetworkImage(_channel.profilePictureUrl),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _channel.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_channel.subscriberCount} subscribers',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube for Programmers'),
      ),
      body: _channelList.length != 0
      ? ListView.builder(
        itemCount: _channelList.length,
        itemBuilder: (context, index) {
          return _buildProfileInfo(_channelList[index]);
        },
      )
      : Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor,
        ),
      ),) 
    );
  }
}
