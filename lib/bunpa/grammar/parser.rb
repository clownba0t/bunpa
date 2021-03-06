require 'MeCab'
require_relative 'node'

module Bunpa::Grammar
  # An extremely simple wrapper around the MeCab gem. It takes a plain text
  # output from mecab itself and splits it up to obtain the text and part of
  # speech for each component.
  class Parser
    # Parses the provided text using MeCab. Returns an array of
    # Bunpa::Grammar::Node objects, which store the text and part of speech
    # value of each.
    def parse(text)
      raw_nodes = parse_text_grammar(text)
      build_node_list(raw_nodes)
    end
  
    private
      def parse_text_grammar(text)
        parser = MeCab::Tagger.new
        parser_output = parser.parse(text)
        raw_node_data = parser_output.gsub(/EOS\n\Z/, "").chomp
        raw_node_data.split(/\n/)
      end
  
      def build_node_list(raw_nodes)
        raw_nodes.map do |raw_node|
          (text, part_of_speech) = parse_raw_node(raw_node)
          Bunpa::Grammar::Node.new(text, part_of_speech)
        end
      end
  
      def parse_raw_node(raw_node)
        (text, grammar_data) = raw_node.split(/\t/)
        part_of_speech = grammar_data.split(/,/)[0]
        [ text, part_of_speech ]
      end
  end
end
