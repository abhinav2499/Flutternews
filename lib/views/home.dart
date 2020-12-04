// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/model.dart';
import 'package:news_app/views/activity_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter',
              style: TextStyle(letterSpacing: 0.5, color: Colors.white),
            ),
            Text(
              'News',
              style: TextStyle(
                color: Colors.blue,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: _loading
          ? Center(child: Container(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    //categories
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 75,
                      child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                                imageUrl: categories[index].imageUrl,
                                catergoryName: categories[index].categoryName);
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'All News',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    //blogtile
                    Container(
                      // padding: EdgeInsets.only(top: 26),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                              imageUrl: articles[index].urlToImage,
                              title: articles[index].title,
                              url: articles[index].url,
                              desc: articles[index].description);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl, catergoryName;

  CategoryTile({this.imageUrl, this.catergoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 16, right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl,
                    width: 120, height: 65, fit: BoxFit.cover)),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 65,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black26),
              child: Text(
                catergoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(imageUrl)),
              // SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)),
              ),
              // SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(desc,
                    style: TextStyle(
                      color: Colors.black54,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
