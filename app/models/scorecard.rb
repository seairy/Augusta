# -*- encoding : utf-8 -*-
class Scorecard < ActiveRecord::Base
  include UUID
  as_enum :tee_box_color, [:red, :white, :blue, :black, :gold], prefix: true, map: :string
  as_enum :direction, [:hook, :pure, :slice], prefix: true, map: :string
  belongs_to :player
  belongs_to :hole
  scope :sorted, -> { order(:number) }
  scope :out, -> { where(number: 1..9) }
  scope :in, -> { where(number: 10..18) }

  def finished?
    score and putts
  end

  def status
    score - par if score and par
  end
end
