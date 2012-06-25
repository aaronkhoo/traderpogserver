class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index

    # no JSON API for this. We can only access all posts through the webpage.
    respond_to do |format|
      format.html { # index.html.erb
        @posts = Post.all
      }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    @post = Post.find(params[:id], :select => "id, img, latitude, longitude, name, region, user_id")
    @itemids = @post.post_items.all(:select => "item_info_id")
    @items = @itemids.collect {
        |itemid| ItemInfosHelper.getitembylocale(itemid.item_info_id, @language)
    }
    @item_locs = ItemLoc.where("locale = ?", "#{@language}")

    respond_to do |format|
      format.html   # show.html.erb
      format.json {
        json_output = @post.as_json
        json_output['items'] = @items.as_json
        render json: json_output
      }
    end
  end

  # GET /posts/new
  def new
    # no JSON API for this. We create new posts using posts.json
    respond_to do |format|
      format.html { # new.html.erb
        @post = Post.new
      }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    respond_to do |format|
      # Check that the user exists first
      begin
        @user = User.find((params[:post])[:user_id])
      rescue
        @user = nil
      end
      if @user.nil?
        # no corresponding user for this post. Not allowed.
        @errormsg = { "errormsg" => "Userid does not exist" }
        format.html { render 'posts/error', status: :forbidden }
        format.json { render json: @errormsg, status: :forbidden }
      else
        @post = Post.new(params[:post])

        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render json: @post.as_json(:only => [:id]) }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    # no JSON API for this. We can only delete posts through the webpage.
    respond_to do |format|
      format.html {
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to posts_url
      }
    end
  end

  # GET /posts/scan
  def scan
    respond_to do |format|

      current_longitude = request.headers["traderpog-longitude"]
      current_latitude = request.headers["traderpog-latitude"]
      if (current_longitude != nil) && (current_latitude != nil)
        @posts = Post.all
        #@post = Post.where("longitude = ?", "#{current_longitude}")
        # compute region
        # lookup based on region
        format.json { render json: @posts.as_json }
      else
        format.json { render :status => 400, :json => { :status => :error, :message => "Error!" }}
      end
    end
  end

end