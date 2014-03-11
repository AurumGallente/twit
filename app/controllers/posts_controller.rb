class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :if_author, only: [ :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).paginate(:page => params[:page])    
    else
      @posts = Post.all.order("id DESC").paginate(:page => params[:page]) 
      respond_to do |format|
        format.html {render action: 'index'}
        format.js {}
      end
    end
    

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    
  end

  # GET /posts/new
  def new
    @post = Post.new
    respond_to do |format|
      format.js { render 'posts/new'}
      format.html { render action: 'new' }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        @post.reload
        format.html { redirect_to post_comments_path(@post), notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
        format.js { render action: 'create'}
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
    
    def if_author
      @post = Post.find(params[:id])
      unless @post.user_id == current_user.id
        flash.notice = "this is not your post"        
        redirect_to post_path
      end
    end
    

      

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :tag_list, :page)
    end
end
