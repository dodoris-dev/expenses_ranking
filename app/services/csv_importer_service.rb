# app/services/csv_import_service.rb
class CsvImporterService
  def initialize(file_path)
    @file_path = file_path
    @first_line = File.open(@file_path, &:readline)
    @symbol = set_delimiter
    @deputies_data = []
    @expenses_data = []
  end

  def call
   begin
    processing_csv
    save_data if @deputies_data.any?
   end
  end

  private

  def set_delimiter
    CsvHelper.setDelimiter(@first_line)
  end

  def processing_csv
    begin
      CSV.foreach(@file_path, headers: true, col_sep: @symbol, encoding: "bom|utf-8") do |row|
        next unless row["sgUF"] == "ES"

        deputy = DeputyAdapter.new(row)
        expense = ExpenseAdapter.new(row)

        @deputies_data << deputy.attributes unless deputy_exists?(deputy)
        @expenses_data << expense.attributes unless expense_exists?(expense)
      end

    rescue CSV::MalformedCSVError => e
      puts "There was an error processing your CSV file: #{e.message}"
    end
  end

  def deputy_exists?(deputy)
    @deputies_data.any? { |dep| dep[:cpf] == deputy.cpf }
  end

  def expense_exists?(expense)
    @expenses_data.any? { |exp| exp[:document_number] == expense.document_number }
  end

  def save_data
    Deputy.upsert_all(@deputies_data, unique_by: :cpf)
    cpf_list = @deputies_data.map { |dep| dep[:cpf] }
    deputies_map = Deputy.where(cpf: cpf_list).pluck(:cpf, :id).to_h

    @expenses_data.each do |expense|
      deputy_id = deputies_map[expense[:cpf].to_s]
      expense[:deputy_id] = deputy_id if deputy_id
      expense.delete(:cpf)
    end

    Expense.upsert_all(@expenses_data, unique_by: :document_number)
  end
end
