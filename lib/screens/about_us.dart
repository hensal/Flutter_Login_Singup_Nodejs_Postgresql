import 'package:flutter/material.dart';
import 'package:flutter_about_page/flutter_about_page.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {

    AboutPage ab = AboutPage();
    ab.customStyle(descFontFamily: "Roboto",listTextFontFamily: "RobotoMedium");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("About Page"),
        centerTitle: true,
      ),
      body: ListView(

        children: [

         // ab.setImage("assets/logo.png"),
          ab.addDescription(" Nullam elit magna, blandit vitae feugiat vel, "),
          ab.addWidget(
            const Text(
              "Version 1.2",
              style: TextStyle(
                  fontFamily: "RobotoMedium"
              ),
            ),
          ),
          ab.addGroup("Connect with us"),
          ab.addEmail("lackminds20@gmail.com"),
          ab.addFacebook("sulav.parajuli.90"),
          ab.addTwitter("sulav"),
          ab.addYoutube("UCeVMnSShP_Iviwkknt83cww"),
          ab.addPlayStore("com.tripline.radioapp"),
          ab.addGithub("npsulav"),
          ab.addInstagram("sulav"),
          ab.addWebsite("http://www.facebook.com"),
          ab.addItemWidget(Icon(Icons.add), "title")

        ],
      )
    );
  }
}