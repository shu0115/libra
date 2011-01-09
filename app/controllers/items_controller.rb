class ItemsController < ApplicationController

  layout "base"

  before_filter :date_set_filter

  #------#
  # show #
  #------#
  def show
    @now_date = date_set( :date => params[:date] )
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    @item = Item.find( params[:id] )
    if @item.item_type == "income"
      @item_type = "収入"
    else
      @item_type = "支出"
    end
  end

  #-----#
  # new #
  #-----#
  def new
    @now_date = date_set( :date => params[:date] )
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    @item = Item.new
  end

  #------#
  # edit #
  #------#
  def edit
    @now_date = date_set( :date => params[:date] )
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    @item = Item.find( params[:id] )
    if @item.item_type == "income"
      @item_type_income = true
    else
      @item_type_expense = true
    end
  end

  #--------#
  # create #
  #--------#
  def create
    @now_date = date_set( :date => params[:date] )
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    params[:item][:price] = params[:item][:price].gsub( ",", "" )  # カンマを削除
    params[:item][:price] = params[:item][:price].gsub( " ", "" )  # 半角空白を削除

    @item = Item.new( params[:item] )

    if @item.save
      flash[:notice] = '品目の新規作成が完了しました。'
      redirect_to :controller => "total", :action => "amount", :sum_type => @sum_type, :date=> @now_date
    else
      redirect_to :action => "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @now_date = date_set( :date => params[:date] )
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    @item = Item.find( params[:id] )

    params[:item][:price] = params[:item][:price].gsub( ",", "" )  # カンマを削除
    params[:item][:price] = params[:item][:price].gsub( " ", "" )  # 半角空白を削除

    if @item.update_attributes( params[:item] )
      flash[:notice] = '品目の更新が完了しました。'
      redirect_to :controller => "total", :action => "amount", :sum_type => @sum_type, :date=> @now_date
    else
      redirect_to :action => "edit"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @now_date = date_set( :date => params[:date] )
    @sum_type = params[:sum_type] unless params[:sum_type].blank?

    @item = Item.find( params[:id] )
    @item.destroy

    redirect_to :controller => "total", :action => "amount", :sum_type => @sum_type, :date=> @now_date
  end

end
