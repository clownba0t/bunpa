require_relative 'text/component'
require_relative 'grammar/parser'

# Parses a string of Japanese text into a complete set of ordered components
# representing the grammar and formatting of the string. If printed in order,
# these components will complete reconstitute the original string.
#
# The basis of this module is the MeCab Japanese grammar parser. Unfortunately,
# this parser ignores certain formatting and other characters. As a result,
# the string must undergo a second analysis (after grammar parsing) to identify
# any missed characters and create components for them in the appropriate
# location within the component set.
class Bunpa::JapaneseTextParser
  # Parses the provided text into a set of ordered grammatical and formatting
  # components (Bunpa::Text::Component) and returns an enumerator for accessing
  # these.
  def parse(text)
    @text = text
    text_to_components
  end

  private
    def grammar_nodes
      @grammar_nodes ||= parse_text_grammar(@text)
    end

    def parse_text_grammar(text)
      Bunpa::Grammar::Parser.new.parse(text)
    end

    def remaining_text
      @remaining_text ||= @text.dup
    end

    def grammar_node_enumerator
      @grammar_node_enumerator ||= grammar_nodes.to_enum
    end

    def current_grammar_node
      grammar_node_enumerator.peek
    end

    def move_to_next_grammar_node
      grammar_node_enumerator.next
    end

    def text_to_components
      Enumerator.new do |yielder|
        loop do
          component = next_component_from_text
          yielder.yield component
          prepare_for_next_component(component)
        end
        extract_remaining_unknown_components.each { |c| yielder.yield c }
      end
    end

    def next_component_from_text
      grammar_node_regexp = Regexp.quote(current_grammar_node.text)
      component_text = remaining_text.scan(/\A(?:#{grammar_node_regexp}|[\s\n]|[^\s\n]+?(?=#{grammar_node_regexp}))/).first
      component_kind = determine_component_kind(component_text)
      Bunpa::Text::Component.new(component_text, component_kind)
    end

    def determine_component_kind(component_text)
      if current_grammar_node.text == component_text
        current_grammar_node.part_of_speech
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

    def prepare_for_next_component(component)
      remaining_text.gsub!(/\A#{Regexp.quote(component.text)}/, '')
      if current_grammar_node.text == component.text
        move_to_next_grammar_node
      end
    end

    def extract_remaining_unknown_components
      remaining_text.scan(/[\s\n]|[^\s\s]+/).map do |component_text|
        component_kind = determine_unknown_component_kind(component_text)
        Bunpa::Text::Component.new(component_text, component_kind)
      end
    end
end
