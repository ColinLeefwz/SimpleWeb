ready = ->
	`
	// copy from the source code in http://isotope.metafizzy.co/custom-layout-modes/centered-masonry.html
	$.Isotope.prototype._getCenteredMasonryColumns = function() {
		this.width = this.element.width();

		var parentWidth = this.element.parent().width();

		var colW = this.options.masonry && this.options.masonry.columnWidth ||
			this.$filteredAtoms.outerWidth(true) ||
				parentWidth;

				var cols = Math.floor( parentWidth / colW );
				cols = Math.max( cols, 1 );

				this.masonry.cols = cols;
				this.masonry.columnWidth = colW;
	};

	$.Isotope.prototype._masonryReset = function() {
		this.masonry = {};
		this._getCenteredMasonryColumns();
		var i = this.masonry.cols;
		this.masonry.colYs = [];
		while (i--) {
			this.masonry.colYs.push( 0 );
		}
	};

	$.Isotope.prototype._masonryResizeChanged = function() {
		var prevColCount = this.masonry.cols;
		this._getCenteredMasonryColumns();
		return ( this.masonry.cols !== prevColCount );
	};

	$.Isotope.prototype._masonryGetContainerSize = function() {
		var unusedCols = 0,
			i = this.masonry.cols;
			while ( --i ) {
				if ( this.masonry.colYs[i] !== 0 ) {
					break;
				}
				unusedCols++;
			}

			return {
				height : Math.max.apply( Math, this.masonry.colYs ),
					 width : (this.masonry.cols - unusedCols) * this.masonry.columnWidth
			};
	};
	`
	container = $('#content')
	container.imagesLoaded ->
		container.isotope {
			layoutMode: 'masonry'
		}
  # sublime.load()

	# for video in $("video")
		# sublime.ready( ->
			# sublime.prepare(video, (player) ->
				# player.pause()
			# )
		 # )

	$container = $('#content')
	$('nav li .filters').on 'click', ->
		selector = $(this).data('filter') + ', .always_show'
		$container.isotope {
			filter: selector
		}

	$('select#collapsed_navbar').on 'change', ->
		option = $(this).find(":selected")
		selector = option.data('filter') + ', .always_show'
		if selector != '.format'
			$container.isotope {
				filter: selector
			}

load_sublime = ->
  sublime.load()
  for video in $("video")
    sublime.ready( ->
      sublime.prepare(video, (player) ->
        player.pause()
      )
     )

update_profile_message = ->
  $("input[type='submit']").on 'click', ->
    $("input[type='file']").css("width", "95px")

$(document).ready(ready)
$(document).on('page:load', ready)

$(document).ready(load_sublime)
$(document).on('page:load ajax:success', load_sublime)

$(document).on 'page:load ajax:success', update_profile_message
