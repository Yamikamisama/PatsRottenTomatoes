require "net/http"
require "json"

#INDEX PAGE
get '/' do
	@user = User.find_or_create_by(username: "Pat")
	if @user.movies.empty? || @user.movies_stale?
    @user.fetch_movies!
  end
    @movies = @user.movies
  	erb :index
end

#UPDATE TO MOVIE FAVORITE BOOLEAN
put '/:id' do |id|
    if request.xhr?
      @movie = Movie.find(id)
      @movie.update!(params["movie"])
    else
    redirect '/'
  end
end

#MOVIE SHOW PAGE
# get '/movie/:id' do |id|
#   @movie = Movie.find(id)
#   erb :single_movie
# end

#FAVORITE MOVIE SHOW PAGE
get '/favorites/:id' do |id|
  @movies = Movie.where(user_id: id)
  erb :favorites
end

#PAST FILTERS SHOW PAGE
get '/filter/:id' do |id|
  @filters = Filter.where(user_id: id)
  erb :'filter/past_filters'
end

#FILTER SHOW PAGE BASED ON DATE AND RATING
get '/filter/:date/:rating' do |date, rating|
  @holder = []
  @movies = Movie.all
  @movies.each do |movie|
    if (Date.parse(movie.release_date) >= Date.parse(date)) && (movie.critics_score >= rating)
      @holder << movie
    end
  end
  erb :'filter/filter'
end

#CREATE NEW FILTERS
post '/filter' do
  p params
  @filter = Filter.create(params[:filter])
  redirect "/filter/#{@filter.release_date}/#{@filter.critic_rating}"
end

