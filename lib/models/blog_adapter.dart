import 'package:hive_flutter/hive_flutter.dart';
import './blog_model.dart';

class BlogAdapter extends TypeAdapter<Blog> {
  @override
  final typeId = 0;

  @override
  Blog read(BinaryReader reader) {
    return Blog(
      id: reader.read(),
      title: reader.read(),
      imageUrl: reader.read(),
      isFavorite: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Blog obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.imageUrl);
    writer.write(obj.isFavorite);
  }
}
