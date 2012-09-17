namespace :test do
  task :prepare do
    db_config = YAML.load(File.open(Rails.root.to_s+"/config/mongoid.yml"))['test']['sessions']['default']
    host, port = db_config['hosts'].first.split(':')
    connection = Mongo::Connection.new(host, port)
    connection.drop_database(db_config['database'])
    db = connection.db(db_config['database'])
    fix_root = "#{Rails.root}/test/fixtures"
    Dir[fix_root+"/*.js"] .each do |f|
      db.eval(File.read(f))
    end
  end
end

