class ReviewModel {
  String id;
  String name;
  String rating;
  String review;
  String userDp;
  DateTime date;
  ReviewModel(
      {required this.id,
      required this.name,
      required this.rating,
      required this.review,
      required this.userDp,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'id': id,
      "review": review,
      "userDp": userDp,
      "date": date.microsecondsSinceEpoch
    };
  }

  factory ReviewModel.fromMap(Map map) {
    return ReviewModel(
        name: map['name'],
        review: map['review'],
        id: map['Id'],
        date: DateTime.fromMicrosecondsSinceEpoch(
          map['date'],
        ),
        rating: map['rating'],
        userDp: map['userDp']);
  }
}
