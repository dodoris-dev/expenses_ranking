RSpec.describe ExpenseAdapter do
  let(:row) do
    {
      "txtNumero" => "12345",
      "vlrLiquido" => "100,50",
      "txtFornecedor" => "Supplier Name",
      "cpf" => "12345678901",
      "datEmissao" => "2024-09-22",
      "urlDocumento" => "http://example.com/invoice.pdf"
    }
  end

  describe "#initialize" do
    it "assigns document_number correctly" do
      adapter = ExpenseAdapter.new(row)
      expect(adapter.document_number).to eq("12345")
    end

    it "assigns attributes correctly" do
      adapter = ExpenseAdapter.new(row)
      expect(adapter.attributes).to eq({
        liquid_value: BigDecimal("100.50"), # Conversão de string para BigDecimal
        supplier: "Supplier Name",
        cpf: "12345678901",
        issue_date: "2024-09-22",
        invoice_url: "http://example.com/invoice.pdf",
        document_number: "12345"
      })
    end

    it "handles nil values gracefully" do
      row_with_nil_values = {
        "txtNumero" => nil,
        "vlrLiquido" => nil,
        "txtFornecedor" => nil,
        "cpf" => nil,
        "datEmissao" => nil,
        "urlDocumento" => nil
      }

      adapter = ExpenseAdapter.new(row_with_nil_values)
      expect(adapter.document_number).to be_nil
      expect(adapter.attributes).to eq({
        liquid_value: BigDecimal("0"), # Presumindo que nil se torne BigDecimal("0")
        supplier: nil,
        cpf: nil,
        issue_date: nil,
        invoice_url: nil,
        document_number: nil
      })
    end

    it "converts the liquid value from string to BigDecimal correctly" do
      row_with_decimal = {
        "txtNumero" => "67890",
        "vlrLiquido" => "250,75",
        "txtFornecedor" => "Another Supplier",
        "cpf" => "98765432100",
        "datEmissao" => "2024-09-22",
        "urlDocumento" => "http://example.com/invoice2.pdf"
      }

      adapter = ExpenseAdapter.new(row_with_decimal)
      expect(adapter.attributes[:liquid_value]).to eq(BigDecimal("250.75"))
    end
  end
end
