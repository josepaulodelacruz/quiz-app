import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Article extends Equatable {
  final int? id;
  final int? authorId;
  final String? author;
  final String? articleTitle;
  final String? coverPhoto;
  final List<Tag>? tags;
  final Category? category;
  final String? articleContent;
  final String? date;
  final int? views;

  const Article({
    this.id,
    this.authorId,
    this.author,
    this.articleTitle,
    this.coverPhoto,
    this.tags,
    this.articleContent,
    this.date,
    this.views,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': authorId,
      'author': author,
      'article_title': articleTitle,
      'cover_photo': coverPhoto,
      'tags': [...tags ?? []].map((tag) {
        return tag.toMap();
      }).toList(),
      'article_content': articleContent,
      'created_at': date,
      'views': views,
      'category': category!.toMap(),
    };
  }

  static const empty = Article();

  factory Article.fromMap(Map<String, dynamic> map) {
    List<Tag> tags = <Tag>[];
    map['tags'].map((tag) {
      tags.add(Tag(name: tag['name']));
    }).toList();
    return Article(
      id: map['id'],
      authorId: map['author_id'],
      author: map['author'],
      articleTitle: map['article_title'],
      coverPhoto: map['cover_photo'],
      tags: tags,
      articleContent: map['article_content'],
      date: map['created_at'],
      views: map['views'],
      category: Category.fromMap(map['category']),
    );
  }

  @override
  List<Object> get props => [];

}

class Category {
  int? id;
  String? name;
  String? icon;

  Category({this.id, this.name, this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String,dynamic>map) {
    var model = Category();
    model.id = map['id'];
    model.name = map['name'];
    model.icon = map['icon'];
    return model;
  }
}

class Tag {
  String? name;
  String? icon;

  Tag({
    this.name,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    var model = Tag();
    model.name = map['name'];
    model.icon = map['icon'];
    return model;
  }
}