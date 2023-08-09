require File.join(Rails.root, "config", "global_variables.rb")

class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  skip_before_action :authorized, only: %i[ index show]

  # GET /posts
  # def index
  #   @posts = Post.all
  #   render json: @posts
  # end
  # GET /posts?q={query}&cat={category}&page={page_number}&size={page_size}
  def index
    if params[:q]
      @posts = Post.recent.where("title LIKE ? OR author LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    elsif params[:cat]
      @posts = Post.recent.where(category: params[:cat])
    elsif params[:user_id]
      @posts = Post.recent.where(user_id: params[:user_id])
    else
      @posts = Post.recent
    end
  
    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # # GET /posts/latest/:page
  # def latest
  #   @posts = Post.recent.paginate(page: params[:page], per_page: $per_page)

  #   if @posts.total_pages < params[:page].to_i
  #     render error: {error: "No more post can be found"}, status: :range_not_satisfiable
  #   else
  #     render json: @posts
  #   end
  # end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = @user
    @post.author = @user.username

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render error: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    # checks for the identity of the user
    if @post.user_id != @user.id
      render json: { error: 'Unauthorized. You are not the creator of this post' }, status: :unauthorized
    elsif @post.update(post_params)
      render json: @post
    else
      render error: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    # checks for the identity of the user
    if @post.user_id != @user.id
      render error: { error: 'Unauthorized. You are not the creator of this post' }, status: :unauthorized
    else
      @post.destroy
      render json: {}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :category, :user_id)
    end
end
