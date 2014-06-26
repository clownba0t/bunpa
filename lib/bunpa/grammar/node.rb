# Extremely simple data object used to represent the informatio we care about
# from an MeCab dump
module Bunpa::Grammar
  Node = Struct.new(:text, :part_of_speech)
end
