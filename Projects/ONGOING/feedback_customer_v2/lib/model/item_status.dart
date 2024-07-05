class ItemStatus {
  int id;
  String name;
  String nameNoTranslate;
  String image;
  String imageUnSelected; 
  bool isSelected;
  ItemStatus(
      {required this.id,
      required this.name,
      required this.nameNoTranslate,
      required this.image,
      required this.imageUnSelected,
      required this.isSelected
  });
}
