class Match
    require 'yaml'
    attr_reader :secret_word, :guessing_word

    def initialize
        @dictionary = select_words_from_dictionary("5desk_wordlist.txt")
        @secret_word =  @dictionary.sample.split('')
        @guessing_word = Array.new(@secret_word.length, "_")
        @chances = 10
        @tried_letters = []
        
        puts "Press '1' to start a new game or '2' to load a game."
        game_choice = gets.chomp
        if game_choice == "1"
            self.play
        elsif game_choice == "2"
            self.load
        else
            puts "This isn't a valid option."
        end

    end

    def select_words_from_dictionary(dictionary)
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

    def play
        puts "\nThe new secret word has #{@secret_word.length} letters."
        loop do
            puts "Tried letters: #{@tried_letters.join("-")}\nYou have #{@chances} remaining chances. Insert a letter."
            self.display
            letter_input = gets.chomp.downcase
            puts "\n"
            self.check_letter(letter_input)
            if @secret_word == @guessing_word
                self.display
                puts "Victory!"
                break
            elsif @chances == 0
                puts "You lost.\n\nThe secret word was '#{@secret_word.join}'"
                break
            end
        end
    end

    def check_letter(letter)
        if letter == "save"
            self.save
        elsif @tried_letters.any?(letter)
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
    end

    def self.load
        puts "What save file do you want to load?"
        savename = gets.chomp
        data = YAML.load(File.read(savename))
        # self.new()
    end

end

Match.new


