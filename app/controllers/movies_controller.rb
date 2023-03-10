# frozen_string_literal: true

class MoviesController < ApplicationController
  skip_before_action :authenticate_user!, only: %w[index]
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :check_admin, only: %i[create edit destroy update]
  # GET /movies or /movies.json
  def index
    if params[:category_id].present?
      @pagy, @movies = pagy(Movie.ordered.where(category: params[:category_id]), items: 6)
    else
      @pagy, @movies = pagy(Movie.ordered, items: 6)
    end
  end

  # GET /movies/1 or /movies/1.json
  def show; end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit; end

  # POST /movies or /movies.json
  def create
    if current_user.admin?
      @movie = Movie.new(movie_params)

      respond_to do |format|
        if @movie.save
          format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
          format.json { render :show, status: :created, location: @movie }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @movie.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to { |format| format.html { redirect_to movies_url } }
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :text, :ratings, :category)
    end

    def check_admin
      unless current_user.is_admin?
        redirect_to root_path, alert: "You are not authorized to perform this action."
      end
    end
end
