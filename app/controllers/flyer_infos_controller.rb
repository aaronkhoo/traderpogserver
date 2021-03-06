require 'logging'

class FlyerInfosController < ApplicationController

  include Logging

  # @param [Object] index
  def getflyer(index)
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    @flyer_info = FlyerInfo.find(index, :select => "id, topimg, sideimg, capacity, speed, stormresist, multiplier, price, tier, load_time, disabled")
    @flyer_loc = FlyerInfosHelper.getflyerloc(@flyer_info, @language)
    @flyer_info.as_json.merge(@flyer_loc.first.as_json)
  end

  # GET /flyer_infos
  # GET /flyer_infos.json
  def index
    @flyer_infos = FlyerInfo.all(:select => "id, topimg, sideimg, capacity, speed, stormresist, multiplier, price, tier, load_time, disabled")
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])

    @complete_flyers = @flyer_infos.collect { |flyer_info|
      flyer_info.as_json.merge(FlyerInfosHelper.getflyerloc(flyer_info, @language).first.as_json)
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @complete_flyers }
    end
  end

  # GET /flyer_infos/1
  # GET /flyer_infos/1.json
  def show

    respond_to do |format|
      format.html { # show.html.erb
        @flyer_info = FlyerInfo.find(params[:id])
      }
      format.json {
        render json: getflyer(params[:id])
      }
    end

  end

  # GET /flyer_infos/new
  # GET /flyer_infos/new.json
  def new
    respond_to do |format|
      format.html {  # new.html.erb
        @flyer_info = FlyerInfo.new
      }
    end
  end

  # GET /flyer_infos/1/edit
  def edit
    @flyer_info = FlyerInfo.find(params[:id])
  end

  # POST /flyer_infos
  # POST /flyer_infos.json
  def create
    respond_to do |format|
      format.html {
        @flyer_info = FlyerInfo.new(params[:flyer_info])
        if @flyer_info.save
          GameInfoHelper.updateTime
          redirect_to @flyer_info, notice: 'Flyer info was successfully created.'
        else
          render action: "new"
        end
      }
      format.json {
        if ApplicationHelper.validate_key(request.headers["Validation-Key"])
          @flyer_info = FlyerInfo.new(params[:flyer_info])
          if @flyer_info.save
            GameInfoHelper.updateTime
            render json: @flyer_info.as_json(:only => [:id])
          else
            render json: @flyer_info.errors, status: :unprocessable_entity
          end
        else
          create_error(:forbidden, :post, params[:flyer_info], "Data incorrect")
        end
      }
    end
  end

  # PUT /flyer_infos/1
  # PUT /flyer_infos/1.json
  def update
    # JSON is not allowed to modify flyer_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @flyer_info = FlyerInfo.find(params[:id])
        if @flyer_info.update_attributes(params[:flyer_info])
          GameInfoHelper.updateTime
          redirect_to @flyer_info, notice: 'Flyer info was successfully updated.'
        else
          render action: "edit"
        end
      }
      format.json {
        create_error(:forbidden, :put, params[:flyer_info], "Data incorrect")
      }
    end
  end

  # DELETE /flyer_infos/1
  # DELETE /flyer_infos/1.json
  def destroy
    # JSON is not allowed to destroy item_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @flyer_info = FlyerInfo.find(params[:id])
        @flyer_info.destroy
        GameInfoHelper.updateTime
        redirect_to flyer_infos_url
      }
      format.json {
        create_error(:forbidden, :delete, params[:flyer_info], "Data incorrect")
      }
    end
  end
end
