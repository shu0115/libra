class SummaryController < ApplicationController

  #------#
  # list #
  #------#
  def list
    @now_date = date_set( :date => params[:date] )

    @sum_type = "year"
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    if @sum_type == "year"
      # 年次合計
      @summary_hash = Item.sum_year( :now_date => @now_date, :user_id => session[:user_id] )
      @summary_hash = @summary_hash.sort{ |a, b| b[0] <=> a[0] }  # 降順ソート
      @sum_type_title = "年"
    elsif @sum_type == "month"
      # 月次合計
      @summary_hash = Item.sum_month( :now_date => @now_date, :user_id => session[:user_id] )
      @summary_hash = @summary_hash.sort{ |a, b| a[0] <=> b[0] }  # 昇順ソート
      @sum_type_title = "月"
    elsif @sum_type == "day"
      # 日次合計
      @summary_hash = Item.sum_day( :now_date => @now_date, :user_id => session[:user_id] )
      @summary_hash = @summary_hash.sort{ |a, b| a[0] <=> b[0] }  # 昇順ソート
      @sum_type_title = "日"
    end
  end

end
