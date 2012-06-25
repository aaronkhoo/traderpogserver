class ItemInfosController < ApplicationController

  # @param [Object] index
  def getitem(index)
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    ItemInfosHelper.getitembylocale(index, @language)
  end

  # GET /item_infos
  # GET /item_infos.json
  def index
    @item_infos = ItemInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_infos }
    end
  end

  # GET /item_infos/1
  # GET /item_infos/1.json
  def show
    respond_to do |format|
      format.html { # show.html.erb
        @item_info = ItemInfo.find(params[:id])
      }
      format.json {
        render json: getitem(params[:id])
      }
    end
  end

  # GET /item_infos/new
  # GET /item_infos/new.json
  def new
    respond_to do |format|
      format.html {  # new.html.erb
        @item_info = ItemInfo.new
      }
    end
  end

  # GET /item_infos/1/edit
  def edit
    @item_info = ItemInfo.find(params[:id])
  end

  # POST /item_infos
  # POST /item_infos.json
  def create
    # JSON is not allowed to create item_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @item_info = ItemInfo.new(params[:item_info])
        if @item_info.save
          redirect_to @item_info, notice: 'Item info was successfully created.'
        else
          render action: "new"
        end
      }
    end
  end

  # PUT /item_infos/1
  # PUT /item_infos/1.json
  def update
    # JSON is not allowed to modify item_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @item_info = ItemInfo.find(params[:id])
        if @item_info.update_attributes(params[:item_info])
          redirect_to @item_info, notice: 'Item info was successfully updated.'
        else
          render action: "edit"
        end
      }
    end
  end

  # DELETE /item_infos/1
  # DELETE /item_infos/1.json
  def destroy
    # JSON is not allowed to destroy item_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @item_info = ItemInfo.find(params[:id])
        @item_info.destroy
        redirect_to item_infos_url
      }
    end
  end

  # GET /item_infos/random
  def random
    count = ItemInfo.count
    index = rand(count) + 1
    respond_to do |format|
      format.json {
        render json: getitem(index)
      }
    end
  end
end