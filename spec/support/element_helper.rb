module ElementHelper
  def element
    @element ||= \
      Nokogiri::HTML("<html><body>#{markup}</body></html>").
        css("body > *").
        first
  end
end

RSpec.configure do |config|
  config.include ElementHelper
end
