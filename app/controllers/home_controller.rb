class HomeController < ApplicationController

  before_action :get_data
  before_action :check_params

  def index
  end

  def deaths
  end

  def active
  end

  def json_series
    @json = @json.select{|x| @countries.split(',').include?(x)}
    @json = @json.map{|k,v| [k, @json[k].select{ |x| x if x['date'].to_date >= @date.to_date }]}.to_h
    case params[:info]
    when 'infected'
      @data = @json.map{|x| [ x[0], x[1].map{|y| [ y['date'], y['confirmed'] ] }.to_h ] }
    when 'deaths'
      @data = @json.map{|x| [ x[0], x[1].map{|y| [ y['date'], y['deaths'] ] }.to_h ] }
    when 'active'
      @data = @json.map{|x| [ x[0], x[1].map{|y| [ y['date'], y['confirmed'] - y['deaths'] - y['recovered'] ] }.to_h ] }
    end
    json = @data.map{|x| { name: x[0], data: x[1] } }
    render json: json
  end

  def check_params
    @date = params[:since].present? ? params[:since] : '01/03/2020'
    @countries = params[:countries].present? ? params[:countries] : 'Argentina,Chile,Brazil'
  end

  def get_data
    response = Faraday.get 'https://pomber.github.io/covid19/timeseries.json'
    @json = JSON.parse response.body
  end

end
