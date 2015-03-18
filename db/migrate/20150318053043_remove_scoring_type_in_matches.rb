class RemoveScoringTypeInMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :scoring_type_cd
  end
end
