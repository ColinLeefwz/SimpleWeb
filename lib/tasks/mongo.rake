namespace :db do
  namespace :test do
    task :prepare do
      db_config = YAML.load(File.open(Rails.root.to_s+"/config/mongoid.yml"))['test']['sessions']['default']
      host, port = db_config['hosts'].first.split(':')
      connection = Mongo::Connection.new(host, port)
      connection.drop_database(db_config['database'])
      fix_root = "#{Rails.root}/test/fixtures"
      Dir[fix_root+"/*.yml"] .each do |f|
        model_name = f.split('/').last.split('.').first
        coll = connection.db(db_config['database'])[model_name]
        YAML.load(File.open(f)).values.each do |doc|
          coll.insert(doc)
        end
      end
    end
  end
end

