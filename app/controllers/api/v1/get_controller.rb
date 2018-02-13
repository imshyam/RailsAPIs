module Api
  module V1
    class GetController < ApplicationController

      def current
        ids = params[:ids]
        idList = ids.split(',')
        dataList = Current.where(exchange_id: idList)
        @completeData = []
        for data in dataList
          dataJson = Hash["crypto_curr" => data.crypto_curr,
                    "curr" => data.curr,
                    "exchange_id" => data.exchange_id,
                    "date_time" => data.date_time,
                    "buy" => data.buy,
                    "sell" => data.sell,
                    "volume" => data.volume,
                    "last_hour_min_buy" => data.last_hour_min_buy,
                    "last_day_min_buy" => data.last_day_min_buy,
                    "last_week_min_buy" => data.last_week_min_buy,
                    "last_month_min_buy" => data.last_month_min_buy,
                    "last_hour_max_buy" => data.last_hour_max_buy,
                    "last_day_max_buy" => data.last_day_max_buy,
                    "last_week_max_buy" => data.last_week_max_buy,
                    "last_month_max_buy" => data.last_month_max_buy,
                    "last_hour_min_sell" => data.last_hour_min_sell,
                    "last_day_min_sell" => data.last_day_min_sell,
                    "last_week_min_sell" => data.last_week_min_sell,
                    "last_month_min_sell" => data.last_month_min_sell,
                    "last_hour_max_sell" => data.last_hour_max_sell,
                    "last_day_max_sell" => data.last_day_max_sell,
                    "last_week_max_sell" => data.last_week_max_sell,
                    "last_month_max_sell" => data.last_month_max_sell]
          @completeData.push(dataJson)
        end
        render json: @completeData
      end
      def history
        @completeData = []
        @currentData = []
        @historyData = []
        ids = params[:ids]
        period = params[:period]
        idList = ids.split(',')

        # Handle Current Data
        dataList = Current.where(exchange_id: idList)
        for data in dataList
          dataJson = Hash["crypto_curr" => data.crypto_curr,
                    "curr" => data.curr,
                    "exchange_id" => data.exchange_id,
                    "date_time" => data.date_time,
                    "buy" => data.buy,
                    "sell" => data.sell,
                    "volume" => data.volume]
          @currentData.push(dataJson)
        end

        # Handle History
        if !period.nil?
          dataList = History.where(exchange_id: idList).where("period = ?", period)
        end
        for data in dataList
          dataJson = Hash[
                    "exchange_id" => data.exchange_id,
                    "date_time" => data.date_time,
                    "buy" => data.buy,
                    "sell" => data.sell]
          @historyData.push(dataJson)
        end
        @completeData = Hash[
                    "current" => @currentData,
                    "history" => @historyData]
        render json: @completeData
      end
    end
  end
end