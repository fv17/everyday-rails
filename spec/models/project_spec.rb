require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user, first_name: "Taro", last_name: "Yamada") }

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user.projects.create(name: "Same Name Project")
    new_project = user.projects.build(name: "Same Name Project")
    new_project.valid?
    expect(new_project.errors[:name]).to include "has already been taken"
  end

  # 二人のユーザーが同じプロジェクト名を使うことは許可すること
  it "allows two users to share a project name" do
    user.projects.create(name: "Same Name Project")
    other_user = create(:user, first_name: "Hanako", last_name: "Sato")
    other_project = other_user.projects.build(name: "Same Name Project")
    expect(other_project).to be_valid
  end

  describe "late status" do
    it "is late when the due date is past today" do
      project = create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "is on time when the due date is today" do
      project = create(:project, :due_today)
      expect(project).to_not be_late
    end

    it "is on time when the due date is in the future" do
      project = create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
