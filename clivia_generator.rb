# do not forget to require your gem dependencies
require "httparty"
require "json"
require "terminal-table"
# do not forget to require_relative your local dependencies
require_relative "presenter"
require_relative "requester"

class CliviaGenerator
  # maybe we need to include a couple of modules?
  include Presenter
  include Requester
  include HTTParty
  base_uri "https://opentdb.com"

  def initialize(filename)
    # we need to initialize a couple of properties here
    @random = []
    @score = 0
    @filename = filename
  end

  def start
    # welcome message
    print_welcome
    load_questions
    
    # prompt the user for an action
    # keep going until the user types exit
    action = ""
    until action == "exit"
      action = select_main_menu_action
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" then puts "Thanks"

      end

    end
  end

  def random_trivia
    # load the questions from the api
    @questions = load_questions
    # questions are loaded, then let's ask them
    ask_questions
  end

  def ask_questions
    # ask each question
    @score = 0
    @questions.each do |question|
      valid = ask_question(question)
      
      if valid
        @score += 10
        puts "Correct answer... "
      else
        puts "Incorrect answer... "
        puts "Correct answer: #{HTMLEntities.new.decode(question[:correct_answer])}"
      end
    end
    print_score(@score)
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
    puts "Do you want to save your score? (y/n)"
    answer = ""
    until answer == "n" || answer == "y"
      print "> "
      answer = gets.chomp.downcase
      if answer == "y"
        puts "Type the name to assign to the score"
        print "> "
        name = gets.chomp
        name.empty? ? name = "Anonymous" : name
        data = { score:@score, name: }
        save(data)
      elsif answer == "n"
      else
        puts "Invalid option"
      end
    end
  end

  def save(data)
    # write to file the scores data
      if File.exist?(@filename)
      array_score = JSON.parse(File.read(@filename))
      array_score << data
  
      File.write(@filename, array_score.to_json)
      else
        File.write(@filename,[data].to_json)
      # File.open(data, 'w') do |archivo|
      #   archivo.write(cadena_json)
      end
      
  end
 
  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    requested = self.class.get("/api.php?amount=5")
    # then parse the questions
    requested_parse = JSON.parse(requested.body, symbolize_names: true)
    requested_parse[:results]
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
    requested_parse
  end

  def print_scores
    # print the scores sorted from top to bottom
    scores = JSON.parse(File.read(@filename))
    scores = scores.sort_by{|score| score["score"]}.reverse
    
    table = Terminal::Table.new
    table.title = "Top score"
    table.headings = ["name", "score"]

    array_new = []
    scores.each do |score|
    array_new << [score["name"],score["score"]]
    end
    
    table.rows = array_new
    puts table
  end
end

