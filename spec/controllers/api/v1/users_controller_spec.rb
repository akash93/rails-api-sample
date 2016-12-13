require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  
  before(:each) { request.headers['Accept'] = "application/vnd.apisample.v1" }

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, params: {id: @user.id, format: :json}
    end

    it 'returns the information' do
      user_response =  JSON.parse(response.body, symbolize_names:true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do

    context 'When user is successfully created' do
      before (:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, {user: @user_attributes}, format: :json
      end

      it 'renders the json representation for the user just created' do 
        user_response = JSON.parse(response.body, symbolize_names:true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it {should respond_with 201}
    end

    context 'when user is not created' do
      before(:each) do
        @invalid_user_attributes = {password: 'password', password_confirmation: 'password'}
        post :create , { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders reason why user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

  end
  

end
