class ItemsController < ApplicationController

  layout "base"

  before_filter :date_set_filter

  #------#
  # show #
  #------#
  def show
    @item = Item.find( params[:id] )
  end

  #-----#
  # new #
  #-----#
  def new
    @item = Item.new
  end

  #------#
  # edit #
  #------#
  def edit
    @item = Item.find( params[:id] )
  end

  #--------#
  # create #
  #--------#
  def create
    @item = Item.new( params[:item] )

    if @item.save
      flash[:notice] = '品目の新規作成が完了しました。'
      redirect_to :controller => "total", :action => "amount", :sum_type => "all"
    else
      redirect_to :action => "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @item = Item.find( params[:id] )

    if @item.update_attributes( params[:item] )
      flash[:notice] = '品目の更新が完了しました。'
      redirect_to :controller => "total", :action => "amount", :sum_type => "all"
    else
      redirect_to :action => "edit"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @item = Item.find( params[:id] )
    @item.destroy

    redirect_to :controller => "total", :action => "amount", :sum_type => "all"
  end

end
