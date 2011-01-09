class TotalController < ApplicationController

  layout "base"

  #--------#
  # amount #
  #--------#
  def amount
    print "【 params[:date] 】>> " ; p params[:date] ;
    @now_date = date_set( :date => params[:date] )

    @sum_type = "all"
    unless params[:sum_type].blank?
      @sum_type = params[:sum_type]
    else
      @sum_type = "month"
    end

    # 品目取得
    @items, @income, @expense = Item.find_items( :now_date => @now_date, :sum_type => @sum_type )

    # 合計算出
    @amount, @income, @expense = Item.sum_price( :income => @income, :expense => @expense )
  end

end
