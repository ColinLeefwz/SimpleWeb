ActiveAdmin.register Language do
  controller do
    def permitted_params
      params.permit :id, language: [:id, :long_version, :short_version]
    end
  end
end
