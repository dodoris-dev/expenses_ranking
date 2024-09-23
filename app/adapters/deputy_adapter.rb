class DeputyAdapter
  attr_reader :cpf, :attributes

  def initialize(row)
    @cpf = row["cpf"]
    @attributes = {
      name: row["txNomeParlamentar"],
      cpf: @cpf,
      party: row["sgPartido"],
      state: row["sgUF"]&.strip&.upcase
    }
  end
end
