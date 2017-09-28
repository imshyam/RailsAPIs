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
        ids = params[:ids]
        days = params[:days]
        hours = params[:hours]
        idList = ids.split(',')
        if !days.nil?
          days = days.to_i
          dataList = History.where(exchange_id: idList).where("date_time >= ?", days.days.ago.utc)
        end
        if !hours.nil?
          hours = hours.to_i
          dataList = History.where(exchange_id: idList).where("date_time >= ?", hours.hours.ago.utc)
        end
        @completeData = []
        for data in dataList
          dataJson = Hash["crypto_curr" => data.crypto_curr,
                    "curr" => data.curr,
                    "exchange_id" => data.exchange_id,
                    "date_time" => data.date_time,
                    "buy" => data.buy,
                    "sell" => data.sell]
          @completeData.push(dataJson)
        end
        render json: @completeData
      end
    end
  end
end