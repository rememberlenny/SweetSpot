class FilmsController < ApplicationController
  # before_action :authenticate_user!, :except => [:show]
  before_action :set_film, only: [:show, :edit, :update, :destroy]
  before_filter :force_story_path, only: [:show, :index]

  def show
  end

  # GET /films/1
  # GET /films/1.json
  def show
    redirect_to story_path
  end

  # GET /films/new
  def new
    @film = Film.new
  end

  # GET /films/1/edit
  def edit
  end

  # POST /films
  # POST /films.json
  def create
    @story = Story.friendly.find(params[:story_id])
    @film = @story.films.new(film_params)

    respond_to do |format|
      if @film.save
        format.html { redirect_to @story, notice: 'Film was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /films/1
  # PATCH/PUT /films/1.json
  def update
    respond_to do |format|
      if @film.update(film_params)
        format.html { redirect_to @film, notice: 'Film was successfully updated.' }
        format.json { render :show, status: :ok, location: @film }
      else
        format.html { render :edit }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1
  # DELETE /films/1.json
  def destroy
    @film.destroy
    respond_to do |format|
      format.html { redirect_to films_url, notice: 'Film was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def force_story_path
      @story = Story.friendly.find(params[:story_id])
      if current_user.nil? || @story.user_id != current_user.id
        redirect_to story_path(@story)
      else
        redirect_to edit_story_path(@story)
      end
    end

    def set_film
      @story = Story.friendly.find(params[:story_id])
      if @story.user_id != current_user.id
        redirect_to story_path
      end
      @film = @story.films.find(params[:id])
      @hotspot = @film.hotspots.new
      @hotspots = @film.hotspots.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def film_params
      params.require(:film).permit(:title, :description, :image, :image_cache_id, :remove_image)
    end
end
