module CsvHelper
  def self.setDelimiter(first_line)
    if first_line.include?(";")
      ";"
    elsif first_line.include?(",")
      ","
    else
      raise "Unknown delimiter in the CSV file"
    end
  end
end
