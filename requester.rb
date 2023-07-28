require "htmlentities"

module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    gets_option(["random", "scores", "exit"], ["random", "scores", "exit"])
  end

  def ask_question(question)
    # show category and difficulty from question
    decode_question = HTMLEntities.new.decode(question[:question])
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    # show the question
    puts decode_question
    # show each one of the options
    options = question[:incorrect_answers] << question[:correct_answer]
    decode_options = options.map { |option| HTMLEntities.new.decode(option) }
    shuffle_options = decode_options.shuffle!
    
    shuffle_options.each_with_index do |option, index|
      puts "#{index + 1}. #{option}"
    end
    print "> "
    answer = gets.chomp.to_i
    user_answer = shuffle_options[answer - 1]
    valid = HTMLEntities.new.decode(question[:correct_answer]) == user_answer
    valid
    # grab user input
  end

  def will_save?(score)
    # show user's score
    # ask the user to save the score
    # grab user input
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end
    # gests_option([random, scores, exit],[random, scores, exit],)

  def gets_option(prompt, options)
    # prompt for an input
    # keep going until the user gives a valid option
    input = ""
    loop do
      puts prompt.join(" | ")
      print "> "
      input = gets.chomp
      break if options.include?(input)

      puts "Invalid option"
    end
    input
  end
end