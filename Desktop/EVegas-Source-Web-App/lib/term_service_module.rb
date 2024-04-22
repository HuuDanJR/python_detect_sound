module TermServiceModule
  include CommonModule
  include DaoModule

  TERM_SERVICE_ATTRIBUTE = ClassAttribute.new
  TERM_SERVICE_ATTRIBUTE.clazz = TermService
  TERM_SERVICE_ATTRIBUTE.object_key = "term_service"
  TERM_SERVICE_ATTRIBUTE.filter_params = ["search"]
  TERM_SERVICE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  TERM_SERVICE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  TERM_SERVICE_ATTRIBUTE.include_object_params = {
  }

end