class AddScoringTypeCdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :scoring_type_cd, :string, limit: 20, null: false, after: :type_cd
  end
end
