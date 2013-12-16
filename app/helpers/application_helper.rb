module ApplicationHelper
  def flash_class
    if flash[:alert]
      "alert-error"
    elsif flash[:error]
      "alert-something"
    elsif flash[:notice]
      "alert-success"
    end
  end

  def flash_message
    if flash[:alert]
      flash[:alert]
    elsif flash[:error]
      flash[:error]
    elsif flash[:notice]
      flash[:notice]
    end
  end


  def price_tag(price)
    if price == 0
      return "Free"
    else
      return number_to_currency(price, :unit => "$") + "USD"
    end
  end


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
