FactoryBot.define do
  factory :note do
    message { "My first note." }
    association :project
    user { project.owner }

    # association :user
    # ↑のように書くと、projectのownerとは別のuserと紐付けることになりNG
  end
end
