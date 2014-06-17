class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logo

  def logo
    return "<span style='color: green'>Foot</span><span style='color: #EFCD3B'>i</span><span style='color: green'>Bon</span></a>".html_safe
  end
end
