# An extremely simple data object designed to store the information we care
# about for each analysed (grammatical/formatting) component in a text string.
module Bunpa::Text
  Component = Struct.new(:text, :kind)
end
