import 'package:dr_kirana/services/firebasestorageservice.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  final String imageLocation;
  ImageView({Key key, @required this.imageLocation}) : super(key: key);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        toolbarOpacity: 1,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: FireStorageService.loadImage(context, widget.imageLocation),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Container(
                child: Center(
                    child: CircularProgressIndicator()
                )
            );
          }
          return Container(
            child: PhotoView(
              imageProvider: snapshot.data,
            ),
          );
        },
      ),
    );
  }
}