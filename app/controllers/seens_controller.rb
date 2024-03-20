class SeensController < ApplicationController
  before_action :set_seen, only: %i[ show edit update destroy ]

  # GET /seens or /seens.json
  def index
    sort_by = case params[:sort]
              when "asc" then "ORDER BY title ASC"
              when "desc" then "ORDER BY title DESC"
              when "highest_rating" then "ORDER BY user_rating DESC NULLS LAST"
              when "lowest_rating" then "ORDER BY user_rating ASC NULLS LAST"
              when "earliest_year" then "ORDER BY year ASC"
              when "latest_year" then "ORDER BY year DESC"
              else ""
              end

    @seens = ActiveRecord::Base.connection.exec_query("
      SELECT DISTINCT s.*, m.*, r.comment, r.rating AS user_rating
      FROM seen s
      LEFT JOIN movie m ON s.movieid = m.movieid
      LEFT JOIN review r ON s.movieid = r.movieid AND r.userid = #{@current_user.userid}
      WHERE s.userid = #{@current_user.userid}
      #{sort_by}
    ")
  end

  def mark_as_seen
    @movie = Movie.find(params[:movie_id])
    @seen = Seen.new(movie: @movie, user: current_user)

    if @seen.save
      redirect_to watchlists_path, notice: "Movie marked as seen successfully."
    else
      redirect_to watchlists_path, alert: "Failed to mark movie as seen."
    end
  end

  # GET /seens/1 or /seens/1.json
  def show
  end

  # GET /seens/new
  def new
    @seen = Seen.new
  end

  # GET /seens/1/edit
  def edit
  end

  # POST /seens or /seens.json
  def create
    @seen = Seen.new(seen_params)

    respond_to do |format|
      if @seen.save
        remove_watchlist_entry
        format.html { redirect_back(fallback_location: seens_url) }
        format.json { head :no_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @seen.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_watchlist_entry
    movie_id = params[:movieid]
    user_id = params[:userid]

    # Check if a watchlist entry exists with the given movieid and userid
    watchlist_entry = Watchlist.find_by(movieid: movie_id, userid: user_id)

    if watchlist_entry
      # Remove the watchlist entry
      watchlist_entry.destroy
    end

  end

  # PATCH/PUT /seens/1 or /seens/1.json
  def update
    respond_to do |format|
      if @seen.update(seen_params)
        format.html { redirect_to seen_url(@seen), notice: "Seen was successfully updated." }
        format.json { render :show, status: :ok, location: @seen }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @seen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seens/1 or /seens/1.json
  def destroy
    @seen.destroy!

    respond_to do |format|
      format.html { redirect_back(fallback_location: ) }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seen
      puts '<'
      puts params.inspect
      puts '>'
      @seen = Seen.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def seen_params
      params.permit(:userid, :movieid,:watchdate)
    end
end
