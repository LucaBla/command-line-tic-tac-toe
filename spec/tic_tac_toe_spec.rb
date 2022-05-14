require './tic_tac_toe.rb'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { double(Player) }

  describe '#playable_field?' do
    
    before do
      game.create_board
    end

    context 'when field is playable' do

      it 'returns true' do
        playable_field = game.playable_fields.sample
        expect(game.playable_field?(playable_field)).to be true
      end
    end

    context 'when field is not playable' do
      it 'returns false' do
        unplayable_field = [7, 7]
        expect(game.playable_field?(unplayable_field)).to be false
      end
    end

    context 'when field was already played' do
      before do
        game.playable_fields.delete([2, 2])
      end
      it 'returns false' do
        unplayable_field = [2, 2]
        expect(game.playable_field?(unplayable_field)).to be false
      end
    end
  end

  describe '#set_mark' do
    before do
      game.create_board
      allow(player1).to receive(:mark).and_return('x')
      allow(player1).to receive(:fields).and_return(Array.new)
    end

    context 'when field is playable' do
      before do
        allow(game).to receive(:playable_field?).and_return(true)
      end

      it 'set mark on given field' do
        expect{game.set_mark(player1, [2, 2])}.to change { game.board[2][2] }
      end
    end

    context 'when field is not playable' do
      before do
        allow(GameError).to receive(:field_error)
        allow(game).to receive(:playable_field?).and_return(false)
        allow(player1).to receive(:play_round)
      end
      it 'gives an error' do
        expect(GameError).to receive(:field_error).once
        game.set_mark(player1, [7, 7])
      end
    end
  end

  describe '#gameover?' do
    context 'when one player has 3 symbols in one row, column or diagonal' do
      before do
        allow(game).to receive(:three_in_a_column?).and_return(true)
      end

      it 'returns true' do
        expect(game.gameover?(player1)).to be true
      end
    end

    context 'when no player has 3 symbols in a row, column, or diagonal' do
      before do
        allow(game).to receive(:three_in_a_column?).and_return(false)
        allow(game).to receive(:three_in_a_row?).and_return(false)
        allow(game).to receive(:three_in_a_diagonal?).and_return(false)
      end

      it 'returns nil' do
        expect(game.gameover?(player1)).to be nil
      end
    end
  end

  describe '#three_in_a_column?' do
    context 'When three marks of one player are in one column' do
      before do
        column = [[2, 2], [4, 2], [6, 2]]
        allow(player1).to receive(:fields).and_return(column)
      end
      it 'returns true' do
        expect(game.three_in_a_column?(player1)).to be true
      end
    end
    context 'When players marks are not three in one column' do
      before do
        column = [[2, 2], [4, 2], [2, 4]]
        allow(player1).to receive(:fields).and_return(column)
      end
      it 'returns false' do
        expect(game.three_in_a_column?(player1)).to be nil
      end
    end
  end

  describe '#three_in_a_row?' do
    context 'When three marks of one player are in a row' do
      before do
        row = [[2, 2], [2, 4], [2, 6]]
        allow(player1).to receive(:fields).and_return(row)
      end
      it 'returns true' do
        expect(game.three_in_a_row?(player1)).to be true
      end
    end
    context 'When players marks are not three in one row' do
      before do
        row = [[2, 2], [4, 2], [2, 4]]
        allow(player1).to receive(:fields).and_return(row)
      end
      it 'returns false' do
        expect(game.three_in_a_row?(player1)).to be nil
      end
    end
  end

  describe '#three_in_a_diagonal?' do
    context 'When three marks of one player are in a diagonal' do
      before do
        diagonal = [[2, 2], [4, 4], [6, 6]]
        allow(player1).to receive(:fields).and_return(diagonal)
      end
      it 'returns true' do
        expect(game.three_in_a_diagonal?(player1)).to be true
      end
    end
    context 'When players marks are not three in one diagonal' do
      before do
        diagonal = [[2, 2], [4, 2], [2, 4]]
        allow(player1).to receive(:fields).and_return(diagonal)
      end
      it 'returns false' do
        expect(game.three_in_a_diagonal?(player1)).to be nil
      end
    end
  end
end
