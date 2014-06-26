# Parses a string of Japanese text into a complete set of ordered components
# representing the grammar and formatting of the string. If printed in order,
# these components will complete reconstitute the original string.
#
# The basis of this module is the MeCab Japanese grammar parser. Unfortunately,
# this parser ignores certain formatting and other characters. As a result,
# the string must undergo a second analysis (after grammar parsing) to identify
# any missed characters and create components for them in the appropriate
# location within the component set.

require_relative 'grammar/parser'
require_relative 'text/component'

class Bunpa::JapaneseTextParser
  def parse(text)
    grammar_nodes = parse_text_grammar(text)
    extract_manuscript_components(text, grammar_nodes)
  end

  private
    def parse_text_grammar(text)
      grammar_parser = Bunpa::Grammar::Parser.new
      grammar_parser.parse(text)
    end

    def extract_manuscript_components(text, grammar_nodes)
      remaining_text = text.dup
      Enumerator.new do |yielder|
        if ! grammar_nodes.empty?
          grammar_node_enumerator = grammar_nodes.to_enum
          next_grammar_node = grammar_node_enumerator.next
          loop do
            component = extract_next_component_from_text(remaining_text, next_grammar_node)
            yielder.yield component
            remaining_text.gsub!(/\A#{Regexp.quote(component.text)}/, '')
            if next_grammar_node.text == component.text
              next_grammar_node = grammar_node_enumerator.next
            end
          end
        end
        extract_remaining_unknown_components(remaining_text).each { |c| yielder.yield c }
      end
    end

    def extract_next_component_from_text(text, grammar_node)
      grammar_node_regexp = Regexp.quote(grammar_node.text)
      component_text = text.scan(/\A(?:#{grammar_node_regexp}|[\s\n]|[^\s\n]+?(?=#{grammar_node_regexp}))/).first
      component_kind = determine_component_kind(component_text, grammar_node)
      Bunpa::Text::Component.new(component_text, component_kind)
    end

    def determine_component_kind(component_text, grammar_node)
      if grammar_node.text == component_text
        grammar_node.part_of_speech
      else
        determine_unknown_component_kind(component_text)
      end
    end

    def determine_unknown_component_kind(component_text)
      case component_text
        when "\n"
          "改行"
        when " "
          "スペース"
        when "\t"
          "タブ"
        else
          "未知"
      end
    end

    def extract_remaining_unknown_components(text)
      text.scan(/[\s\n]|[^\s\s]+/).map do |component_text|
        component_kind = determine_unknown_component_kind(component_text)
        Bunpa::Text::Component.new(component_text, component_kind)
      end
    end
end
