require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: "Taro",
      last_name: "Yamada",
      email: "taro@example.com",
      password: "pass1234"
    )
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    @user.projects.create(name: "Same Name Project")
    new_project = @user.projects.build(name: "Same Name Project")
    new_project.valid?
    expect(new_project.errors[:name]).to include "has already been taken"
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    other_user = User.create(
      first_name: "Hanako",
      last_name: "Sato",
      email: "hanako@example.com",
      password: "pass1234"
    )

    @user.projects.create(name: "Same Name Project")
    other_project = other_user.projects.build(name: "Same Name Project")

    expect(other_project).to be_valid
  end
end
