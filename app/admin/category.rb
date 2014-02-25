ActiveAdmin.register Category do
  controller do
    def permitted_params
      params.permit :id, category: [:id, :name]
    end
  end
end
