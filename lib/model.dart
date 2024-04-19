class RecipeModel {
  late String applabel;
  late String appimgurl;
  late double appcalories;
  late String applurl;
  late String listofall;

  RecipeModel({ this.appcalories=0.0, this.applabel="LABEL", this.appimgurl="IMG", this.applurl="URL"});

  factory RecipeModel.fromMap(Map recipe)
  {
    return RecipeModel(

        applabel: recipe["label"],
        appimgurl: recipe["image"],
        appcalories: recipe["calories"],
        applurl: recipe["url"]

    );
  }
}





