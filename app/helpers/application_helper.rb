module ApplicationHelper
  def flash_class
    if flash[:alert]
      "alert-danger"
    elsif flash[:error]
      "alert-something"
    elsif (flash[:notice] or flash[:success])
      "alert-success"
    end
  end

  def flash_message
    flash[:alert] || flash[:error] || flash[:notice] || flash[:success]
  end



  # helper for displaying price
  def price_tag(price)
    if price == 0
      return "Free"
    else
      return number_to_currency(price, :unit => "$") + "USD"
    end
  end


  ## payment
  # display the enroll button(free) or paypal button
  def paypal_or_enroll_button(params, item)

    if (current_user) && (current_user.enrolled? item)
      "Enrolled"
    else
      if item.free?
        link_to "Confirm", "/#{params[:controller]}/#{item.id}/enroll_confirm", class: "btn"
      else
        link_to image_tag("paypal_button.png"), send("purchase_#{item.class.name.downcase}_path", item.id), data: {no_turbolink: true}
      end
    end
  end


  # use devise helper outside of Users::RegistrationsController
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource
    @resource ||= User.new
  end

  def resource_name
    :user
  end

  def resource_class
    devise_mapping.to
  end



  # dynamic form
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "btn remove-fields inline")
  end

  def link_to_add_fields(name, f, associaton)
    new_object = f.object.send(associaton.to_s).build
    fields = f.fields_for(associaton, new_object, child_index: "new_#{associaton}") do |builder|
      render(associaton.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, "#", class: "btn add-fields inline", data: {associaton: associaton.to_s, fields: fields.gsub("\n", "") } )
  end
end
