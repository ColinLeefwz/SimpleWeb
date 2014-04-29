# render the main form
$(".main-menu").html('<%=j render partial: "articles/form"%>')

# helper for save_draft
$("#save-draft").on("click", ->
  draft_field = $(this).closest("form").find("#article_draft")
  draft_field.val(true)
)

# make publish button to change draft=false
$("#publish").on "click", ->
  draft_field = $(this).closest("form").find("#article_draft")
  draft_field.val(false)


# preview helper, get user input and fill in the modal
article_preview()

$(".modal-submit").on "click", ->
  $("#preview-modal").modal "hide"

# article form validation
form_validation()

# ditor helper
CKEDITOR.replaceAll()

