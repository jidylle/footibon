class ClassementsController < ApplicationController
  def index
    @users=User.all(:order=>'score DESC')
  end
end
