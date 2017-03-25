require 'readability'
require 'open-uri'
require 'phrasie'

class KeyWordExtractor
  attr_reader :url, :article
  def initialize(url)
    @url = url
    @article = Struct.new(:title, :terms, :url)
  end

  def parse_html
    html = open(self.url).read
    document = Readability::Document.new(html)
    title = document.title
    text = Nokogiri::HTML(document.content).text.strip.gsub(/\s+/, " ")
    [title, text, self.url]
  end

  def extract_keywords
    doc = parse_html
    keywords = Phrasie::Extractor.new.phrases(doc[1])
    print self.article.new(doc.first, keywords, doc[2])
  end

  def print article
    puts "Title: #{article.title}"
    puts "Keywords: #{article.terms.map(&:first).join(", ")} "
    puts "url: #{article.url}"
  end

  private :parse_html, :print

end

url = ARGV[0]
extractor = KeyWordExtractor.new(url)
extractor.extract_keywords
