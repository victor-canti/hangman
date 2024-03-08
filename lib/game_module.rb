require 'json'

module GameFunction
  def save_file(saved_data)
    Dir.mkdir('saved') unless Dir.exist?('saved')
    File.open('saved/save_game.json', 'w') do |file|
      file.write(saved_data)
    end
    return 'Game saved'
  end

  def save_game(obj)
    saved_data = {
        current_word: obj.current_word,
        remaining_guesses: obj.remaining_guesses,
        secret_word: obj.secret_word
    }.to_json
    save_file(saved_data)
  end

  def load_game(obj)
    begin
      saved_data = JSON.load_file('saved/save_game.json')
      obj.current_word = saved_data['current_word']
      obj.remaining_guesses = saved_data['remaining_guesses']
      obj.secret_word = saved_data['secret_word']
      obj.chars_selected = 'load_game'
      play_game
    rescue
      "there's no saved game"
    end
  end

  def save_or_load(user_input, game_obj)
    @current_secret_word = game_obj.secret_word
    if user_input == 'save'
      save_game(game_obj)
    else
      load_game(game_obj)
    end
  end
end