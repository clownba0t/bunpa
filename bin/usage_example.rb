#!/bin/env ruby

require_relative '../lib/bunpa'

text =<<-EOT
MeCabはオープンソースの形態素解析エンジンで、奈良先端科学技術大学院大学出身、現GoogleソフトウェアエンジニアでGoogle 日本語入力開発者の一人である工藤拓[1][2]によって開発されている。名称は開発者の好物「和布蕪（めかぶ）」から取られた。
開発開始当初はChaSenを基にし、ChaSenTNGという名前で開発されていたが、現在はChaSenとは独立にスクラッチから開発されている。ChaSenに比べて解析精度は同程度で、解析速度は平均3-4倍速い。
品詞情報を利用した解析・推定を行うことができる。MeCabで利用できる辞書はいくつかあるが、ChaSenと同様にIPA品詞体系で構築されたIPADICが一般的に用いられている。
MeCabはGoogleが公開した大規模日本語n-gramデータの作成にも使用された[3]。
Mac OS X v10.5及びv10.6のSpotlightやiPhone OS 2.1以降の日本語入力にも利用されている[4][5]。
EOT

puts "\nParsing text:"
puts "'#{text}'"

parser = Bunpa::JapaneseTextParser.new
components = parser.parse(text)

puts "\nIdentified components:"
reconstructed_text = ""

components.each do |component|
  reconstructed_text += component.text
  puts "#{component.text}\t(#{component.kind})"
end

puts "\nReconstructed text:"
puts "'#{reconstructed_text}'"

puts "\nSame as original?: #{(reconstructed_text == text) ? 'Yes' : 'No'}"
