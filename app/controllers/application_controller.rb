class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logo

  def logo
    return "<span style='color: green'>Foot</span><span style='color: #EFCD3B'>i</span><span style='color: green'>Bon</span></a>".html_safe
  end

  def only_admin
    if !current_user || (current_user && !current_user.is_admin)
      flash[:error] = "You must be logged as admin to access this section"
      redirect_to root_path
    end
  end
end
