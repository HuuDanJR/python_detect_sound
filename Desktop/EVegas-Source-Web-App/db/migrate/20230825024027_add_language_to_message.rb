class AddLanguageToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :content_vi, :text 
    add_column :messages, :content_kr, :text
    add_column :messages, :content_cn, :text
    add_column :messages, :title_vi, :string, limit: 500
    add_column :messages, :title_kr, :string, limit: 500
    add_column :messages, :title_cn, :string, limit: 500
    add_column :messages, :short_description, :string, limit: 1000
    add_column :messages, :short_description_vi, :string, limit: 1000
    add_column :messages, :short_description_kr, :string, limit: 1000
    add_column :messages, :short_description_cn, :string, limit: 1000
    add_column :messages, :language, :string, limit: 50
    add_column :messages, :is_draft, :boolean, default: 0
    add_column :messages, :category, :integer, default: 1
    add_column :messages, :user_ids, :string, limit: 512
  end
end
