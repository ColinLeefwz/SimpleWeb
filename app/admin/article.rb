ActiveAdmin.register Article do

  index do
    column :cover do |article|
      link_to image_tag(article.cover.url, width: "50"), admin_article_path(article)
    end
    column :title do |article|
      link_to(article.title, admin_article_path(article))
    end
    column :expert do |article|
      link_to article.expert.name, admin_expert_path(article.expert_id)
    end
    column :always_show do |article|
      article.always_show.to_s
    end
    column :categories do |article|
      article.category_names
    end

    default_actions
  end

  form partial: 'form'

  # form html: {multipart: true} do |f|
  #   f.inputs "Articles" do
  #     f.input :title
  #     f.input :expert
  #     f.input :always_show
  #     # f.input :cover, as: :file # , hint: f.template.image_tag(f.object.cover.url)
  #     # f.input :description, :input_html => { :class => 'ckeditor' }
  #     f.input :categories, as: :check_boxes, collection: Category.pluck(:name)
  #   end
  #   f.actions
  # end


  show do |article|
    attributes_table do
      row :title
      row :expert do
        link_to article.expert.name, admin_expert_path(article.expert_id)
      end
      row :always_show do
        article.always_show.to_s
      end
      row :cover do
        image_tag article.cover.url, width: "70"
      end
      row :description do
        description = article.description || "  "
        description.html_safe
      end

      row :categories do |article|
        article.category_names
      end
    end
  end

  controller do
    def permitted_params
      params.permit :id, article: [:id, :title, :expert_id, :always_show, :description, :cover, {category_ids:[]}]
    end
  end

end
