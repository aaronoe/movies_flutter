import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/util/navigator.dart';
import 'package:movies_flutter/widgets/media_list/media_list.dart';
import 'package:movies_flutter/widgets/utilviews/toggle_theme_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;
  MediaType mediaType = MediaType.movie;

  final MediaProvider movieProvider = MovieProvider();
  final MediaProvider showProvider = ShowProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          const ToggleThemeButton(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => goToSearch(context),
          )
        ],
        title: const Text("Cinematic"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    const Color(0xff2b5876),
                    const Color(0xff4e4376),
                  ])),
                )),
            ListTile(
              title: const Text("Search"),
              trailing: const Icon(Icons.search),
              onTap: () => goToSearch(context),
            ),
            ListTile(
              title: const Text("Favorites"),
              trailing: const Icon(Icons.favorite),
              onTap: () => goToFavorites(context),
            ),
            const Divider(
              height: 5.0,
            ),
            ListTile(
              title: const Text("Movies"),
              selected: mediaType == MediaType.movie,
              trailing: const Icon(Icons.local_movies),
              onTap: () {
                _changeMediaType(MediaType.movie);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text("TV Shows"),
              selected: mediaType == MediaType.show,
              trailing: const Icon(Icons.live_tv),
              onTap: () {
                _changeMediaType(MediaType.show);
                Navigator.of(context).pop();
              },
            ),
            const Divider(
              height: 5.0,
            ),
            ListTile(
              title: const Text("Close"),
              trailing: const Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
      body: PageView(
        children: _getMediaList(),
        pageSnapping: true,
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _page = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _getNavBarItems(),
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
      });
    }
  }

  List<BottomNavigationBarItem> _getNavBarItems() {
    if (mediaType == MediaType.movie) {
      return [
        const BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), title: Text('Popular')),
        const BottomNavigationBarItem(
            icon: Icon(Icons.update), title: Text('Upcoming')),
        const BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Top Rated')),
      ];
    } else {
      return [
        const BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), title: Text('Popular')),
        const BottomNavigationBarItem(
            icon: Icon(Icons.live_tv), title: Text('On The Air')),
        const BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Top Rated')),
      ];
    }
  }

  List<Widget> _getMediaList() {
    return (mediaType == MediaType.movie)
        ? <Widget>[
            MediaList(
              movieProvider,
              "popular",
              key: const Key("movies-popular"),
            ),
            MediaList(movieProvider, "upcoming", key: const Key("movies-upcoming")),
            MediaList(movieProvider, "top_rated", key: const Key("movies-top_rated")),
          ]
        : <Widget>[
            MediaList(showProvider, "popular", key: const Key("shows-popular")),
            MediaList(showProvider, "on_the_air", key: const Key("shows-on_the_air")),
            MediaList(showProvider, "top_rated", key: const Key("shows-top_rated")),
          ];
  }

  void _navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
