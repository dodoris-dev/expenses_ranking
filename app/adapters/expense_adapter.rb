class ExpenseAdapter
  attr_reader :document_number, :attributes

  def initialize(row)
    @document_number = row["txtNumero"]
    @attributes = {
      liquid_value: BigDecimal(row["vlrLiquido"]&.gsub(",", ".") || "0", 10),
      supplier: row["txtFornecedor"],
      cpf: row["cpf"],
      issue_date: row["datEmissao"],
      invoice_url: row["urlDocumento"],
      document_number: @document_number
    }
  end
end
