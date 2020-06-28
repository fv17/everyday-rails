require 'rails_helper'

RSpec.describe "Projects Api", type: :request do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, name: "User's Project", owner: user) }

  # 1件のプロジェクトを読み出すこと
  it "loads a project" do
    other_user = create(:user)
    create(:project, name: "Other user's Project", owner: other_user)

    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1
    project_id = json[0]["id"]

    get api_project_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq "User's Project"
  end

  # プロジェクトを作成できること
  it "creates a project" do
    project_attirbutes = attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attirbutes
      }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status(:success)
  end
end
