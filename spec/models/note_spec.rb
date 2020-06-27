require 'rails_helper'

RSpec.describe Note, type: :model do
  # RSepcでは過度にDRYにこだわらなくてOK
  # 大きなスペックファイルを頻繁にスクロールするくらいなら、データのセットアップが多少重複してもOK

  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user, name: "Test Project") }

  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: user,
      project: project,
    )
    expect(note).to be_valid
  end

  it "is invalid without a message" do
    note = Note.new(
      message: nil,
      user: user,
      project: project,
      )

    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "search message for a term" do # #searchとメソッド名を書く人もいるけど筆者はコードの"振る舞い"を書く派とのこと
    let(:note1) { create(:note, project: project, user: user, message: "First Note") }
    let(:note2) { create(:note, project: project, user: user, message: "Second Note") }
    let(:note3) { create(:note, project: project, user: user, message: "First, perheat the oven.") }

    context "when a match is found" do
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(note1, note3)
      end
    end

    context "when no match is found" do
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
