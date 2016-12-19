class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :email, :created_at, :updated_at, :products

  def products
    api_v1_user_products_url object.id
  end
end
