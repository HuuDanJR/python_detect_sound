module MessageModule
  include CommonModule
  include DaoModule

  MESSAGE_ATTRIBUTE = ClassAttribute.new
  MESSAGE_ATTRIBUTE.clazz = Message
  MESSAGE_ATTRIBUTE.object_key = "message"
  MESSAGE_ATTRIBUTE.filter_params = ["search"]
  MESSAGE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  MESSAGE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  MESSAGE_ATTRIBUTE.include_object_params = {
  }

end