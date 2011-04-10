class Item < ActiveRecord::Base

  #-----------------#
  # self.find_items #
  #-----------------#
  def self.find_items( args )

    if args[:sum_type] == "all"
      # 直近100件取得
      items = Item.paginate( :all, :page => args[:page], :per_page => $per_page, :conditions => { :user_id => args[:user_id] }, :limit => "10", :order => "happen_at DESC, id DESC" )
      income = Item.sum( :price, :conditions => [ "item_type = 'income' AND user_id = ?", args[:user_id] ], :limit => "100" )
      expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND user_id = ?", args[:user_id] ], :limit => "100" )
    elsif args[:sum_type] == "year"
      # 指定された年の開始日～次の年の開始日の前日まで
      items = Item.paginate( :all, :page => args[:page], :per_page => $per_page, :conditions => [ "happen_at >= ? AND happen_at < ? AND user_id = ?", args[:now_date].beginning_of_year, args[:now_date].next_year.beginning_of_year, args[:user_id] ], :order => "happen_at ASC, id ASC" )
      income = Item.sum( :price, :conditions => [ "item_type = 'income' AND happen_at >= ? AND happen_at < ? AND user_id = ?", args[:now_date].beginning_of_year, args[:now_date].next_year.beginning_of_year, args[:user_id] ] )
      expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND happen_at >= ? AND happen_at < ? AND user_id = ?", args[:now_date].beginning_of_year, args[:now_date].next_year.beginning_of_year, args[:user_id] ] )
    elsif args[:sum_type] == "month"
      # 指定された月の開始日～指定された月の末日まで
      items = Item.paginate( :all, :page => args[:page], :per_page => $per_page, :conditions => [ "happen_at >= ? AND happen_at <= ? AND user_id = ?", args[:now_date].beginning_of_month, args[:now_date].end_of_month, args[:user_id] ], :order => "happen_at ASC, id ASC" )
      income = Item.sum( :price, :conditions => [ "item_type = 'income' AND happen_at >= ? AND happen_at <= ? AND user_id = ?", args[:now_date].beginning_of_month, args[:now_date].end_of_month, args[:user_id] ] )
      expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND happen_at >= ? AND happen_at <= ? AND user_id = ?", args[:now_date].beginning_of_month, args[:now_date].end_of_month, args[:user_id] ] )
    elsif args[:sum_type] == "day"
      # 指定された日に一致するもの
      items = Item.paginate( :all, :page => args[:page], :per_page => $per_page, :conditions => [ "happen_at = ? AND user_id = ?", args[:now_date], args[:user_id] ], :order => "happen_at ASC, id ASC" )
      income = Item.sum( :price, :conditions => [ "item_type = 'income' AND happen_at = ? AND user_id = ?", args[:now_date], args[:user_id] ] )
      expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND happen_at = ? AND user_id = ?", args[:now_date], args[:user_id] ] )
    end

    return items, income, expense
  end

  #----------------#
  # self.sum_price #
  #----------------#
  def self.sum_price( args )
    args[:income] = 0 if args[:income].blank?
    args[:expense] = 0 if args[:expense].blank?

    return ( args[:income] - args[:expense] ), args[:income], args[:expense]
  end

  #---------------#
  # self.sum_year #
  #---------------#
  def self.sum_year( args )

    year_summary_hash = Hash.new{ | hash, key | hash[key] = Hash.new }

    oldest_year = Item.find( :first, :conditions => { :user_id => args[:user_id] }, :order => "happen_at ASC" )
    newest_year = Item.find( :first, :conditions => { :user_id => args[:user_id] }, :order => "happen_at DESC" )

    if !oldest_year.blank? and !newest_year.blank?
      oldest_year.happen_at.year.upto( newest_year.happen_at.year ) { |year|
        year_date = Date.parse( "#{year}-01-01" )
        # 指定された年の開始日～次の年の開始日の前日まで
        income = Item.sum( :price, :conditions => [ "item_type = 'income' AND happen_at >= ? AND happen_at < ? AND user_id = ?", year_date.beginning_of_year, year_date.next_year.beginning_of_year, args[:user_id] ] )
        expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND happen_at >= ? AND happen_at < ? AND user_id = ?", year_date.beginning_of_year, year_date.next_year.beginning_of_year, args[:user_id] ] )
        year_summary_hash[year][:amount], year_summary_hash[year][:income], year_summary_hash[year][:expense] = Item.sum_price( :income => income, :expense => expense )
      }
    end

    return year_summary_hash
  end

  #----------------#
  # self.sum_month #
  #----------------#
  def self.sum_month( args )

    summary_hash = Hash.new{ | hash, key | hash[key] = Hash.new }

    1.upto( 12 ) { |month|
      month_date = Date.parse( "#{args[:now_date].year}-#{month}-01" )
      # 指定された月の開始日～指定された月の末日まで
      income = Item.sum( :price, :conditions => [ "item_type = 'income' AND happen_at >= ? AND happen_at <= ? AND user_id = ?", month_date.beginning_of_month, month_date.end_of_month, args[:user_id] ] )
      expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND happen_at >= ? AND happen_at <= ? AND user_id = ?", month_date.beginning_of_month, month_date.end_of_month, args[:user_id] ] )

      summary_hash[month][:amount], summary_hash[month][:income], summary_hash[month][:expense] = Item.sum_price( :income => income, :expense => expense )
    }

    return summary_hash
  end

  #--------------#
  # self.sum_day #
  #--------------#
  def self.sum_day( args )

    summary_hash = Hash.new{ | hash, key | hash[key] = Hash.new }

    1.upto( args[:now_date].end_of_month.day ) { |day|
      day_date = Date.parse( "#{args[:now_date].year}-#{args[:now_date].month}-#{day}" )
      # 指定された月の開始日～指定された月の末日まで
      income = Item.sum( :price, :conditions => [ "item_type = 'income' AND happen_at = ? AND user_id = ?", day_date, args[:user_id] ] )
      expense = Item.sum( :price, :conditions => [ "item_type = 'expense' AND happen_at = ? AND user_id = ?", day_date, args[:user_id] ] )

      summary_hash[day][:amount], summary_hash[day][:income], summary_hash[day][:expense] = Item.sum_price( :income => income, :expense => expense )
    }

    return summary_hash
  end

end
