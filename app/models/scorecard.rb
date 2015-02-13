# -*- encoding : utf-8 -*-
class Scorecard < ActiveRecord::Base
  include UUID
  as_enum :tee_box_color, [:red, :white, :blue, :black, :gold], prefix: true, map: :string
  belongs_to :match
  belongs_to :hole
end
