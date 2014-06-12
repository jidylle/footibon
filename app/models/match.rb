class Match < ActiveRecord::Base
  belongs_to :equipe1, :class_name => 'Equipe', :foreign_key => 'equipe1_id'
  belongs_to :equipe2, :class_name => 'Equipe', :foreign_key => 'equipe2_id'
  attr_accessible :date_match, :score1, :score2
end
