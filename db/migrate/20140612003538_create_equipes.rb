class CreateEquipes < ActiveRecord::Migration
  def change
    create_table :equipes do |t|
      t.string :nom
      t.string :drapeau

      t.timestamps
    end
  end
end
