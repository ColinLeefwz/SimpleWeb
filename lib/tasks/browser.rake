namespace :test do

  Rake::TestTask.new(:browser) do |t|
    t.libs << "test"
    t.pattern = 'browser_test/*.rb'
    t.verbose = true
  end
  Rake::Task['test:units'].comment = "Run the browser tests"
    
end

