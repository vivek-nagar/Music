import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  final trackDetails, id;

  const DetailsPage({Key key, this.trackDetails, this.id}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoading = false;
var url = Uri.parse("https://your_api_link");
  var api1 =
      Uri.parse("https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
  var api2 =
       Uri.parse("https://api.musixmatch.com/ws/1.1/track.get?track_id=$oneTrackId&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
  var api3 =
      Uri.parse( "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$oneTrackId&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
  var res, lyrics, tracksId;

  static var oneTrackId = "201234497"; //WAP
  //static var trackIdAll = widget.trackDetails[id];
  //var trackDetails = track[index]["track"];
  //track = jsonDecode(res.body)["message"]["body"]["track_list"];
  //static var allId = widget.id.toString();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchTrackId();
    var allId = widget.id.toString();
    print(allId);
  }

  ///for lyrics
  fetchData() async {
    setState(() {
      isLoading = true;
    });
    res = await http.get(api3);
    lyrics = jsonDecode(res.body)["message"]["body"]["lyrics"]["lyrics_body"];
    //print(lyrics.toString());
    setState(() {
      isLoading = false;
    });
  }

  ///for track_id
  fetchTrackId() async {
    setState(() {
      isLoading = true;
    });
    res = await http.get(api2);
    tracksId = jsonDecode(res.body)["message"]["body"]["track"]["track_id"];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      Center(child: CircularProgressIndicator());
    }
    int trackRating = widget.trackDetails["track_rating"];
    String tr = "$trackRating";
    var trackIdAll = widget.trackDetails["track_id"];
    String ids = "$trackIdAll";
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.trackDetails["album_name"]}'),
        backgroundColor: Color(0XFFBD081C),
      ),
      body: lyrics != null
          ? Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListView(
                children: [
                  Text("Track Id -> " + ids),
                  Text("\n"),
                  Text("Track name -> " + widget.trackDetails["track_name"]),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Artist name -> " + widget.trackDetails["artist_name"]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Updated time -> " + widget.trackDetails["updated_time"]),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Track rating -> " + tr),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Lyrics",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(lyrics)
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
