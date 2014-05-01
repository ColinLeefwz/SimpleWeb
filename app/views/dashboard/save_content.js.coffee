$(".main-menu").html("<%= j render(partial: 'shared/card', collection: current_user.contents, as: :item) %>")
history.pushState(null, "", "<%= dashboard_content_path %>")
