class Relationship < ApplicationRecord
  belongs_to :follow, class_name: 'User'
  belongs_to :user
end
