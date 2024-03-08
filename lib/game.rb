require_relative 'game_module'

class Game
  include GameFunction

  attr_accessor :remaining_guesses, :current_word, :chars_selected, :secret_word

  def initialize
    words = File.readlines('google-10000-english-no-swears.txt')
    @words = words.join('').split("\n")
    @word_minmax_length = (5..12)
    @remaining_guesses = 10
    @current_word = ''
  end

  def start_game
    puts 'Choose a character or try to guess the word, you can type "save" to save your progress '
    puts 'and "load" to back at your save point'
    puts
    random_word
    @word_length.times do |_|
      @current_word << '-'
    end
    player_select_char
  end

  def player_select_char
    return word_guessed if is_empty.length == 0

    return word_guessed if @remaining_guesses == 0

    puts @current_word
    puts "You have #{@remaining_guesses} guesses"
    print "\nChoose a character or guess the word: "
    @chars_selected = gets.chomp
    puts
    return guessed_available
  end

  def guessed_available
    if @chars_selected.downcase.split('').any? { |char| !'abcdefghijklmnopqrstuvwxyz'.include?(char) }
      print "You should select characters between A and Z: "
      @chars_selected = gets.chomp
      puts
      return guessed_available
    elsif @chars_selected == 'save' || @chars_selected == 'load'
      return save_or_load(@chars_selected, self)
    elsif @chars_selected.length > 1
      return word_guessed
    end
    @remaining_guesses -= 1
    play_game
  end

  def play_game
    if @secret_word.include?(@chars_selected.downcase)
      right_guess
    elsif @chars_selected == 'load_game'
      player_select_char
    else
      wrong_guess
    end
  end

  def right_guess
    @secret_word.split('').each_with_index do |char, index|
      if char == @chars_selected.downcase
        @current_word[index] = @chars_selected.downcase
      else
        next
      end
    end
    player_select_char
  end

  def wrong_guess
    puts "There's no #{@chars_selected}'s on the word"
    player_select_char
  end

  def word_guessed
    if @chars_selected == @secret_word
        return "Congratulations you win with #{11 - @remaining_guesses.to_i} guesses!"
    else
        puts
        return "You lose the correct word is: #{@secret_word}"
    end
  end

  def random_word
    @secret_word = @words[Random.rand(0..@words.length - 1)]
    @word_length = @secret_word.length
    random_word if !@word_minmax_length.include?(@word_length)
  end

  def is_empty
    (0..@current_word.length - 1).select { |char| @current_word[char] == '-' }
  end
end
