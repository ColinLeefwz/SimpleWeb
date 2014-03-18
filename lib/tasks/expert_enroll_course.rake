namespace :enroll do
  desc "expert enroll his own courses"

  task :enroll_courses => :environment do
    Course.all.each do |course|
      course.experts.each do |exp|
        exp.enroll course
      end
    end
  end
end
