class Game
  def initialize(name, loadGame)
    if loadGame==false
      word_secret = choose_word
      @game_data = {"Player" => name,
                    "turn" => 0,
                    "wordSecret" => word_secret,
                    "wordKnown" => Array.new(word_secret.length,"-"),
                    "letterTried" => []}      
    else
      require 'json'      
      @game_data = JSON.load File.read("save.json")
      p @game_data
    end    
    runGame
  end

  def choose_word
    file = File.open('google-10000-english-no-swears.txt')
    file_data = file.readlines.map(&:chomp)
    loop do
      word = file_data[1 + rand(file_data.length)].downcase.split('')
      if word.length > 5 && word.length < 12
        return word
      end
    end
  end

  def guess(letter)
      if @game_data["wordSecret"].include?(letter)
        for index in (0..@game_data["wordSecret"].length-1)
          if @game_data["wordSecret"][index]==letter
            @game_data["wordKnown"][index]=letter
          end
        end
      else
        @game_data["letterTried"].push(letter)
      end
  end

  def runGame    
    loop do
      @game_data["turn"]+=1
      if  @game_data["turn"]==10
        puts "Out of turns! You lost!"
        return  
      end        
      puts"\n----- Its turn #{@game_data["turn"]} out of 10-----"
      puts"\n This is what you know so far:\n\n #{@game_data["wordKnown"].join(" ")}"
      puts"\n These are the letters you already tried: \n\n #{@game_data["letterTried"].join(" ")}"
      puts"\nChoose your next guess attempt (type SAVE to save the game):}"      
      @letter=gets.chop.downcase        
      if @letter=="save"
          require 'json'
          out_data = @game_data.to_json
          File.open("save.json", 'w') { |file| file.write(out_data) }
          puts "Game saved. Exiting..."
          return
      elsif @letter.downcase==@game_data["wordSecret"].join("").downcase
          puts "This is the secret word! You won!"
          return
      end      
      guess(@letter[0])
    end
  end
  
end



puts "Hi! Welcome to hangman. Enter your name or LOAD to load an old game."
name=gets.chop
if name!="LOAD"
  newGame=Game.new(name,false)
else
  newGame=Game.new(name,true)
end

