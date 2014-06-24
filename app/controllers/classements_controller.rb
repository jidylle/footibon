class ClassementsController < ApplicationController
  def index
    @users=User.all(:order=>'score DESC, name ASC')
    @userstoday=User.where('scoreday >0').order('scoreday DESC, name ASC')
  end
end
