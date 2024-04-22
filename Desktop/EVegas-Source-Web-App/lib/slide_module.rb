module SlideModule
  include CommonModule
  include DaoModule

  SLIDE_ATTRIBUTE = ClassAttribute.new
  SLIDE_ATTRIBUTE.clazz = Slide
  SLIDE_ATTRIBUTE.object_key = "Slide"
  SLIDE_ATTRIBUTE.filter_params = ["search", "by_name", "by_index", "by_is_show"]
  SLIDE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  SLIDE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  SLIDE_ATTRIBUTE.include_object_params = {}

end