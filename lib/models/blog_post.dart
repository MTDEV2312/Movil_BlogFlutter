class BlogPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorEmail;
  final String location;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Review> reviews;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorEmail,
    required this.location,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    this.reviews = const [],
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String,
      authorEmail: json['author_email'] as String,
      location: json['location'] as String,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((r) => Review.fromJson(r))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorId,
      'author_email': authorEmail,
      'location': location,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Review {
  final String id;
  final String postId;
  final String authorId;
  final String authorEmail;
  final String content;
  final int rating;
  final DateTime createdAt;
  final List<ReviewReply> replies;

  Review({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorEmail,
    required this.content,
    required this.rating,
    required this.createdAt,
    this.replies = const [],
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      authorEmail: json['author_email'] as String,
      content: json['content'] as String,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['created_at']),
      replies:
          (json['review_replies'] as List<dynamic>?)
              ?.map((r) => ReviewReply.fromJson(r))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'author_id': authorId,
      'author_email': authorEmail,
      'content': content,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ReviewReply {
  final String id;
  final String reviewId;
  final String authorId;
  final String authorEmail;
  final String content;
  final DateTime createdAt;

  ReviewReply({
    required this.id,
    required this.reviewId,
    required this.authorId,
    required this.authorEmail,
    required this.content,
    required this.createdAt,
  });

  factory ReviewReply.fromJson(Map<String, dynamic> json) {
    return ReviewReply(
      id: json['id'] as String,
      reviewId: json['review_id'] as String,
      authorId: json['author_id'] as String,
      authorEmail: json['author_email'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review_id': reviewId,
      'author_id': authorId,
      'author_email': authorEmail,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
