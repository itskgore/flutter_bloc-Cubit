class Movies {
  int selectedIndex;
  int id;
  String name;
  String permalink;
  String startDate;
  String country;
  String network;
  String status;
  String imageThumbnailPath;

  Movies(
      {this.selectedIndex,
      this.id,
      this.name,
      this.permalink,
      this.startDate,
      this.country,
      this.network,
      this.status,
      this.imageThumbnailPath});

  Movies.fromJson(Map<String, dynamic> json) {
    selectedIndex = 0;
    id = json['id'];
    name = json['name'];
    permalink = json['permalink'];
    startDate = json['start_date'];
    country = json['country'];
    network = json['network'];
    status = json['status'];
    imageThumbnailPath = json['image_thumbnail_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['permalink'] = this.permalink;
    data['start_date'] = this.startDate;
    data['country'] = this.country;
    data['network'] = this.network;
    data['status'] = this.status;
    data['image_thumbnail_path'] = this.imageThumbnailPath;
    return data;
  }
}
