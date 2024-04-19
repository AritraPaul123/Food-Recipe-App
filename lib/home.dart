import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foodrecipe_app/model.dart';
import 'package:foodrecipe_app/search.dart';
import 'package:http/http.dart' as http;
import 'package:foodrecipe_app/recipeview.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading=true;
  List recipecatlist=[{"img" : "https://th.bing.com/th/id/OIP.T3ULhba0sD0JT7IYw2vEwwHaKO?rs=1&pid=ImgDetMain","label": "Spicy Food"},
    {"img" : "https://www.licious.in/blog/wp-content/uploads/2020/12/Chicken-Curry-recipe.jpg","label": "Chicken Curry"},
    {"img" : "https://images.unsplash.com/photo-1561150169-371f366b828a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80","label": "Alcohol "},
    {"img" : "https://th.bing.com/th/id/OIP.T3ULhba0sD0JT7IYw2vEwwHaKO?rs=1&pid=ImgDetMain","label": "Ice Cream"},
    {"img" : "https://th.bing.com/th/id/OIP.T3ULhba0sD0JT7IYw2vEwwHaKO?rs=1&pid=ImgDetMain","label": "Beverages"}];
  late String urlholder;
  List<RecipeModel> recipelist=<RecipeModel>[];
  TextEditingController searchcontroller= new TextEditingController();

  getrecipe(String query) async {
    dynamic url = "https://api.edamam.com/search?q=$query&app_id=45d30185&app_key=c753896b73f70c3132154e30a4296b1e";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    var data = jsonDecode(response.body);
    data["hits"].forEach((element){
      RecipeModel recipeModel=new RecipeModel();
      recipeModel=RecipeModel.fromMap(element["recipe"]);
      recipelist.add(recipeModel);
      log(recipelist.toString());
    });
    setState(() {
      isLoading=false;
    });
    recipelist.forEach((element) {
      print(element.applabel);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getrecipe("Chicken");
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
                gradient: LinearGradient(
                    colors: [
                      Colors.orangeAccent,
                      Colors.red,
                    ]
                )
            ),
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
                    child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: TextField(
                                controller: searchcontroller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Any Recipe",
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: GestureDetector(
                              onTap: () {
                                if((searchcontroller.text).replaceAll(" ", "")!="") {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(searchcontroller.text)));
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
                ),//searchbar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Text("What do you want to cook today?",style: TextStyle(fontSize: 30,color: Colors.white),),
                      SizedBox(height: 10,),
                      Text("Let's cook something new",style: TextStyle(fontSize: 20,color: Colors.white),)
                    ],
                  ),
                ),
                Container(
                  child: isLoading ? CircularProgressIndicator() : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipelist.length,
                      itemBuilder: (context,index){

                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Recipeview(recipelist[index].applurl)));
                          } ,
                          child: Card(
                            margin: EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            elevation: 0.0,
                            child: Stack(
                              children: [

                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                          Image.network(recipelist[index].appimgurl,fit: BoxFit.cover,width: double.infinity,height: 220,)

                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child:
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.black54
                                      ),
                                      child: Text(recipelist[index].applabel,style: TextStyle(color: Colors.white,fontSize: 19),),
                                    )
                                ),
                                Positioned(
                                    height: 29,
                                    width: 75,
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white60
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.local_fire_department),
                                          Text(recipelist[index].appcalories.toString().substring(0,6)),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  height: 70,
                  child: ListView.builder(
                      itemCount: recipecatlist.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return Container(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Search(recipecatlist[index]["label"])));
                              },
                              child: Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(recipecatlist[index]["img"],fit: BoxFit.cover,width: 180,height: 150,),
                                    ),
                                    Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        top: 0,
                                        child:
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(recipecatlist[index]["label"],style: TextStyle(fontSize: 20,color: Colors.white),)
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            )
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
