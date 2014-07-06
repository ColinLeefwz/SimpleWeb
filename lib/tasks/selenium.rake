# coding: utf-8

namespace :test do
  desc "selenium 自动化测试"
  Rails::SubTestTask.new(:selenium) do |t|
    t.libs << "selenium"
    t.pattern = 'selenium/*_test.rb'
  end

  namespace :selenium do
    desc "selenium 开启火狐游览器自动化测试"
    task :firefox do
      ENV["selenium_browser"]  = "firefox"
      Rake::Task["test:selenium"].invoke
    end

    desc "selenium 开启ie览器自动化测试"
    task :ie do
      ENV["selenium_browser"]  = "ie"
      Rake::Task["test:selenium"].invoke
    end
    
    desc "selenium 开启谷歌游览器自动化测试"
    task :chrome do
      ENV["selenium_browser"]  = "chrome"
      Rake::Task["test:selenium"].invoke
    end
    
  end

end



