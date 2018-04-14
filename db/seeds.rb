require "csv"
movie_attrs = []
CSV.foreach(Rails.root.join("movies_metadata.csv"), { :headers => true }) do |csv|
  title, overview, image_path, vote_average = csv[20], csv[9],  csv[11], csv[22]

  image_url = image_path.nil? ? "" : "https://image.tmdb.org/t/p/w300" + image_path

  movie_attrs << {
    title: title,
    overview: overview,
    image_url: image_url,
    vote_average: vote_average
  }
end

Movie.bulk_insert do |worker|
  movie_attrs.each do |attrs|
    worker.add(attrs)
  end
end
