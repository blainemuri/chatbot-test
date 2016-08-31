class ChatbotController < ApplicationController
  def ask_watson(query)
    response = `python lib/assets/python/app.py #{query}`
    # p is short for puts
    # p response
  end

  def query
    @query = params[:query]
    ask_watson(@query)
    render :bot
  end
end

# python /lib/assets/python/app.py
