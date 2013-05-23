namespace :test do
  task :prepare do
    if `ifconfig eth0`.to_s.index("inet addr:10") && `ifconfig eth1`.to_s.index("inet addr:42")
      file="mongoid.production_test.yml"
    else
      file="mongoid.yml"
    end
    db_config = YAML.load(File.open(Rails.root.to_s+"/config/#{file}"))['test']['sessions']['default']
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

