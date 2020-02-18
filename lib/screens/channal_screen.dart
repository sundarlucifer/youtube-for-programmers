import 'package:flutter/material.dart';
import 'package:youtube_flutter/models/channel_model.dart';
import 'package:youtube_flutter/models/video_model.dart';
import 'package:youtube_flutter/screens/video_screen.dart';
import 'package:youtube_flutter/services/api_service.dart';

class ChannelScreen extends StatefulWidget {
  final Channel channel;

  ChannelScreen({this.channel});

  @override
  _ChannelScreenState createState() => _ChannelScreenState(channel: channel);
}

class _ChannelScreenState extends State<ChannelScreen> {
  Channel channel;
  bool _isLoading = false;

  _ChannelScreenState({this.channel});

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 120.0,
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(channel.profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  channel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${channel.subscriberCount} subscribers',
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
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
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
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    setState(() {
      _isLoading = true;
    });
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId);
    List<Video> allVideos = channel.videos..addAll(moreVideos);
    setState(() {
      channel.videos = allVideos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channel.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (!_isLoading &&
              channel.videos.length != int.parse(channel.videoCount) &&
              scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent) {
            _loadMoreVideos();
          }
          return false;
        },
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: 1 + channel.videos.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildProfileInfo();
                }
                Video video = channel.videos[index - 1];
                return _buildVideo(video);
              },
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Center(),
          ],
        ),
      ),
    );
  }
}
