# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9f1ef63898988a4622d8c68766a03056'

  $type_hash = { "income" => '収入', "expense" => '支出' }

  #----------#
  # date_set #
  #----------#
  def date_set( args )
    unless args[:date].blank?
      return Date.parse( args[:date] )
    else
      return Date.today
    end
  end

  #-----------------#
  # date_set_filter #
  #-----------------#
  def date_set_filter
    unless params[:date].blank?
      @now_date = Date.parse( params[:date] )
    else
      @now_date = Date.today
    end
  end

end
