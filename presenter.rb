module Presenter
  def print_welcome
    # print the welcome message
    puts ["###################################",
          "#   Welcome to Clivia Generator   #",
          "###################################"].join("\n")
  end

  def print_score(score)
    # print the score message
    puts "Well done! Your Score is #{score}"
    puts "--------------------------------------------------"
  end
end