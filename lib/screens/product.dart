import 'package:flutter/material.dart';

/*import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(snapshot.data![index]['imageUrl']),
                    title: Text(snapshot.data![index]['name']),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

/*
Future<List> fetchData() async {
  final response = await http
      .get(Uri.parse('https://www.takuwa.co.jp/en/solution/index.html#1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // You would need to parse the HTML content and extract the data you need manually
    return [];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}*/

Future<List> fetchData() async {
  final response = await http
      .get(Uri.parse('https://www.takuwa.co.jp/en/solution/index.html#1'));

  if (response.statusCode == 200) {
    // Parse the HTML into a Document object
    var document = parse(response.body);
    
    // Find the specific elements you need (e.g. images, names, etc)
    var images = document.getElementsByTagName('img');
    var names = document.getElementsByClassName('name-class');
    
    // Extract the data from the elements
    var imageUrls = [];
    for (var image in images) {
      imageUrls.add(image.attributes['src']);
    }
    
    var nameList = [];
    for (var name in names) {
      nameList.add(name.text);
    }
    
    // Return the extracted data
    return [imageUrls, nameList];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}
*/
