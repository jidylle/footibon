class Match < ActiveRecord::Base
  belongs_to :equipe1, :class_name => 'Equipe', :foreign_key => 'equipe1_id'
  belongs_to :equipe2, :class_name => 'Equipe', :foreign_key => 'equipe2_id'
  attr_accessible :date_match, :score1, :score2,:equipe1_id,:equipe2_id, :is_start

  has_many :pronostics

  def phrase
    equipe1.nom.gsub("'", ' ')+ "-" +equipe2.nom.gsub("'", ' ')
  end

  def is_finished
    !(score1.blank? && score2.blank?)
  end

  def score_final
    score1.to_s + "-" + score2.to_s
  end
end
