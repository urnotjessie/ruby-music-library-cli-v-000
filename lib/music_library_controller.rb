class MusicLibraryController

  attr_accessor :path, :music_importer

  def initialize(path = "./db/mp3s")
    @path = path
    @music_importer = MusicImporter.new(@path)
    @music_importer.import
  end

  def call
    puts "Welcome to your music library!"
    puts "To list all of your songs, enter 'list songs'."
    puts"To list all of the artists in your library, enter 'list artists'."
    puts"To list all of the genres in your library, enter 'list genres'."
    puts"To list all of the songs by a particular artist, enter 'list artist'."
    puts"To list all of the songs of a particular genre, enter 'list genre'."
    puts"To play a song, enter 'play song'."
    puts"To quit, type 'exit'."
    puts"What would you like to do?"
    user_input = gets.strip
    while user_input != "exit"
      if user_input == "list songs"
        self.list_songs
      elsif user_input == "list artists"
        self.list_artists
      elsif user_input == "list genres"
        self.list_genres
      elsif user_input == "list artist"
        self.list_songs_by_artist
      elsif user_input == "list genre"
        self.list_songs_by_genre
      elsif user_input == "play song"
        self.play_song
      end
      puts "What would you like to do?"
      user_input = gets.strip
    end
  end

  def list_songs
    sorted_files = self.music_importer.files.sort_by {|file| file.split("-", 3)[1]}
    sorted_files.each_with_index do |file, index|
      puts "#{index + 1}. #{file.chomp(".mp3")}"
    end
  end

  def list_artists
    sorted_artists = Artist.all.sort_by {|artist| artist.name}
    sorted_artists.each_with_index do |artist, index|
      puts "#{index + 1}. #{artist.name}"
    end
  end

  def list_genres
    sorted_genres = Genre.all.sort_by {|genre| genre.name}
    sorted_genres.each_with_index do |genre, index|
      puts "#{index + 1}. #{genre.name}"
    end
  end

  def list_songs_by_artist
    puts "Please enter the name of an artist:"
    artist_name = gets.strip
    songs = Artist.find_or_create_by_name(artist_name).songs
    sorted_songs = songs.sort_by {|song| song.name}
    sorted_songs.each_with_index do |song, index|
      puts "#{index + 1}. #{song.name} - #{song.genre.name}"
    end
  end

  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    genre_name = gets.strip
    songs = Genre.find_or_create_by_name(genre_name).songs
    sorted_songs = songs.sort_by {|song| song.name}
    sorted_songs.each_with_index do |song, index|
      puts "#{index + 1}. #{song.artist.name} - #{song.name}"
    end
  end

  def play_song
    puts "Which song number would you like to play?"
    song_number = gets.strip.to_i
    sorted_files = self.music_importer.files.sort_by {|file| file.split("-", 3)[1]}
    if song_number.between?(1, sorted_files.length)
      target = sorted_files[song_number - 1].split("-", 3)
      puts "Playing #{target[1].strip} by #{target[0].strip}"
    end
  end

end
