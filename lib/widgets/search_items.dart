import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class SearchItems extends StatefulWidget {
  @override
  _SearchItemsState createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey
          ),
          color: Colors.black12,
        ),
        height: 50.0,
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search, color: Theme.of(context).primaryColor, size: 30.0,),
//            SizedBox(width: 20.0,),
            Text(
              S .of(context).search_for_product,//"Search for the products...",
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}