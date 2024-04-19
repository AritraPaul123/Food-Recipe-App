import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodrecipe_app/model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:foodrecipe_app/recipeview.dart';

class Search extends StatefulWidget {
  late String query;
  Search(this.query);
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isLoading = true;
  List<RecipeModel> recipelist = <RecipeModel>[];
  TextEditingController searchcontroller = new TextEditingController();

  getrecipe(String query) async {
    dynamic url =
        "https://api.edamam.com/search?q=$query&app_id=45d30185&app_key=c753896b73f70c3132154e30a4296b1e";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    var data = jsonDecode(response.body);
    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipelist.add(recipeModel);
      log(recipelist.toString());
    });
    setState(() {
      isLoading = false;
    });
    recipelist.forEach((element) {
      print(element.applabel);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getrecipe(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orangeAccent,
                  Colors.red,
                ])),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black12,
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: searchcontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search New Recipe",
                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: GestureDetector(
                          onTap: () {
                            if ((searchcontroller.text).replaceFirst(" ", "") !=
                                "") {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Search(searchcontroller.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.lightBlue[900],
                              size: 38,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 7, 11, 7),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ), //searchbar
                Container(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(strokeAlign: BorderSide.strokeAlignCenter,))
                      : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipelist.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Recipeview(recipelist[index].applurl)));
                          },
                          child: Card(
                            margin: EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 0.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      recipelist[index].appimgurl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 220,
                                    )),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          color: Colors.black54),
                                      child: Text(
                                        recipelist[index].applabel,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19),
                                      ),
                                    )),
                                Positioned(
                                    height: 29,
                                    width: 75,
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: Colors.white60),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.local_fire_department),
                                          Text(recipelist[index]
                                              .appcalories
                                              .toString()
                                              .substring(0, 6)),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
