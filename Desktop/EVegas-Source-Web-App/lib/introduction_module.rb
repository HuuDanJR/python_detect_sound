module IntroductionModule
  include CommonModule
  include DaoModule

  INTRODUCTION_ATTRIBUTE = ClassAttribute.new
  INTRODUCTION_ATTRIBUTE.clazz = Introduction
  INTRODUCTION_ATTRIBUTE.object_key = "introduction"
  INTRODUCTION_ATTRIBUTE.filter_params = ["search"]
  INTRODUCTION_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  INTRODUCTION_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  INTRODUCTION_ATTRIBUTE.include_object_params = {}

end