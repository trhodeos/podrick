class Show {
  final String title;
  final String description;
  final String imageUrl;
  final String rssUrl;

  Show(this.title, this.description, this.imageUrl, this.rssUrl);
}

class Episode {
  final String title;
  final String description;
  final String imageUrl;
  final String rssUrl;

  Episode(this.title, this.description, this.imageUrl, this.rssUrl);
}

class ResultsPage<T> {
  final int totalResults;
  final int page;
  final int resultsPerPage;
  final Iterable<T> results;
  ResultsPage(this.totalResults, this.page, this.resultsPerPage, this.results);
}

// Client to access the API found at:
// https://www.audiosear.ch/swagger
class AudioSearchClient {
  ResultsPage<Show> searchShows(String query, {
    int page: 1,
    int resultsPerPage: 10,
  }) {
    List<Show> output = new List<Show>();
    output.add(new Show("Hidden Brain", "Some desc", "", ""));
    return new ResultsPage(1, 1, 1, output);
  }

  ResultsPage<Episode> searchEpisodes(String query, {
    int page: 1,
    int resultsPerPage: 10,
  }) {
    List<Episode> output = new List<Episode>();
    output.add(new Episode("Some episode", "some desc", "", ""));
    return new ResultsPage(1, 1, 1, output);
  }
}