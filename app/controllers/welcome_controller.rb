class WelcomeController < ApplicationController
  layout "welcome_layout"
  def index
    @last_four_pronostics=Pronostic.last(4)
  end
end
