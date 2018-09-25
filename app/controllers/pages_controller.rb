class PagesController < ApplicationController
    def index #views/index.html.erbを表示させるというアクション
      @users = User.all
    end
  
    def search
      turn_on_location_search
      # Ransack q のチェックボックス一覧
      if params[:q].present? 
        turn_on_search_session
      end   
      session[:q] = {"price_pernight_gteq"=>session[:price_pernight_gteq], "price_pernight_lteq"=>session[:price_pernight_lteq],  "home_type_eq_any"=>session[:home_type_eq_any], "pet_type_eq"=>session[:pet_type_eq], "breeding_years_gteq"=>session[:breeding_years_gteq]}
      # ransack検索
      @search = @listings.ransack(session[:q])
      @result = @search.result(distinct: true)
       #リスティングデータを配列にしてまとめる 
      @arrlistings = @result.to_a
  
    end
  
    def ajaxsearch
      
      # まずajaxで送られてきた緯度経度をセッションに入れる
      if !params[:geolocation].blank?
        geolocation = params[:geolocation]
      end
  
      @listings = Listing.where(active: true).near(geolocation, 1, order: 'distance')
  
      #リスティングデータを配列にしてまとめる 
      @arrlistings = @listings.to_a

      turn_on_ajax_search
      
      respond_to :js
    
    end

    private
    params_types = { 
      price_pernight_gteq: "value1", 
      price_pernight_lteq: "value2",
      home_type_eq_any: "value3",
      pet_type_eq: "value4",
      breeding_years_gteq: "value"
    }

    def turn_on_location_search
      if params[:search].present?
        
        if params["lat"].present? & params["lng"].present? 
          @latitude = params["lat"]
          @longitude = params["lng"]
    
          geolocation = [@latitude,@longitude]
        else
          geolocation = Geocoder.coordinates(params[:search])
          @latitude = geolocation[0]
          @longitude = geolocation[1]
        end
    
        @listings = Listing.where(active: true).near(geolocation, 1, order: 'distance')
    
      # 検索欄が空欄の場合
      else
        @listings = Listing.where(active: true).all
        @latitude = @listings.to_a[0].latitude
        @longitude = @listings.to_a[0].longitude  
      end
    end

    def turn_on_search_session
      params_types.each{|key, value|
        params_types.include?(:key)? session[:key] = params[:key] : nil
      }
      turn_on_home_type_search_session
    end

    def turn_on_home_type_search_session
      if session[:home_type_eq_any].present?
        session[:House] = session[:home_type_eq_any].include?("一軒家")
        session[:Mansion] = session[:home_type_eq_any].include?("マンション")
        session[:Apartment] = session[:home_type_eq_any].include?("アパート")
      else
        session[:home_type_eq_any] = ""
        session[:House] = false
        session[:Mansion] = false
        session[:Apartment] = false
      end
    end

    def turn_on_date_search_session
      # start_date end_dateの間に予約がないことを確認.あれば削除
      if ( !params[:start_date].blank? && !params[:end_date].blank? )
        session[:start_date] = params[:start_date]
        session[:end_date] = params[:end_date]
  
        start_date = Date.parse(session[:start_date])
        end_date = Date.parse(session[:end_date])
  
        @listings.each do |listing|
  
        # check the listing is availble between start_date to end_date
        unavailable = listing.reservations.where(
          "(? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?) 
          OR (start_date < ? AND ? < end_date)",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date
        ).limit(1)
  
        # delete unavailable room from @listings
        if unavailable.length > 0
          @arrlistings.delete(listing) 
        end 
      end
    end

    def turn_on_ajax_search
      # start_date end_dateの間に予約がないことを確認.あれば削除
      if ( !session[:start_date].blank? && !session[:end_date].blank? )
  
        start_date = Date.parse(session[:start_date])
        end_date = Date.parse(session[:end_date])
  
        @listings.each do |listing|
  
          # check the listing is availble between start_date to end_date
          unavailable = listing.reservations.where(
              "(? <= start_date AND start_date <= ?)
                OR (? <= end_date AND end_date <= ?) 
                OR (start_date < ? AND ? < end_date)",
              start_date, end_date,
              start_date, end_date,
              start_date, end_date
          ).limit(1)
  
          # delete unavailable room from @listings
          if unavailable.length > 0
            @arrlistings.delete(listing) 
          end 
        end
      end
    end
  end
end