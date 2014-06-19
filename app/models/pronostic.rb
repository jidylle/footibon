class Pronostic < ActiveRecord::Base
  attr_accessible :match_id, :score1, :score2, :user_id
  belongs_to :match
  belongs_to :user

  validates :score1,:score2,:match_id, :presence => true
  validates_numericality_of :score1,:score2, :only_integer => true, :greater_than_or_equal_to => 0

  def win?
    score1==match.score1 && score2==match.score2
  end

  def score_prono
    score1.to_s+"-"+score2.to_s
  end

  def loose?
    match.is_finished && !win?
  end

  def url_s3
    "http://"+ENV['footibon_s3_bucket']+".s3.amazonaws.com/"+id.to_s+".jpg"
  end

end
