RSpec.describe DeputyAdapter do
  let(:row) do
    {
      "cpf" => "12345678901",
      "txNomeParlamentar" => "Deputy Name",
      "sgPartido" => "Party Name",
      "sgUF" => "sp"
    }
  end

  describe "#initialize" do
    it "assigns cpf correctly" do
      adapter = DeputyAdapter.new(row)
      expect(adapter.cpf).to eq("12345678901")
    end

    it "assigns attributes correctly" do
      adapter = DeputyAdapter.new(row)
      expect(adapter.attributes).to eq({
        name: "Deputy Name",
        cpf: "12345678901",
        party: "Party Name",
        state: "SP"
      })
    end

    it "handles nil values gracefully" do
      row_with_nil_values = {
        "cpf" => nil,
        "txNomeParlamentar" => nil,
        "sgPartido" => nil,
        "sgUF" => nil
      }

      adapter = DeputyAdapter.new(row_with_nil_values)
      expect(adapter.cpf).to be_nil
      expect(adapter.attributes).to eq({
        name: nil,
        cpf: nil,
        party: nil,
        state: nil
      })
    end

    it "trims and upcases the state" do
      row_with_space = {
        "cpf" => "12345678901",
        "txNomeParlamentar" => "Deputy Name",
        "sgPartido" => "Party Name",
        "sgUF" => "   mg   "
      }

      adapter = DeputyAdapter.new(row_with_space)
      expect(adapter.attributes[:state]).to eq("MG")
    end
  end
end
