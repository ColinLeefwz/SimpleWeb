ActiveAdmin.register Session do
  controller do
    def permitted_params
      params.permit session: [:title, :expert_id, :created_date, :description]
    end
  end

end
