class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    num_seen(params[:id])
    num_watchlist(params[:id])
    avg_rating(params[:id])
    fav_actor(params[:id])
    fav_director(params[:id])
    top_genres(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def login
  end

  def authenticate
    user = User.find_by(name: params[:name])
    if user && user.password == params[:password]
      session[:user_id] = user.id
      redirect_to user_path(user.userid), notice: 'Logged in successfully!'
      puts "SUCCESS LOGIN"
    else
      flash[:alert] = 'Invalid name or password, please try again'
      puts flash[:alert]
      redirect_to login_url
    end
  end

  def logout
    session[:user_id] = nil
    @current_user = session[:user_id]
    redirect_to root_url, notice: 'Logged out successfully!'
  end

  def num_seen(userid)
    query = "SELECT COUNT(*) AS num_seen
              FROM Movie m
              JOIN Seen s ON m.MovieiD = s.movieid
              WHERE s.userid = '#{userid}';"
    result = ActiveRecord::Base.connection.execute(query)
    @num_seen = result.first['num_seen'].to_i
  end

  def num_watchlist(userid)
    query = "SELECT COUNT(*) AS num_seen
              FROM Movie m
              JOIN Watchlist s ON m.MovieiD = s.movieid
              WHERE s.userid = '#{userid}';"
    result = ActiveRecord::Base.connection.execute(query)
    @num_watchlist = result.first['num_seen'].to_i
  end

  def avg_rating(userid)
    query = "SELECT AVG(rating) AS avg
              FROM Review
              WHERE userid = '#{userid}';"
    result = ActiveRecord::Base.connection.execute(query)
    @avg_rating = result.first['avg'].to_f
  end

  def fav_actor(userid)
    query = "SELECT Actor.name, COUNT(*) AS appearances
              FROM Actor
              JOIN MovieActor ON Actor.actorid = MovieActor.actorid
              JOIN movie ON Movieactor.movieid = movie.movieid
              JOIN seen ON movie.movieid = seen.movieid
              WHERE seen.userid = '#{userid}'
              GROUP BY actor.name
              ORDER BY appearances DESC
              LIMIT 1;"
    result = ActiveRecord::Base.connection.execute(query)
    @fav_actor = result.to_a
  end

  def fav_director(userid)
    query = "SELECT movie.director, COUNT(*) AS num_movies_seen
              FROM movie
              JOIN seen ON movie.movieid = seen.movieid
              WHERE seen.userid = '#{userid}'
              GROUP BY movie.director
              ORDER BY num_movies_seen DESC
              LIMIT 1;"
    result = ActiveRecord::Base.connection.execute(query)
    @fav_director = result.to_a
  end

  def top_genres(userid)
    query = "SELECT genre.name, COUNT(*) AS num_movies_seen
              FROM genre
              JOIN Moviegenre ON genre.genreid = Moviegenre.genreid
              JOIN movie ON Moviegenre.movieid = movie.movieid
              JOIN seen ON movie.movieid = seen.movieid
              WHERE seen.userid = '#{userid}'
              GROUP BY genre.name
              ORDER BY num_movies_seen DESC
              LIMIT 3;"
    result = ActiveRecord::Base.connection.execute(query)
    @top_genres = result.to_a
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # app/controllers/users_controller.rb
def user_params
  params.require(:user).permit(:name, :email, :password)
end

end
