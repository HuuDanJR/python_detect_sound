module MembershipModule
  include CommonModule
  include DaoModule

  MEMBERSHIP_ATTRIBUTE = ClassAttribute.new
  MEMBERSHIP_ATTRIBUTE.clazz = Membership
  MEMBERSHIP_ATTRIBUTE.object_key = "membership"
  MEMBERSHIP_ATTRIBUTE.filter_params = ["search"]
  MEMBERSHIP_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  MEMBERSHIP_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  MEMBERSHIP_ATTRIBUTE.include_object_params = {}

end