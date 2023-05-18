
class Photo {
  int? _id;
  String? _imageString;

  Photo(String imageString) {
    _imageString = imageString;
  }

  int get id => _id!;
  String get imageString => _imageString!;

  Map<String, dynamic> toMap() {
    var map = {
      "data": _imageString
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    _id = map["id"];
    _imageString = map["data"];
  }
}