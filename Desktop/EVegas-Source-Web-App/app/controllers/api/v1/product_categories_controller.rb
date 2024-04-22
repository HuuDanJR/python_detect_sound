class Api::V1::ProductCategoriesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include ProductCategoryModule

  def initialize()
    super(PRODUCT_CATEGORY_ATTRIBUTE)
  end

end