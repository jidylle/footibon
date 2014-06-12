class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.date :date_match
      t.integer :score1
      t.integer :score2
      t.integer :equipe1_id
      t.integer :equipe2_id

      t.timestamps
    end
  end
end
