require 'rails_helper'

RSpec.describe 'DataController', type: :request do
  describe 'POST #processing_csv' do
    let(:csv_file_path) { Rails.root.join("Ano-2024.csv") }
    let(:csv_importer_service) { instance_double(CsvImporterService) }

    before do
      allow(CsvImporterService).to receive(:new).with(csv_file_path).and_return(csv_importer_service)
      allow(csv_importer_service).to receive(:call)
    end

    it 'calls CsvImporterService with the correct file' do
      post '/processing_csv'  # Usando string-based route

      expect(CsvImporterService).to have_received(:new).with(csv_file_path)
      expect(csv_importer_service).to have_received(:call)
    end

    it 'returns http status ok' do
      post '/processing_csv'

      expect(response).to have_http_status(:ok)
    end
  end
end
