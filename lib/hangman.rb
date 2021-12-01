module HangmanDictionary
    def self.select_words_from_dictionary(dictionary)
        game_dictionary = []
        File.open(dictionary, 'r') do |content|
            until content.eof?
                word = content.readline(chomp: true)
                if word.length >= 5 && word.length <= 12
                game_dictionary << word.downcase
                end
            end
        game_dictionary
        end
    end
end

class Match
    require 'yaml'
    attr_reader :secret_word, :guessing_word

    def initialize
        @dictionary = HangmanDictionary.select_words_from_dictionary("5desk_wordlist.txt")
        @secret_word =  @dictionary.sample.split('')
        @guessing_word = Array.new(@secret_word.length, "_")
        @chances = 10
        @tried_letters = []
    end

    def play
        puts "\nThe secret word has #{@secret_word.length} letters."
        loop do
            puts "Tried letters: #{@tried_letters.join("-")}\nYou have #{@chances} remaining chances. Insert a letter."
            self.display
            letter_input = gets.chomp.downcase
            puts "\n"
            if letter_input == "save"
                self.save
            elsif letter_input == "load"
                LoadedMatch.new
                break
            elsif letter_input == "new"
                puts "Starting a new game.\n "
                Match.new.play
                break
            else
                self.check_letter(letter_input)
            end

            if @secret_word == @guessing_word
                self.display
                puts "Victory!"
                break
            elsif @chances == 0
                puts "You lost.\nThe secret word was '#{@secret_word.join}'"
                break
            end
        end
    end

    def check_letter(letter)
        if @tried_letters.any?(letter)
            puts "You already tried '#{letter}'. Try another."
        elsif ("a".."z").to_a.none?(letter)
            puts "This isn't a valid letter. Try a single letter from 'a' to 'z'"
        else
            @tried_letters << letter
            @secret_word.each_with_index do |correct_letter, index|
                if letter == correct_letter
                    @guessing_word[index] = letter
                end
            end
            @chances -= 1 if @secret_word.none?(letter)
        end
    end

    def display
        puts @guessing_word.join(" ")
        puts
    end

    def save
        string = YAML.dump ({
            :secret_word => @secret_word,
            :guessing_word => @guessing_word,
            :chances => @chances,
            :tried_letters => @tried_letters
        })
        puts "Save game as:"
        savename = gets.chomp + ".yaml"
        File.open(savename, 'w') do |content|
            content.puts string
        end
        puts "Game saved as '#{savename}'\n "
    end
end

class LoadedMatch < Match
    def initialize
        @secret_word = nil
        @guessing_word = nil
        @chances = nil
        @tried_letters = nil
        self.loadgame
    end

    def loadgame
        puts "What game do you want to load?"
        filename = gets.chomp + ".yaml"
        puts "Game '#{filename}' loaded\n "
        loaded_data = YAML.load(File.read(filename))
        @secret_word = loaded_data[:secret_word]
        @guessing_word = loaded_data[:guessing_word]
        @chances = loaded_data[:chances]
        @tried_letters = loaded_data[:tried_letters]
        self.play
    end
end

def start_menu
    puts "___________________________\n\nPress '1' to start a new game or '2' to load a game."
    game_choice = gets.chomp
    if game_choice == "1"
        Match.new.play
    elsif game_choice == "2"
        LoadedMatch.new
    else
        puts "This isn't a valid option."
    end
end

puts "\nLet's play Hangman!\n\nYou will have 10 chances to guess the letters of a secret word. If you wish to save the game, load a previoulsy saved one or start a new game, you can insert 'save', 'load' or 'new' respectively instead of a letter during the game.\n\nGood luck!"

loop do
    start_menu
end


