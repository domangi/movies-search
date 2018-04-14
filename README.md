# movies-search

An example application for integrating Rails 5 API with Elasticsearch

# Usage

##### Download Elasticsearch

    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.3.zip
    unzip elasticsearch-6.2.3.zip

##### Clone the repository

    git clone https://github.com/domangi/movies-search.git

##### Enter the application folder and run bundle install

    cd movies-search; bundle install

##### Run migrations

    rails db:migrate

##### Configure ElasticSearch

Open config/elasticsearch.yml and change your elasticsearch binary path if needed.

##### Run tests

To be sure that your setup is working run the test suite.

    bundle exec rpsec

##### Add example data

You can prepopulate your movies database from a large dataset published on Kaggle (https://www.kaggle.com/rounakbanik/the-movies-dataset):

First start your elasticsearch server so that the data can be indexed while it is created. You can start your elasticsearch server by running:

    elasticsearch-6.2.3/bin/elasticsearch

Now run the seed script to import the dataset

    rails db:seed

##### Run the server

    rails s

#### API

**Url**: *GET /api/v1/movies*

**Params:** q=[string] **required**

**Example request:** *GET /api/v1/movies?q=Roman*

**Example response:**

  ``` JSON

      [
        {
          "_index":"movies",
          "_type":"movie",
          "_id":"95088",
          "_score":11.549209,
          "_source":
          {
            "id":95088,
            "title":"Roma",
            "overview":"A virtually plotless, gaudy, impressionistic portrait of Rome through the eyes of one of its most famous citizens.", "image_url":"https://image.tmdb.org/t/p/w300/rqK75R3tTz2iWU0AQ6tLz3KMOU1.jpg",
            "vote_average":6.6,
            "created_at":"2018-04-14T10:30:49.110Z",
            "updated_at":"2018-04-14T10:30:49.110Z"
          }
        },
        ...
      ]

  ```
