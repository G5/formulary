module ElementHelper
  def element
    @element ||= elements.first
  end

  def elements
    @elements ||= \
      Nokogiri::HTML("<html><body>#{markup}</body></html>").
        css("body input, body textarea, body select")
  end
end

RSpec.configure do |config|
  config.include ElementHelper
end
