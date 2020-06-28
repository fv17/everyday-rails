require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "index" do
    # 認証済みの場合
    context "as an authenticated user" do
      let(:user) { create(:user) }

      it "responds successfully" do
        sign_in user
        get :index
        expect(response).to be_success
      end

      it "returns a 200 response" do
        sign_in user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    # 未ログインの場合
    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "show" do
    let(:user) { create(:user) }
    let(:project) { create(:project, owner: user) }

    # プロジェクトのオーナーである場合
    context "as a project owner" do
      it "responds successfully" do
        sign_in user
        get :show, params: { id: project.id }
        expect(response).to be_success
      end
    end

    # プロジェクトのオーナーではない場合
    context "as not a project owner" do
      let(:other_user) { create(:user) }

      it "redirects to the dashboard" do
        sign_in other_user
        get :show, params: { id: project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "create" do
    let(:project_params) { attributes_for(:project) }

    # 認証済みの場合
    context "as an authenticated user" do
      let(:user) { create(:user) }

      it "adds a project" do
        sign_in user
        expect {
          post :create, params: { project: project_params }
        }.to change(user.projects, :count).by(1)
      end
    end

    # 未ログインの場合
    context "as a guest" do
      it "returns a 302 response" do
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
