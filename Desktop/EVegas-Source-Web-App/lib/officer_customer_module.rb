module OfficerCustomerModule
  include CommonModule
  include DaoModule

  OFFICER_CUSTOMER_ATTRIBUTE = ClassAttribute.new
  OFFICER_CUSTOMER_ATTRIBUTE.clazz = OfficerCustomer
  OFFICER_CUSTOMER_ATTRIBUTE.object_key = "officer_customer"
  OFFICER_CUSTOMER_ATTRIBUTE.filter_params = ["search", "by_customer"]
  OFFICER_CUSTOMER_ATTRIBUTE.index_except_params = ["updated_at"]
  OFFICER_CUSTOMER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  OFFICER_CUSTOMER_ATTRIBUTE.create_params = ["officer_id", "customer_id"]
  OFFICER_CUSTOMER_ATTRIBUTE.include_object_params = {
    "officer" => ["id", "name", "phone", "attachment_id"],
    "customer" => ["id", "forename", "middle_name", "surname"]
  }

end