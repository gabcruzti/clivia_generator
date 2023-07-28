require_relative "clivia_generator"

# capture command line arguments (ARGV)
filename = ARGV[0]

filename = "arreglo.json" if filename.nil?
ARGV.clear

trivia = CliviaGenerator.new(filename)
trivia.start
