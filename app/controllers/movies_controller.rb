class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1 or /movies/1.json
  def show
    search_actor(@movie.title)
    search_genre(@movie.title)
    @onmywatchlist = Watchlist.where(userid: @current_user.userid, movieid: @movie.movieid).first
    @is_in_watchlist = @onmywatchlist.present?
    @seenthis = Seen.where(userid: @current_user.userid, movieid: @movie.movieid).first
    @is_seen = @seenthis.present?

  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
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
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def search
    # Start with an empty array to store the search results
    @movies = []

    # Build the SQL query dynamically based on the search parameters
    query = "SELECT * FROM movie WHERE 1=1"

    # Add conditions for each search parameter
    if params[:title_cont].present?
      query += " AND title ILIKE '%#{params[:title_cont]}%'"
    end

    if params[:year_eq].present?
      query += " AND year = #{params[:year_eq]}"
    end

    if params[:runtime_eq].present?
      query += " AND runtime = #{params[:runtime_eq]}"
    end

    if params[:director_cont].present?
      query += " AND director ILIKE '%#{params[:director_cont]}%'"
    end


    if params[:min_rating].present?
      query += " AND rating >= '#{params[:min_rating]}'"
    end

    if params[:max_rating].present?
      query += " AND rating <= '#{params[:max_rating]}'"
    end


    if params[:cast_cont].present?
      actor_query = "SELECT Movie.*
                      FROM Movie
                      JOIN MovieActor ON Movie.movieid = MovieActor.movieid
                      JOIN Actor ON MovieActor.actorid = Actor.actorid
                      WHERE Actor.name ILIKE '%#{params[:cast_cont]}%'"

      combined = "#{query} INTERSECT #{actor_query}"
      query = combined
    end

    if params[:movie] && params[:movie][:genre_ids].present?
      @selected_genres = params[:movie][:genre_ids].map(&:to_i)
      genre_query = "SELECT Movie.*
          FROM Movie
          JOIN MovieGenre ON Movie.movieid = MovieGenre.movieid
          JOIN Genre ON MovieGenre.genreid = Genre.genreid
          WHERE Genre.genreid IN (#{@selected_genres.join(',')})
          GROUP BY Movie.movieid
          HAVING COUNT(DISTINCT Genre.genreid) = #{@selected_genres.length}"
      combined = "#{query} INTERSECT #{genre_query}"
      query = combined
    end

    case params[:sort_by]
    when "alpha_order"
      query += " ORDER BY title ASC"
    when "rating_desc"
      query += " ORDER BY rating DESC"
    when "rating_asc"
      query += " ORDER BY rating ASC"
    when "min_runtime"
      query += " ORDER BY runtime ASC"
    when "max_runtime"
      query += " ORDER BY runtime DESC"
    when "earliest_release_year"
      query += " ORDER BY year ASC"
    when "latest_release_year"
      query += " ORDER BY year DESC"
    end

    puts query
    query += " LIMIT 20;"
    result = ActiveRecord::Base.connection.execute(query)
    @movies = result.map { |record| Movie.new(record) }


    render 'search'
  end


  def search_actor(title)
    title = title.gsub("'","''")
    query = "SELECT Actor.name
             FROM Actor
             JOIN MovieActor ON Actor.ActorID = MovieActor.ActorID
             JOIN Movie ON Movie.MovieID = MovieActor.MovieID
             WHERE Movie.Title = '#{title}';"
    result=  ActiveRecord::Base.connection.execute(query)
    @actors = result.map { |record| Actor.new(record) }

  end

  def search_genre(title)
    title = title.gsub("'","''")
    query = "SELECT Genre.name
             FROM Genre
             JOIN MovieGenre ON Genre.GenreID = MovieGenre.GenreID
             JOIN Movie ON Movie.MovieID = MovieGenre.MovieID
             WHERE Movie.Title = '#{title}';"
    result=  ActiveRecord::Base.connection.execute(query)
    @genres = result.map { |record| Genre.new(record) }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie =  Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.fetch(:movie, {})
    end
end
