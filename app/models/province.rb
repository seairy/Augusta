class Province < ActiveRecord::Base
  include UUID
  has_many :cities
end
