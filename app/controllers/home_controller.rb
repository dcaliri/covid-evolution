class HomeController < ApplicationController

  before_action :get_data

  def index
    @countries = @json.map{ |x| x.first }
  end

  def json_series
    @json = @json.select{|x| params[:countries].split(',').include?(x)} if params[:countries].present?
    @countries = @json.map{|x| [ x[0], x[1].map{|y| [ y['date'], y['confirmed'] ] }.to_h ] }
    json = @countries.map{|x| { name: x[0], data: x[1] } }
    render json: json
  end

  def get_data
    response = Faraday.get 'https://pomber.github.io/covid19/timeseries.json'
    @json = JSON.parse response.body
  end

end
