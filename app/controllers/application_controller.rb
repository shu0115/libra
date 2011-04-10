# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9f1ef63898988a4622d8c68766a03056'

  before_filter :authorize
  before_filter :ssl_redirect

  $per_page = 15
  $type_hash = { "income" => '収入', "expense" => '支出' }
  
  # ログインプロトコル
  if Rails.env.production?
    $login_protocol = "https"
  else
    $login_protocol = "http"
  end

  private
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

  #-----------#
  # authorize #
  #-----------#
  def authorize
    # ログイン制限 除外リスト
    except_hash = Hash.new{ | hash, key | hash[key] = Hash.new }
    except_hash["entry"]["login"] = "EXCEPT"
    except_hash["entry"]["input"] = "EXCEPT"
    except_hash["entry"]["confirmation"] = "EXCEPT"
    except_hash["entry"]["complete"] = "EXCEPT"
    
    unless except_hash[params[:controller]][params[:action]].blank?
      return
    else
      user = User.find_by_id( session[:user_id] )
      if user.blank?
        session[:request_url] = request.url
        flash[:login_notice] = "ログインが必要です。<br /><br />"
        redirect_to :controller => "entry", :action => "login" and return
      end
    end
  end

  #--------------#
  # ssl_redirect #
  #--------------#
  def ssl_redirect
    if Rails.env.production? and request.env["HTTP_X_FORWARDED_PROTO"].to_s == "https" and params[:controller] == "public"
      # httpへリダイレクト
      request.env["HTTP_X_FORWARDED_PROTO"] = "http"
      redirect_to request.url and return
    elsif Rails.env.production? and request.env["HTTP_X_FORWARDED_PROTO"].to_s != "https" and params[:controller] != "public"
      # httpsへリダイレクト
      request.env["HTTP_X_FORWARDED_PROTO"] = "https"
      redirect_to request.url and return
    end
  end

end
