$(".main-menu").html("<%= j render(partial: 'shared/card', collection: @items, as: :item) %>")
history.pushState(null, "", "<%= dashboard_content_path %>")
