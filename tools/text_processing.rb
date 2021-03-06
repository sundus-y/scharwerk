# This is a class for automatic text upgrade
class TextProcessing
  def initialize(text)
    @text = text
  end

  def change_quotes
    @text.gsub(/[„“]/, '„' => '«', '“' => '»')
  end

  def remove_trailing_whitespace
    @text.gsub(/ $/, '').gsub(/^ /, '').squeeze(' ')
  end

  def capitalize_line(line)
    line.capitalize
    # work only for ruby 2.4.0 and later
  end

  def uppercase_line?(line)
    line.match?(/\p{Upper}/) && !line.match?(%r{[\p{Lower}—./\\]})
  end

  def remove_line_breaks
    @text.gsub(/-\n(\S+)\s/, "\\1\n")
    # In plain English, we looking for a pattern (/(-\n)(\S+)\s/),
    # that represent, hyphen then end of a line, then any charcter except
    # whitespace, then whitespace and replace with second group of pattern
    # \\1 means referance to (\S+), then end of a line \n
  end

  def capitalize_heading(text)
    # TODO: somehow remuve new_text variable
    new_text = ''
    text.each_line do |line|
      uppercase_line?(line) ? new_text << line.capitalize : new_text << line
    end
    new_text
  end

  def add_empty_line
    @text.match?(/\S\z/) ? @text << "\n" : @text
    # \z match end of a string
    # \S match any symbol except whitespace and Line seperator
  end

  def replace_double_chars
    @text.gsub(/([+, -, =, —, X])(\n)[+, -, =, —, X]\s/, "\\1\n")
  end
end
