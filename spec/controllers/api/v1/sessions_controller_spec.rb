require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe 'POST #create' do

    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when credentials are correct' do

      before(:each) do
        credentials = { email: @user.email, password: 'password' }
        post :create, params: { session: credentials }
      end

      it 'returns the user record corresponding to given credentials' do
        @user.reload
        expect(json_response[:user][:email]).to eql @user.email
      end

      it {should respond_with 200}
    end

    context 'when credentials are incorrect' do

      before(:each) do
        credentials = { email: @user.email, password:'wrongpassword'}
        post :create, params: { session: credentials }
      end

      it 'returns json with error' do
        expect(json_response[:errors]).to eql 'Invalid credentials'
      end

      it {should respond_with 422}
    end

  end

  describe 'DELETE #destroy' do

    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, params: {id: @user.auth_token}
    end

    it { should respond_with 204 }
  end
end
