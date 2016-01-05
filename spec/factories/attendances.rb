FactoryGirl.define do
  factory :attendance do
    identification 1
period "MyString"
went_days 1
skip_days 1
reason "MyText"
student nil
  end

end
