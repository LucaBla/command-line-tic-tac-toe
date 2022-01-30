module TicTacToe
  BOARD_ROW_LINE = '-------'
  BOARD_ROW = ['|' ,' ','|',' ', '|',' ', '|']
  BOARD_COLUMN = ['|','|','|','|','|','|','|']
  DIAGONAL = [[1, 1], [3, 3], [5, 5]]
  DIAGONAL2 = [[1, 5], [3, 3], [5, 1]]
  class Game
    attr_reader :playable_fields

    def initialize
      @board = Array.new(7)
      start_game
    end

    def create_board
      @board.each_index do |row|
        if row.even?
          @board[row] = BOARD_ROW_LINE
          @playable_fields = [[1, 1], [1, 3], [1, 5], [3, 1], [3, 3], [3, 5], [5, 1], [5, 3], [5, 5]]
        else
          @board[row] = ['|', ' ', '|', ' ', '|', ' ', '|']
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
        field_error
        play_round(player)
      end
    end

    def field_error
      puts 'field is not playable, try again.'
    end

    def gameover?(player)
      true if three_in_a_column?(player) || three_in_a_row?(player) || three_in_a_diagonal?(player)
    end

    def three_in_a_column?(player, summand = 0)
      count = 0
      column = [[1, 1 + summand], [3, 1 + summand], [5, 1 + summand]]
      column.each do |field|
        count += 1 if player.fields.include?(field)
      end
      return true if count == 3

      three_in_a_column?(player, summand + 2) if summand < 4
      # if count != 3 then false end
    end

    def three_in_a_row?(player, summand = 0)
      count = 0
      row = [[1 + summand, 1], [1 + summand, 3], [1 + summand, 5]]
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

    def play_round(player)
      print_board
      puts "#{player.mark} Enter the field you want to mark (row, column)."
      pick = gets.chomp
      pick = pick.split(',')
      pick[0] = pick[0].to_i
      pick[1] = pick[1].to_i
      set_mark(player, pick)
      print_board
      return 'Gameover' if gameover?(player)
    end

    def start_game
      player_one = Player.new
      player_two = Player.new
      current_player = player_one
      create_board
      until play_round(current_player) == 'Gameover'
        if current_player == player_one then current_player = player_two
        else
          current_player = player_one
        end
      end
      puts "#{current_player.mark} you won the Game!"
    end
  end

  class Player
    attr_reader :fields, :mark

    def initialize
      @fields = []
      @mark = ''
      select_mark
    end

    def select_mark
      puts 'Select your mark!'
      @mark = gets.chomp.chr
    end
  end
end

include TicTacToe

Game.new
