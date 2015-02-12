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

#FAVORITES SHOW PAGE
get '/favorites' do
  @movies = Movie.where(favorite: true)
  erb :index
end

#CRITIC RATING SHOW PAGE
get '/critic-rating' do
  @movies = Movie.order(critics_score: :desc )
  erb :index
end

#AUDIENCE RATING SHOW PAGE
get '/audience-rating' do
  @movies = Movie.order(audience_score: :desc )
  erb :index
end

#MOVIE RATING SHOW PAGE
get '/movie-rating' do
  @movies = Movie.order(:mpaa_rating)
  erb :index
end

#RELEASE DATE PAGE
get '/release-date' do
  @movies = Movie.order(:release_date)
  erb :index
end

#YEAR SHOW PAGE
get '/year' do
  @movies = Movie.order(year: :desc )
  erb :index
end

#RUNTIME SHOW PAGE
get '/runtime' do
  @movies = Movie.order(runtime: :desc )
  erb :index
end

#PAST FILTERS SHOW PAGE
get '/filter/:id' do |id|
  @filters = Filter.where(user_id: id)
  erb :'filter/past_filters'
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