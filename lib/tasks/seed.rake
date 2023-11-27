namespace(:db) do
  namespace(:seed) do
    desc "Seeds database with test data"
    task test_data: :environment do
      load Rails.root.join("db/test_data_seeds.rb")
    end
  end
end
