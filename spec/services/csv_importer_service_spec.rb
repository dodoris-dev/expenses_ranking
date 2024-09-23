require 'rails_helper'
require 'rspec'
require 'csv'

RSpec.describe CsvImporterService, type: :service do
  let(:file_path) { '/home/doris/github/agendaedu/expenses_ranking/Ano-2024.csv' }
  let(:service) { described_class.new(file_path) }

  describe '#initialize' do
    it 'initializes with a file path' do
      expect(service.instance_variable_get(:@file_path)).to eq(file_path)
    end

    it 'reads the first line of the file' do
      allow(File).to receive(:open).with(file_path).and_yield(StringIO.new("test,header,line"))
      service
      expect(service.instance_variable_get(:@first_line)).to eq("test,header,line")
    end
  end

  describe '#set_delimiter' do
    it 'sets the delimiter based on the first line' do
      allow(File).to receive(:open).with(file_path).and_yield(StringIO.new("test;header;line"))
      allow(CsvHelper).to receive(:setDelimiter).with("test;header;line").and_return(';')

      expect(service.send(:set_delimiter)).to eq(';')
    end
  end

  describe '#call' do
    before do
      allow(service).to receive(:processing_csv)
      allow(service).to receive(:save_data)
    end

    it 'processes the CSV and saves data if there is deputy data' do
      service.instance_variable_set(:@deputies_data, [ { cpf: '123' } ])

      service.call

      expect(service).to have_received(:processing_csv)
      expect(service).to have_received(:save_data)
    end

    it 'does not save data if there are no deputies' do
      service.instance_variable_set(:@deputies_data, [])

      service.call

      expect(service).to have_received(:processing_csv)
      expect(service).not_to have_received(:save_data)
    end
  end

  describe '#processing_csv' do
    let(:row) { { "sgUF" => "ES", "cpf" => "123", "document_number" => "456" } }
    let(:csv_data) { [ row ] }

    before do
      allow(CSV).to receive(:foreach).and_yield(CSV::Row.new(row.keys, row.values))
      allow(DeputyAdapter).to receive(:new).and_return(double(attributes: { cpf: "123" }))
      allow(ExpenseAdapter).to receive(:new).and_return(double(attributes: { document_number: "456", cpf: "123" }))
    end

    it 'processes deputies and expenses for rows with sgUF = "ES"' do
      service.send(:processing_csv)

      expect(service.instance_variable_get(:@deputies_data)).to eq([ { cpf: "123" } ])
      expect(service.instance_variable_get(:@expenses_data)).to eq([ { document_number: "456", cpf: "123" } ])
    end

    it 'does not process rows with sgUF other than "ES"' do
      row["sgUF"] = "SP"
      allow(CSV).to receive(:foreach).and_yield(CSV::Row.new(row.keys, row.values))
      service.send(:processing_csv)

      expect(service.instance_variable_get(:@deputies_data)).to be_empty
      expect(service.instance_variable_get(:@expenses_data)).to be_empty
    end
  end

  describe '#deputy_exists?' do
    let(:deputy) { double(cpf: "123") }

    it 'returns true if the deputy already exists' do
      service.instance_variable_set(:@deputies_data, [ { cpf: "123" } ])

      expect(service.send(:deputy_exists?, deputy)).to be_truthy
    end

    it 'returns false if the deputy does not exist' do
      service.instance_variable_set(:@deputies_data, [ { cpf: "456" } ])

      expect(service.send(:deputy_exists?, deputy)).to be_falsey
    end
  end

  describe '#expense_exists?' do
    let(:expense) { double(document_number: "456") }

    it 'returns true if the expense already exists' do
      service.instance_variable_set(:@expenses_data, [ { document_number: "456" } ])

      expect(service.send(:expense_exists?, expense)).to be_truthy
    end

    it 'returns false if the expense does not exist' do
      service.instance_variable_set(:@expenses_data, [ { document_number: "789" } ])

      expect(service.send(:expense_exists?, expense)).to be_falsey
    end
  end

  describe '#save_data' do
    let(:deputy_data) { [ { cpf: "123" } ] }
    let(:expense_data) { [ { document_number: "456", cpf: "123" } ] }
    let(:deputies_map) { { "123" => 1 } }

    before do
      service.instance_variable_set(:@deputies_data, deputy_data)
      service.instance_variable_set(:@expenses_data, expense_data)
      allow(Deputy).to receive(:upsert_all)
      allow(Expense).to receive(:upsert_all)
      allow(Deputy).to receive(:where).with(cpf: [ "123" ]).and_return(double(pluck: deputies_map.to_a))
    end

    it 'upserts deputies and maps deputy_id to expenses' do
      service.send(:save_data)

      expect(Deputy).to have_received(:upsert_all).with(deputy_data, unique_by: :cpf)
      expect(Expense).to have_received(:upsert_all).with([ { document_number: "456", deputy_id: 1 } ], unique_by: :document_number)
    end
  end
end
