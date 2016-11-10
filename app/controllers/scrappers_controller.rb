class ScrappersController < ApplicationController
  before_action :set_scrapper, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /scrappers
  # GET /scrappers.json
  def index
    @scrappers = Scrapper.all.where(:user_id => current_user.id)
  end

  # GET /scrappers/1
  # GET /scrappers/1.json
  def show
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
    @scrapper = Scrapper.new(scrapper_params)
    
    fuck = scrapper_params
    puts "............#{fuck}..................."  
    
    require 'open-uri' 
    require 'metainspector'
    page = MetaInspector.new('http://www.amazon.in/s/ref=nb_sb_ss_i_4_3?url=search-alias%3Daps&field-keywords=dji+&rh=i%3Aaps%2Ck%3Adji+')
    tit= page.title
    meta= page.meta_tags
    puts "..........#{tit}................"
    puts "...........#{meta}..............."

    respond_to do |format|
      if @scrapper.save
        format.html { redirect_to @scrapper, notice: 'Scrapper was successfully created.' }
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
