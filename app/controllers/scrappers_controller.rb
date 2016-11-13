require 'metainspector'
require 'nokogiri'
require 'open-uri'

class ScrappersController < ApplicationController
  before_action :set_scrapper, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /scrappers
  # GET /scrappers.json
  def index
    @scrappers = current_user.scrappers
  end

  # GET /scrappers/1
  # GET /scrappers/1.json
  def show
    url = @scrapper.url
    @metatags = MetaInspector.new(url)
    @doc = @scrapper.products
  end

  # GET /scrappers/new
  def new
    @scrapper = Scrapper.new
  end

  # GET /scrappers/1/edit
  def edit
  end

  # POST /scrappers
  # POST /scrappers.json
  def create
    url = params[:scrapper][:url]
    @scrapper = Scrapper.new(user_id: current_user.id, url: url)
    # checking if scrapper is saved or not. This is to make sure we dont have crappy data in db.
    is_scrapper_saved = @scrapper.save
    # create products for scrapper only if it is valied and saved in db.
    if is_scrapper_saved
      doc = Nokogiri::HTML(open(url))
      items = doc.css(".s-item-container")
      items.each do |item|
       Product.create!(
        title: item.css(".s-access-title").text.strip,
        price: item.css(".s-price").text.split(',').map!(&:strip).join().gsub(/\p{Space}/,'').to_d,
        rating: item.css("span+ .a-text-normal").text.to_f,
        cod: item.css(".a-spacing-top-mini").text,
        scrapper_id: @scrapper.id,
        user_id: current_user.id)
      end
    end
    respond_to do |format|
      if is_scrapper_saved
        format.html { redirect_to scrappers_path, notice: 'Scrapper was successfully created.' }
        format.json { render :show, status: :created, location: @scrapper }
      else
        format.html { render :new }
        format.json { render json: @scrapper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scrappers/1
  # PATCH/PUT /scrappers/1.json
  def update
    respond_to do |format|
      if @scrapper.update(scrapper_params)
        format.html { redirect_to @scrapper, notice: 'Scrapper was successfully updated.' }
        format.json { render :show, status: :ok, location: @scrapper }
      else
        format.html { render :edit }
        format.json { render json: @scrapper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scrappers/1
  # DELETE /scrappers/1.json
  def destroy
    @scrapper.destroy
    respond_to do |format|
      format.html { redirect_to scrappers_url, notice: 'Scrapper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scrapper
      @scrapper = Scrapper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scrapper_params
      params.require(:scrapper).permit(:user_id, :url)
    end
end
