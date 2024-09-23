class DataController < ApplicationController
  def processing_csv
    puts "Processing CSV"
    CsvImporterService.new(Rails.root.join("Ano-2024.csv")).call
    puts "CSV was successfully processed"
    head :ok
  end
end
