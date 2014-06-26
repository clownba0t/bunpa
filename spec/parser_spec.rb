require 'spec_helper'

describe Bunpa::JapaneseTextParser do
  describe "#parse" do
    before(:each) do
      @content = <<TEST
ほんと、悲し過ぎるわよね。 でも、しかたないな。
そうだよ！「Very sad」	だもん。
TEST
      @parser = Bunpa::JapaneseTextParser.new
    end
 
    it "converts a Japanese text string into a list of components of different types (grammar, formatting, etc.) in the same order as they appear in the string" do
      expect(@parser.parse(@content).map { |c| c.text }.join).to eq(@content)
    end

    context "component categories" do
      it "marks spaces as component kind スペース" do
        expect(@parser.parse(" ").first.kind).to eq("スペース")
      end

      it "marks newlines as component kind 改行" do
        expect(@parser.parse("\n").first.kind).to eq("改行")
      end

      it "marks tabs as component kind タブ" do
        expect(@parser.parse("\t").first.kind).to eq("タブ")
      end
    end
  end
end
