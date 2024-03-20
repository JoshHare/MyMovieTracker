class WatchlistsController < ApplicationController
  before_action :set_watchlist, only: %i[ show edit update destroy ]

  # GET /watchlists or /watchlists.json
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
    @watchlists = ActiveRecord::Base.connection.exec_query("
    SELECT s.*, m.*
    FROM watchlist s
    LEFT JOIN movie m ON s.movieid = m.movieid
    WHERE s.userid = #{@current_user.userid}
    #{sort_by}
    ")
  end

  # GET /watchlists/1 or /watchlists/1.json
  def show
  end

  # GET /watchlists/new
  def new
    @watchlist = Watchlist.new
  end

  # GET /watchlists/1/edit
  def edit
  end

  # POST /watchlists or /watchlists.json
  def create
    @watchlist = Watchlist.new(watchlist_params)

    respond_to do |format|
      if @watchlist.save
        format.html { redirect_back(fallback_location: watchlists_url) }
      format.json { head :no_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @watchlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watchlists/1 or /watchlists/1.json
  def update
    respond_to do |format|
      if @watchlist.update(watchlist_params)
        format.html { redirect_to watchlist_url(@watchlist)}
        format.json { render :show, status: :ok, location: @watchlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @watchlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watchlists/1 or /watchlists/1.json
  def destroy
    @watchlist.destroy!
    respond_to do |format|
      format.html { redirect_back(fallback_location: watchlists_url, notice: "watchlist was dd destroyed.") }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watchlist
      @watchlist = Watchlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def watchlist_params
      params.permit(:userid, :movieid)
    end
end
