class VolumeModel {
  late int id;
  late String name;
  late double minValue;
  late double maxValue;
  late double currentValue;
  late bool isShow;
  late String urlName;
  VolumeModel(
      {required this.id,
      required this.name,
      required this.minValue,
      required this.maxValue,
      required this.isShow,
      required this.currentValue,
      required this.urlName});
}
