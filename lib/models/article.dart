import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rte_app/models/author.dart';

class Article extends Equatable {
  final int? id;
  final Author author;
  final String? articleTitle;
  final String? coverPhoto;
  final List<Tag>? tags;
  final List<dynamic>? viewedUsers;
  final Category? category;
  final String? articleContent;
  final String? date;
  final bool? isLike;
  final bool? isSaved;
  final int? views;
  final int? saves;
  final int? likes;

  const Article({
    this.id,
    this.author = Author.empty,
    this.articleTitle,
    this.coverPhoto,
    this.tags,
    this.viewedUsers,
    this.articleContent,
    this.date,
    this.views,
    this.saves,
    this.likes,
    this.category,
    this.isLike = false,
    this.isSaved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'article_title': articleTitle,
      'cover_photo': coverPhoto,
      'tags': [...tags ?? []].map((tag) {
        return tag.toMap();
      }).toList(),
      'article_preview': articleContent,
      'created_at': date,
      'views': views,
      'likes': likes,
      'saves': saves,
      'category': category!.toMap(),
      'is_liked': isLike,
      'is_saved': isSaved,
    };
  }

  static const empty = Article(category: Category.empty, tags: []);

  factory Article.fromMap(Map<String, dynamic> map) {
    List<Tag> tags = <Tag>[];
    if(map['tags'] != null) {
      map['tags'].map((tag) {
        tags.add(Tag(name: tag['name']));
      }).toList() ?? [];
    }

    return Article(
      id: map['id'],
      author: Author.fromMap(map['author']),
      articleTitle: map['article_title'],
      coverPhoto: map['cover_photo'],
      tags: tags,
      viewedUsers: map['user_viewed_article'] ?? [],
      articleContent: map['article_preview'],
      date: map['created_at'],
      views: map['views'],
      likes: map['likes'],
      saves: map['saves'],
      isLike: map['is_liked'] == 0 ? false : true,
      isSaved: map['is_saved'] == 0 ? false : true,
      category: map['category'] != null ? Category.fromMap(map['category']) : null,
    );
  }

  Article copyWith({
      int? id,
      String? articleTitle,
      String? coverPhoto,
      String? articleContent,
      String? date,
      int? views,
      int? likes,
      int? saves,
      bool? isLike,
      bool? isSaved,
      Category? category,
      List<Tag>? tags,
     }) {
    return Article(
      id: id ?? this.id,
      articleTitle: articleTitle ?? this.articleTitle,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      articleContent: articleContent ?? this.articleContent,
      date: date ?? this.date,
      views: views ?? this.views,
      likes:  likes ?? this.likes,
      saves: saves ?? this.saves,
      isLike: isLike ?? this.isLike,
      isSaved: isSaved ?? this.isSaved,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
    id,
    author,
    articleTitle,
    coverPhoto,
    tags,
    articleContent,
    date,
    views,
    likes,
    saves,
    isLike,
    isSaved,
    category,
  ];

  bool checkIfNull () {
    return [id, author, articleTitle, coverPhoto, tags, articleTitle, date, views, likes, saves, isLike, isSaved, category].isEmpty;
  }

}

class Category {
  final int? id;
  final String? name;
  final String? icon;

  const Category({this.id, this.name, this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  static const empty = Category();

  factory Category.fromMap(Map<String,dynamic>map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
    );
  }
}

class Tag {
  final String? name;
  final String? icon;

  const Tag({
    this.name,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
    };
  }

  static const empty = Tag();

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      name: map['name'],
      icon: map['icon'],
    );
  }
}