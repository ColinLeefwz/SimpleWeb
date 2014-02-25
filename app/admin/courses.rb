ActiveAdmin.register_page "Courses" do
  controller do
    define_method(:index) do
      redirect_to courses_path
    end

    define_method(:new) do
      redirect_to new_course_path
    end
  end

end
