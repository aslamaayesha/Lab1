class Mastermind
  attr_reader :code, :guesses, :feedback

  # Initializes the game with a secret code, empty guess and feedback arrays.
  def initialize
    @code = CodeGenerator.new.generateCode
    @guesses = []
    @feedback = []
  end

  # Begins the game and guides the player through each turn.
  def begin
    # Display game instructions and rules.
    puts "Welcome to Mastermind!"
    puts "Try to guess the secret code of colors (R, G, B, Y, O, P) in 12 turns."
    puts "Use the first letter of each color to make your guess."
    puts "For example, 'RGBY' for Red Green Blue Yellow."
    puts ""

    # Loop for 12 turns or until the code is guessed.
    12.times do |turn|
      puts "Turn #{turn + 1}:"
      guess = get_guess
      feedback = Feedback.new(@code, guess).giveFeedback
      @guesses << guess
      @feedback << feedback
      displayBoard

      # Check if the guess is correct and end the game if so.
      if guess == @code
        puts "Congratulations! You guessed the code in #{turn + 1} turns."
        return
      end
    end

    puts "Sorry, you ran out of turns. The secret code was #{@code}."
  end

  private

  # Prompts the player for a valid guess.
  def get_guess
    loop do
      print "Enter your guess: "
      guess = gets.chomp.upcase
      return guess if valid_guess?(guess)

      puts "Invalid guess. Please enter a 4-letter combination of colors (R, G, B, Y, O, P)."
    end
  end

  # Checks if a guess is valid (4 letters, each a valid color).
  def valid_guess?(guess)
    guess.length == 4 && guess.split("").all? { |color| %w[R G B Y O P].include?(color) }
  end

  # Displays the current board with all guesses and feedback.
  def displayBoard
    puts "Guesses:"
    @guesses.each_with_index do |guess, index|
      puts "#{index + 1}: #{guess} - #{@feedback[index]}"
    end
    puts ""
  end
end

# Generates a random secret code for the game.
class CodeGenerator
  COLORS = %w[R G B Y O P].freeze

  # Generates a random 4-letter code from the available colors.
  def generateCode
    Array.new(4) { COLORS.sample }.join
  end
end

# Calculates and provides feedback for a guess.
class Feedback
  def initialize(code, guess)
    @code = code
    @guess = guess
  end

  # Generates feedback based on exact and near matches.
  def giveFeedback
    feedback = ""
    exactMatches, nearMatches = calculateMatches
    exactMatches.times { feedback += "●" }
    nearMatches.times { feedback += "○" }
    feedback
  end

  private

  # Calculates exact and near matches between the code and guess.
  def calculateMatches
    codeNum = Hash.new(0)
    guess_counts = Hash.new(0)
    exactMatches = 0
    nearMatches = 0

    @code.chars.each_with_index do |color, index|
      if color == @guess[index]
        exactMatches += 1
      else
        codeNum[color] += 1
        guess_counts[@guess[index]] += 1
      end
    end

    @guess.chars.each do |color|
      next unless codeNum[color] > 0

      nearMatches += 1
      codeNum[color] -= 1
    end

    [exactMatches, nearMatches]
  end
end

# Create and start a new game of Mastermind.
game = Mastermind.new
game.begin
