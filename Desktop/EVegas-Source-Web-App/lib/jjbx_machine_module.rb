module JjbxMachineModule
  include CommonModule
  include DaoModule

  JJBXMACHINE_ATTRIBUTE = ClassAttribute.new
  JJBXMACHINE_ATTRIBUTE.clazz = JjbxMachine
  JJBXMACHINE_ATTRIBUTE.object_key = "jjbx_machine"
  JJBXMACHINE_ATTRIBUTE.filter_params = []
  JJBXMACHINE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  JJBXMACHINE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  JJBXMACHINE_ATTRIBUTE.create_params = ["grand_name", "grand_value", "major_name", "major_value"]
  JJBXMACHINE_ATTRIBUTE.include_object_params = {}
  
end