require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diags
def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def display_board(b)
  system 'clear'
  puts ''
  puts '     |     |'
  puts "  #{b[1]}  |  #{b[2]}  |  #{b[3]}"
  puts '     |     |'
  puts '------------------'
  puts '     |     |'
  puts "  #{b[4]}  |  #{b[5]}  |  #{b[6]}"
  puts '     |     |'
  puts '------------------'
  puts '     |     |'
  puts "  #{b[7]}  |  #{b[8]}  |  #{b[9]}"
  puts '     |     |'
  puts ''
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = INITIAL_MARKER }
  board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def player_places_piece!(board)
  square = ''
  value = ''
  loop do
    prompt("Choose a Square: #{empty_squares(board).join(',  ')}")
    square = gets.chomp.to_i
    # start of select returns an array of all keys whose square == ' '
    # by adding .include,  we then see if the
    # number (square) they selected is included
    break if empty_squares(board).include?(square)
    prompt 'Sorry,  not a valid choice.'
  end
  board[square] = PLAYER_MARKER
  display_board(board)
end

def board_full?(board)
  empty_squares(board).empty?
end

def detect_winner(board)
  WINNING_LINES.each do |w|
#    first iteration before refactor

#    if  board[w[0]] == PLAYER_MARKER &&
#        board[w[1]] == PLAYER_MARKER &&
#        board[w[2]] == PLAYER_MARKER
#      return 'Player'
#    elsif board[w[0]] == COMPUTER_MARKER &&
#          board[w[1]] == COMPUTER_MARKER &&
#          board[w[2]] == COMPUTER_MARKER
#          return 'Computer'
#    end

#first refactor
# if board.values_at(w[0], w[1], w[2]).count(PLAYER_MARKER) == 3
# use splat * syntactical sugar to shorten further.

    if board.values_at(*w).count(PLAYER_MARKER) == 3
      return 'Player'
    # elsif b.values_at(w[0], w[1], w[2]).count(COMPUTER_MARKER) == 3
  elsif board.values_at(*w).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  false
end

def someone_won?(board)
  # !! forcibly turn into a boolean,  is either nil or string of winner.
  !!detect_winner(board)
end

def computer_places_piece!(board)
  # sample gets a random sample from an array.  empty_squares returns an array.
  square = empty_squares(board).sample
  board[square] = COMPUTER_MARKER
  display_board(board)
end

loop do
  board = initialize_board
  loop do
    display_board(board)
    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end
  display_board(board)

  if someone_won?(board)
    prompt('#{detect_winner(board)} won!')
  else
    prompt("It's a Tie!")
  end
  prompt 'Play Again?'
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
