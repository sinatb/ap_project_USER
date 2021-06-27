import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RestaurantComments extends StatefulWidget {
  final List<String> commentIDs;
  RestaurantComments(this.commentIDs)  : super();
  @override
  _RestaurantCommentsState createState() => _RestaurantCommentsState();
}

class _RestaurantCommentsState extends State<RestaurantComments> {

  bool loaded = false;
  var comments = <Comment>[];

  @override
  Widget build(BuildContext context) {
    final shadows = [BoxShadow(blurRadius: 5, spreadRadius: 1, color: Theme.of(context).shadowColor.withOpacity(0.2))];

    if (!loaded) {
      loadAll().then((value) {
        setState(() {
          loaded = true;
        });
      });
    }

    return loaded ? (widget.commentIDs.isEmpty ? buildEmptyMessage() : ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(10),
          child: CommentTile(comment: comments[index], isForOwner: false),
          decoration: BoxDecoration(
            boxShadow: shadows,
          ),
        );
      },
      itemCount: widget.commentIDs.length,
    )) : Center(child: Text('loading...'),);
  }
  buildEmptyMessage() {
    return Center(
      child: Text(Strings.get('restaurant-no-comments')!),
    );
  }

  Future<void> loadAll() async {
    var server = Head.of(context).server;
    for (var id in widget.commentIDs) {
      comments.add(await server.getObjectByID<Comment>(id) as Comment);
    }
    return;
  }
}
