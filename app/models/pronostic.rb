class Pronostic < ActiveRecord::Base
  attr_accessible :match_id, :score1, :score2, :user_id
  belongs_to :match

end
