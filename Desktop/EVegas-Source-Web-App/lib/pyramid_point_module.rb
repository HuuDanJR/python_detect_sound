module PyramidPointModule
  include CommonModule
  include DaoModule

  PYRAMID_POINT_ATTRIBUTE = ClassAttribute.new
  PYRAMID_POINT_ATTRIBUTE.clazz = PyramidPoint
  PYRAMID_POINT_ATTRIBUTE.object_key = "pyramid_point"
  PYRAMID_POINT_ATTRIBUTE.filter_params = ["search"]
  PYRAMID_POINT_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  PYRAMID_POINT_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  PYRAMID_POINT_ATTRIBUTE.include_object_params = {}

end