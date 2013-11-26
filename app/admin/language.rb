ActiveAdmin.register Language do
  controller do
    def permitted_params
      params.permit language: [:long_version, :short_version]
    end
  end
end
