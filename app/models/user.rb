class User < ActiveRecord::Base
  has_many :movies
  has_many :filters

  #CHECK FOR NEW MOVIES EVERY REFRESH
  def movies_stale?
    Time.new - self.movies.last.updated_at >= 900
  end

  def fetch_movies!
   uri = URI.parse("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=vymecugmgctsrxbbbmztpnb9")
   http = Net::HTTP.new(uri.host, uri.port)
   request = Net::HTTP::Get.new(uri.request_uri)
   response = http.request(request)
   if response.code == "200"
     @result = JSON.parse(response.body)
   end

    #THIS IS ULGY REFACTOR LATER
    @result["movies"].each do |movie|
      if (self.movies.exists?(title: movie["title"]) != true) && (movie["abridged_cast"].length >= 5)
       self.movies.create(title: movie["title"],synopsis: movie["synopsis"],mpaa_rating: movie["mpaa_rating"],year: movie["year"],runtime: movie["runtime"],release_date: movie["release_dates"]["theater"],critics_score: movie["ratings"]["critics_score"],audience_score: movie["ratings"]["audience_score"],poster_thumbnail: movie["posters"]["thumbnail"], cast1: movie["abridged_cast"][0]["name"] || nil, cast2: movie["abridged_cast"][1]["name"] || nil, cast3: movie["abridged_cast"][2]["name"] || nil, cast4: movie["abridged_cast"][3]["name"] || nil, cast5: movie["abridged_cast"][4]["name"] || nil)
     end
   end
 end
end
