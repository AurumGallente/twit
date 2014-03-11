class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_post  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :if_author, only: [:edit, :update, :destroy]


  # GET /comments
  # GET /comments.json
  def index

    @comments = Comment.where(:post_id => @post.id).order("id DESC").paginate(:page => params[:page])
    @comment = Comment.new
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = @post.id
    respond_to do |format|
      if @comment.save
        
        format.html { redirect_to post_comments_path(@post), notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
        format.js { @comments = Comment.where(:post_id => @post.id) }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js {  }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_comments_path(@post), notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_comments_path(@post) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
      
    end
    
    def set_post
      @post = Post.find(params[:post_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :post_id, :body)
    end
    
    def if_author
      @comment = Comment.find(params[:id])
      unless @comment.user_id == current_user.id
        flash.notice = "this is not your post"        
        redirect_to post_path
      end
    end
    

end
