require 'action_view'

class ExcelFormatter
  include ActionView::Helpers::SanitizeHelper

  def initialize(html_content)
    @html_content = html_content
  end

  def to_plain_text
    # Convert <br> and <br /> to newlines
    intermediate_text = @html_content.gsub(/<br\s*\/?>/, "\n")
    # Strip remaining HTML tags
    sanitize(intermediate_text, tags: [])
  end
end