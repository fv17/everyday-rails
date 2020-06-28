require 'rails_helper'

RSpec.describe "Projects", type: :request do
  # 認証済みの場合
  context "as an authenticated user" do
    let(:user) { create(:user) }

    # 有効な属性の場合
    context "with valid attributes" do
      it "adds a project" do
        project_params = attributes_for(:project)
        sign_in user
        expect {
          post projects_path, params: { project: project_params }
        }.to change(user.projects, :count).by(1)
      end
    end

    # 無効な属性の場合
    context "with invalid attributes" do
      it "does not add a project"
    end
  end
end
