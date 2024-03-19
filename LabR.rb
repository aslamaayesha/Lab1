class Mastermind
    attr_reader :code, :guesses, :feedback
  
    def initialize
      @code = CodeGenerator.new.generateCode
      @guesses = []
      @feedback = []
    end
  
    def begin
      puts "You are playing Mastermind!!"
      puts "Basically you have to guess the colors code (R, G, B, Y, O, P) in 12 given turns."
      puts "To make your guess, you'ld use only the first letter of the color"
      puts "Like, 'RGBY' for Red Green Blue Yellow."
      puts ""
  
      12.times do |turn|
        puts "Turn #{turn + 1}:"
        guess = getGuess
        feedback = Feedback.new(@code, guess).giveFeedback
        @guesses << guess
        @feedback << feedback
        displayBoard
  
        if guess == @code
          puts "Congratulations! You guessed the code in #{turn + 1} turns."
          return
        end
      end
  
      puts "Sorry, you ran out of turns. The secret code was #{@code}."
    end
  
    private
  
    def getGuess
      loop do
        print "Enter your guess: "
        guess = gets.chomp.upcase
        return guess if validGuess?(guess)
  
        puts "Invalid guess. Please enter a 4-letter combination of colors (R, G, B, Y, O, P)."
      end
    end
  
    def validGuess?(guess)
      guess.length == 4 && guess.split("").all? { |color| %w[R G B Y O P].include?(color) }
    end
  
    def displayBoard
      puts "Guesses:"
      @guesses.each_with_index do |guess, index|
        puts "#{index + 1}: #{guess} - #{@feedback[index]}"
      end
      puts ""
    end
end
  
  class CodeGenerator
    COLORS = %w[R G B Y O P].freeze
  
    def generateCode
      Array.new(4) { COLORS.sample }.join
    end
  end
  
  class Feedback
    def initialize(code, guess)
      @code = code
      @guess = guess
    end
  
    def giveFeedback
      feedback = ""
      exactMatches, nearMatches = calculateMatches
      exactMatches.times { feedback += "●" }
      nearMatches.times { feedback += "○" }
      feedback
    end
  
    private
  
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
  
  game = Mastermind.new
  game.begin
