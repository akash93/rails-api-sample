require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  
  describe 'GET #show' do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, params: {id: @product.id}
    end

    it 'returns correct information about product' do
      product_response = json_response[:product]
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      4.times {FactoryGirl.create :product}
      get :index
    end

    it 'returns products from database' do
      expect(json_response[:products].size).to eq 4
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it 'renders json representation of created product' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it {should respond_with 201}
    end

    context 'when is not created' do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: 'Some title', price: 'Wrong value' }
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @invalid_product_attributes }
      end

      it 'renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders reason on why product could not be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include 'is not a number'
      end
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context 'when is sucessfully updated' do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @product.id, product: { title: 'Some random title' } }
      end

      it 'renders the json representation of updated user' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql 'Some random title'
      end

      it {should respond_with 200}
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: {user_id: @user.id, id: @product.id, product: { price: 'Invalid value' }}
      end

      it 'renders errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the error message in errors json' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, params: {user_id: @user.id, id: @product.id}
    end

    it { should respond_with 204 }
  end

end
