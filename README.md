# Ranking de gastos parlamentares
Esse projeto é uma aplicação Ruby on Rails que permite a análise de dados sobre os gastos de parlamentares do Espirito Santo. Dados abertos disponibilizados [aqui](https://dadosabertos.camara.leg.br/swagger/api.html?tab=staticfile#staticfile).

## Primeiros passos
Essas instruções lhe orientarão a obter uma cópia funcional do projeto em sua máquina local, juntamente com os pré-requisitos necessários para desenvolvimento e teste.

### Pré-requisitos

Antes de iniciar, você precisará ter as seguintes ferramentas instaladas:

- **Ruby 3.3.5**: Linguagem de programação utilizada no projeto.
- **Rails 7.2**: Framework para desenvolvimento web em Ruby.
- **PostgreSQL**: Banco de dados utilizado para armazenamento de dados.
- **Beekeeper Studio**: Para gerenciamento visual do banco de dados (opcional).
- **Insomnia**: Para testar requisições API (opcional).

  Além disso, você precisará clonar o repositório em sua máquina local:
```bash
git clone https://github.com/seu-usuario/ranking-de-gastos.git
cd ranking-de-gastos
```

### Instalação do PostgreSQL

No terminal:

```bash
sudo apt update
sudo apt install postgresql
```

Após a instalação, certifique-se de que o PostgreSQL está rodando:
```bash
sudo systemctl start postgresql.service
```

### Instalando todas as gemas listadas na Gemfile
```
bundle install
```

### **Configuração de Variáveis de Ambiente**
Com propósito de manter a segurança e flexibilidade, essa aplicação utiliza variáveis de ambiente para configurar o acesso ao banco de dados.
Crie um arquivo `.env` para definir as variáveis de ambiente necessárias para o projeto. Use o arquivo `.env.example` como base:

```markdown
DB_CONNECTION=
DB_HOST=
DB_DATABASE=
DB_USERNAME=
DB_PASSWORD=
```

## Criação do banco de dados
Criar o banco de dados:
```bash
rails db:create
```

Carregar o schema (em vez de rodar as migrations):
```bash
rails db:schema:load
```

## Execução dos testes unitários
Para rodar os testes unitários e garantir que tudo está funcionando conforme esperado:

```bash
bundle exec rspec
````

Estado atual:

![image](https://github.com/user-attachments/assets/9c84e16e-1516-4ede-9868-44fd1ab3bced)

Para visualizar a cobertura de testes:

Abra ```coverage/index.html```

![image](https://github.com/user-attachments/assets/854b70d4-99dc-45b9-b88b-bd4b983926e4)


### Tecnologias utilizadas
- Ruby 3.3.5
- Rails 7.2
- PostgreSQL 14.13 - Gerenciamento de dados
- Beekeper Studio - Gerenciamento de base de dados
- Insomnia - Teste de requisições
- RSpec - Testes unitários
- Rubocop - Linter
- SimpleCov - Cobertura de testes

### Recursos
- [Documentação do Ruby on Rails](https://guides.rubyonrails.org/)
- [Documentação do PostgreSQL](https://www.postgresql.org/docs/)
- [Documentação do RSpec](https://rspec.info/documentation/)

#### Rodando manualmente o processamento de CSV
Caso queira, é possível rodar um script que "amarra" toda a lógica d processamento do seu CSV

```rb
require 'csv'
require_relative '/home/doris/github/agendaedu/expenses_ranking/app/helpers/csv_helper.rb' #TROQUE PELO CAMINHO DE SEU CSV AQUI

path = Rails.root.join('./teste.csv')

first_line = File.open(path, &:readline)

symbol = CsvHelper.setDelimiter(first_line)

deputies_to_register = []
expenses_to_register = []

def adaptDeputyData(deputy, deputies_to_register)
  unless deputies_to_register.any? { |dep| dep[:cpf] == deputy['cpf'] }
    acronym = deputy['sgUF']&.strip&.upcase
    deputies_to_register << { name: deputy['txNomeParlamentar'], cpf: deputy['cpf'], party: deputy['sgPartido'], state: acronym }
  end
end

def adaptExpenseData(expense, expenses_to_register)
  value = BigDecimal(expense['vlrLiquido']&.gsub(',', '.') || "0", 10)

  unless expenses_to_register.any? { |exp| exp[:document_number] == expense['txtNumero'] }
    expenses_to_register << { liquid_value: value, supplier: expense['txtFornecedor'], cpf: expense['cpf'], issue_date: expense['datEmissao'], invoice_url: expense['urlDocumento'], document_number: expense['txtNumero'] }
  end
end

CSV.foreach(path, headers: true, col_sep: symbol, encoding: 'bom|utf-8').with_index do |row, index|
  if row['sgUF'] != 'ES'
    next
  end

  adaptDeputyData(row, deputies_to_register)
  adaptExpenseData(row, expenses_to_register)
end

if deputies_to_register.any?
  Deputy.upsert_all(deputies_to_register, unique_by: :cpf)
  cpf_list = deputies_to_register.map { |dep| dep[:cpf] }
  deputies_map = Deputy.where(cpf: cpf_list).pluck(:cpf, :id).to_h

  expenses_to_register.each do |expense|
    deputy_id = deputies_map[expense[:cpf].to_s]
    expense[:deputy_id] = deputy_id if deputy_id
    expense.delete(:cpf)
  end

  Expense.upsert_all(expenses_to_register, unique_by: :document_number)
end
```
