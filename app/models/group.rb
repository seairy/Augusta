class Group < ActiveRecord::Base
  include UUID
  belongs_to :course
  has_many :holes
end
