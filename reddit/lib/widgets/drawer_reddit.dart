import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:reddit/widgets/desktop_layout.dart';

var communites = ["r/foudzz", "r/badrrr", "r/mohy"];

class DrawerReddit extends StatefulWidget {
  final int indexOfPage;
  final bool inHome;

  const DrawerReddit(
      {super.key,
      required this.indexOfPage,
      required this.inHome});

  @override
  State<DrawerReddit> createState() => _DrawerRedditState();
}

class _DrawerRedditState extends State<DrawerReddit> {
  bool userMod = false;
  var userModList = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Drawer(
          elevation: 0,
          width: 220,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              widget.inHome
                  ? ListTile(
                      leading: Icon(
                          widget.indexOfPage == 0
                              ? Icons.home_filled
                              : Icons.home_outlined,
                          color: Colors.black),
                      title: const Text("Home"),
                      onTap: () {
                        if(widget.indexOfPage == 0)
                        {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 0,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 0,)),
                        ));
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 0,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 0,)),
                        ));

                        }
                      },
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              widget.inHome
                  ? ListTile(
                      leading: Icon(
                          widget.indexOfPage == 1
                              ? CupertinoIcons.arrow_up_right_circle_fill
                              : CupertinoIcons.arrow_up_right_circle,
                          color: Colors.black),
                      title: const Text("Popular"),
                      onTap: () {
                        if(widget.indexOfPage == 1)
                        {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 1,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 1,)),
                        ));
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 1,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 1,)),
                        ));

                        }
                      },
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              widget.inHome
                  ? ListTile(
                      leading: Icon(
                          widget.indexOfPage == 2
                              ? CupertinoIcons.graph_circle_fill
                              : CupertinoIcons.graph_circle,
                          color: Colors.black),
                      title: const Text("All"),
                      onTap: () {
                        if(widget.indexOfPage == 2)
                        {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 2,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 2,)),
                        ));
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 2,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 2,)),
                        ));

                        }
                      },
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              widget.inHome
                  ? ListTile(
                      leading: Icon(
                          widget.indexOfPage == 3
                              ? Icons.watch_later
                              : Icons.watch_later_outlined,
                          color: Colors.black),
                      title: const Text("Latest"),
                      onTap: () {
                        if(widget.indexOfPage == 3)
                        {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 3,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 3,)),
                        ));
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                              mobileHomePage: MobileLayout(
                                mobilePageMode: 3,
                              ),
                              desktopHomePage: DesktopHomePage(indexOfPage: 3,)),
                        ));

                        }
                      },
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              const Divider(
                color: Colors.grey,
                height: 30,
                indent: 30,
                endIndent: 30,
              ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.black),
                title: const Text("Create Communities"),
                onTap: () {
                  //navigate to Create Community Page
                },
              ),
              DropdownButton(
                isExpanded: true,
                padding: const EdgeInsets.all(8.0),
                underline: const SizedBox(),
                hint: const Text(
                  "Communities",
                  textAlign: TextAlign.justify,
                ),
                items: communites
                    .map((community) => DropdownMenuItem<String>(
                        value: community,
                        onTap: () {
                          //navigate to community
                        },
                        child: Text(community)))
                    .toList(),
                onChanged: (test) {}, //to be changedd
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              userMod
                  ? DropdownButton(
                      isExpanded: true,
                      padding: const EdgeInsets.all(8.0),
                      underline: const SizedBox(),
                      hint: const Text(
                        "Moderations",
                        textAlign: TextAlign.justify,
                      ),
                      items: userModList
                          .map((modCommunity) => DropdownMenuItem<String>(
                              value: modCommunity,
                              onTap: () {
                                //navigate to community
                              },
                              child: Text(modCommunity)))
                          .toList(),
                      onChanged: (test) {}, //to be changedd
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    )
                  : const SizedBox()
            ],
          )),
    );
  }
}
