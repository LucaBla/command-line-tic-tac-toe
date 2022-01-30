module TicTacToe
  BOARD_ROW_LINE = ' -------'
  BOARD_ROW = ['|' ,' ','|',' ', '|',' ', '|']
  BOARD_COLUMN = ['|','|','|','|','|','|','|']
  DIAGONAL = [[2, 2], [4, 4], [6, 6]]
  DIAGONAL2 = [[2, 6], [4, 4], [6, 2]]
  class Game
    attr_reader :playable_fields

    def initialize
      @board = Array.new(8) # 7
      start_game
    end

    def create_board
      row_index = 1
      @board.each_index do |row|
        if row.zero?
          @board[row] = [' ', ' ', '1', ' ', '2', ' ', '3']
        elsif row.odd?
          @board[row] = BOARD_ROW_LINE
          @playable_fields = [[2, 2], [2, 4], [2, 6], [4, 2], [4, 4], [4, 6], [6, 2], [6, 4], [6, 6]]
        else
          @board[row] = [row_index, '|', ' ', '|', ' ', '|', ' ', '|']
          row_index += 1
        end
      end
    end

    def print_board
      @board.each_index do |index|
        if @board[index].is_a? Array
          puts @board[index].join
        else
          puts @board[index]
        end
      end
      puts ''
    end

    def playable_field?(field)
      if @playable_fields.include?(field)
        true
      else
        false
      end
    end

    def set_mark(player, position)
      if playable_field?(position)
        @board[position[0]][position[1]] = player.mark
        @playable_fields.delete(position)
        player.fields.push(position)
      else
        GameError.field_error
        player.play_round(self)
      end
    end

    def gameover?(player)
      true if three_in_a_column?(player) || three_in_a_row?(player) || three_in_a_diagonal?(player) || board_full?
    end

    def three_in_a_column?(player, summand = 0)
      count = 0
      column = [[2, 2 + summand], [4, 2 + summand], [6, 2 + summand]]
      column.each do |field|
        count += 1 if player.fields.include?(field)
      end
      return true if count == 3

      three_in_a_column?(player, summand + 2) if summand < 4
      # if count != 3 then false end
    end

    def three_in_a_row?(player, summand = 0)
      count = 0
      row = [[2 + summand, 2], [2 + summand, 4], [2 + summand, 6]]
      row.each do |field|
        count += 1 if player.fields.include?(field)
      end
      return true if count == 3

      three_in_a_row?(player, summand + 2) if summand < 4
      # if count != 3 then false end
    end

    def three_in_a_diagonal?(player)
      count = 0
      DIAGONAL.each do |field|
        count += 1 if player.fields.include?(field)
      end
      return true if count == 3

      count = 0
      DIAGONAL2.each do |field|
        count += 1 if player.fields.include?(field)
      end
      return true if count == 3
    end

    def board_full?
      return true if @playable_fields.empty?
      return false unless @playable_fields.empty?
    end

    def start_game
      puts 'Do you wanna play against a human (0), a bot (1), or watch 2 bots (2)?'
      players=Player.create_players(gets.chomp)
      current_player = players[0]
      create_board
      print_board
      p players
      until current_player.play_round(self) == 'Gameover'
        if current_player == players[0] then current_player = players[1]
        else
          current_player = players[0]
        end
      end
      puts "#{current_player.mark} you won the Game!" unless board_full?
      puts 'Its a Draw!' if board_full?
    end
  end

  class Player
    attr_reader :fields, :mark

    def initialize
      @fields = []
      @mark = ''
      select_mark
    end

    def self.create_players(amount_of_bots)
      if amount_of_bots.to_i == 0
        player_one = Player.new
        player_two = Player.new
      elsif amount_of_bots.to_i == 1
        player_one = Player.new
        player_two = ComputerPlayer.new
      elsif amount_of_bots.to_i == 2
        player_one = ComputerPlayer.new
        player_two = ComputerPlayer.new
      else
        puts 'try again:'
        return self.create_players(gets.chomp)
      end
      [player_one, player_two]
    end

    def select_mark
      puts 'Select your mark!'
      @mark = gets.chomp.chr
      puts ''
    end

    def play_round(game)
      puts "#{@mark} Enter the field you want to mark (row, column)."
      game.set_mark(self, string_into_int_array(gets.chomp))
      puts ''
      game.print_board
      return 'Gameover' if game.gameover?(self)
    end

    def string_into_int_array(string)
      string = string.split(',')
      string[0] = string[0].to_i * 2
      string[1] = string[1].to_i * 2
      string
    end
  end

  class ComputerPlayer < Player
    def select_mark
      puts 'Select Computers mark!'
      @mark = gets.chomp.chr
      puts ''
    end

    def play_round(game)
      game.set_mark(self, game.playable_fields.sample)
      puts "#{@mark}'s turn:"
      puts ''
      game.print_board
      sleep 1.5
      return 'Gameover' if game.gameover?(self)
    end
  end

  class GameError
    def self.field_error
      puts 'field is not playable, try again.'
    end
  end
end

include TicTacToe

Game.new
