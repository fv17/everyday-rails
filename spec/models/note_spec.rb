require 'rails_helper'

RSpec.describe Note, type: :model do
  # RSepcでは過度にDRYにこだわらなくてOK
  # 大きなスペックファイルを頻繁にスクロールするくらいなら、データのセットアップが多少重複してもOK

  before do
    @user = User.create(
      first_name: "Taro",
      last_name: "Yamada",
      email: "taro@example.com",
      password: "pass1234"
    )

    @project = @user.projects.create(name: "Test Project")
  end

  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: @user,
      project: @project,
    )
    expect(note).to be_valid
  end

  it "is invalid without a message" do
    note = Note.new(
      message: nil,
      user: @user,
      project: @project,
      )

    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "search message for a term" do # #searchとメソッド名を書く人もいるけど筆者はコードの"振る舞い"を書く派とのこと
    before do
      @note1 = @project.notes.create(message: "First Note", user: @user)
      @note2 = @project.notes.create(message: "Second Note", user: @user)
      @note3 = @project.notes.create(message: "First, perheat the oven.", user: @user)
    end

    context "when a match is found" do
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    context "when no match is found" do
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
