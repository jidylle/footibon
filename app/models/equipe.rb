class Equipe < ActiveRecord::Base
  attr_accessible :drapeau, :nom
  has_many :matches
end
