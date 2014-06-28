Bunpa
==========================

Bunpa is an extremely simple wrapper around the MeCab Japanese grammar parser. It was designed with two key features in mind:

1. Simplicity - only returns the text and major part of speech for each component
2. Completeness - ensures that whitespace and any unknown characters are preserved

## Background

Bunpa parses Japanese text into a set of ordered components. Each component represents either a part of speech (noun, verb, etc.) or formatting (whitespace, etc.) All components have a text value (exactly as they appear in the text provided) and kind (usually part of speech).

All grammatical information is provided by the excellent [MeCab](http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html) Japanese part of speech and morphological analyser. Formatting information is inserted into the set of components in a post processing step (it is not done by MeCab). These components have a fake 'kind' assigned to them. Currently the following kinds of formatting components are handled by Bunpa:
* spaces (スペース)
* tabs (タブ)
* newlines (改行)

Any components that cannot be identified by either MeCab or Bunpa are marked as unknown (未知).

## Installation

From within your application's base directory:

1. Edit your Gemfile and add:

        gem 'bunpa'

2. Install the gem:

        bundle

## Usage

Bunpa operates as a very simple parser. It returns the components it identifies as an Array of Bunpa::Text::Component objects, in the same order as they appear in the document. Each Component object has two accessors - 'text' and 'kind', which return the text value and part of speech of the component respectively.

Basic usage is as follows:

```
require 'bunpa'

# Create the parser
parser = Bunpa::JapaneseTextParser.new

# Get an enumerable of Bunpa::Text::Components
components = parser.parse("A: こんにちは！ お元気ですか。\nB: はい、元気です！")

components.each do |component|
  puts "#{component.text}\t(#{component.kind}"
end
```

This would output:

```
A       (名詞)
:       (名詞)
        (スペース)
こんにちは      (感動詞)
！      (記号)
        (スペース)
お      (接頭詞)
元気    (名詞)
です    (助動詞)
か      (助詞)
。      (記号)

        (改行)
B       (名詞)
:       (名詞)
        (スペース)
は      (助詞)
い      (動詞)
、      (記号)
元気    (名詞)
です    (助動詞)
！      (記号)
```

For a slightly more detailed example, see the `usage_example.rb` script in the `bin` directory.

## Notes

This is very much a work in progress - it only has minimal testing at the moment, so use at your own risk :)
