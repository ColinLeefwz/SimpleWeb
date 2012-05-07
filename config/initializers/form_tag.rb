require 'cgi'
require 'action_view/helpers/date_helper'
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/form_tag_helper'

module ActionView
  module Helpers

    class InstanceTag #:nodoc:

      def to_label_tag(text = nil, options = {})
        options = options.stringify_keys
        tag_value = options.delete("value")
        name_and_id = options.dup
        name_and_id["id"] = name_and_id["for"]
        add_default_name_and_id_for_value(tag_value, name_and_id)
        options.delete("index")
        options["for"] ||= name_and_id["id"]
        content = (text.blank? ? nil : text.to_s) || eval("#{object_name.camelcase}.human_attribute_name('#{method_name}')")
        label_tag(name_and_id["id"], content, options)
      end
    end
    
  end
end
