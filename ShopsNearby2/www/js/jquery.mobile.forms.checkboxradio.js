/*
* "checkboxradio" plugin
*/

(function( $, undefined ) {

$.widget( "mobile.checkboxradio", $.mobile.widget, {
	options: {
		theme: null,
		initSelector: "input[type='checkbox'],input[type='radio']"
	},
	_create: function() {
		var self = this,
			input = this.element,
			// NOTE: Windows Phone could not find the label through a selector
			// filter works though.
			label = $( input ).closest( "form,fieldset,:jqmData(role='page'),:jqmData(role='dialog')" ).find( "label" ).filter( "[for='" + input[ 0 ].id + "']" ),
			inputtype = input.attr( "type" ),
			mini = input.closest( "form,fieldset" ).jqmData('mini'),
			checkedState = inputtype + "-on",
			uncheckedState = inputtype + "-off",
			icon = input.parents( ":jqmData(type='horizontal')" ).length ? undefined : uncheckedState,
			activeBtn = icon ? "" : " " + $.mobile.activeBtnClass,
			checkedClass = "ui-" + checkedState + activeBtn,
			uncheckedClass = "ui-" + uncheckedState,
			checkedicon = "ui-icon-" + checkedState,
			uncheckedicon = "ui-icon-" + uncheckedState;

		if ( inputtype !== "checkbox" && inputtype !== "radio" ) {
			return;
		}

		// Expose for other methods
		$.extend( this, {
			label: label,
			inputtype: inputtype,
			checkedClass: checkedClass,
			uncheckedClass: uncheckedClass,
			checkedicon: checkedicon,
			uncheckedicon: uncheckedicon
		});

		// If there's no selected theme...
		if( !this.options.theme ) {
			this.options.theme = this.element.jqmData( "theme" );
		}

		label.buttonMarkup({
			theme: this.options.theme,
			icon: icon,
			shadow: false,
			mini: mini
		});

		// Wrap the input + label in a div
		var wrapper = document.createElement('div');		
		wrapper.className = 'ui-' + inputtype;	
		input[0].parentNode.insertBefore(wrapper,input[0]);
		wrapper.appendChild(input[0]);				
		wrapper.appendChild(label[0]);

		label.bind({
			vmouseover: function( event ) {
				if ( $( this ).parent().is( ".ui-disabled" ) ) {
					event.stopPropagation();
				}
			},

			vclick: function( event ) {
				if ( input.is( ":disabled" ) ) {
					event.preventDefault();
					return;
				}

				self._cacheVals();
				input.attr( "checked", inputtype === "radio" && true || !input.attr( "checked" ) );
				//input.prop( "checked", inputtype === "radio" && true || !input.attr( "checked" ) );

				// trigger click handler's bound directly to the input as a substitute for
				// how label clicks behave normally in the browsers
				// TODO: it would be nice to let the browser's handle the clicks and pass them
				//       through to the associate input. we can swallow that click at the parent
				//       wrapper element level
				input.triggerHandler( 'click' );

				// Input set for common radio buttons will contain all the radio
				// buttons, but will not for checkboxes. clearing the checked status
				// of other radios ensures the active button state is applied properly
				self._getInputSet().not( input ).removeAttr( "checked" );

				self._updateAll();
				return false;
			}

		});

		input
			.bind({
				vmousedown: function() {
					self._cacheVals();
				},

				vclick: function() {
					var $this = $(this);

					// Adds checked attribute to checked input when keyboard is used
					if ( $this.is( ":checked" ) ) {

						$this.attr( "checked", "checked" );
						self._getInputSet().not($this).removeAttr( "checked" );
					} else {

						$this.removeAttr( "checked" );
					}

					self._updateAll();
				},

				focus: function() {
					label.addClass( $.mobile.focusClass );
				},

				blur: function() {
					label.removeClass( $.mobile.focusClass );
				}
			});

		this.refresh();
	},

	_cacheVals: function() {
		this._getInputSet().each(function() {
			var $this = $(this);

			$this.jqmData( "cacheVal", $this.is( ":checked" ) );
		});
	},

	//returns either a set of radios with the same name attribute, or a single checkbox
	_getInputSet: function(){
		if(this.inputtype == "checkbox") {
			return this.element;
		}

		return this.element.closest( "form,fieldset,:jqmData(role='page')" )
			.find( "input[name='"+ this.element.attr( "name" ) +"'][type='"+ this.inputtype +"']" );
	},

	_updateAll: function() {
		var self = this;

		this._getInputSet().each(function() {
			var $this = $(this);

			// NOTE getAttribute is used here to deal with an issue with the :checked
			//      selector. see #3597
			if ( this.getAttribute( "checked" ) || self.inputtype === "checkbox" ) {
				$this.trigger( "change" );
			}
		})
		.checkboxradio( "refresh" );
	},

	refresh: function() {
		var input = this.element,
			label = this.label,
			icon = label.find( ".ui-icon" );

		// input[0].checked expando doesn't always report the proper value
		// for checked='checked'

		if ( input[ 0 ].getAttribute( "checked" ) ) {
			label.addClass( this.checkedClass ).removeClass( this.uncheckedClass );
			icon.addClass( this.checkedicon ).removeClass( this.uncheckedicon );
		} else {
			label.removeClass( this.checkedClass ).addClass( this.uncheckedClass );
			icon.removeClass( this.checkedicon ).addClass( this.uncheckedicon );
		}

		if ( input.is( ":disabled" ) ) {
			this.disable();
		} else {
			this.enable();
		}
	},

	disable: function() {
		this.element.attr( "disabled", true ).parent().addClass( "ui-disabled" );
	},

	enable: function() {
		this.element.prop( "disabled", false ).parent().removeClass( "ui-disabled" );
	}
});

//auto self-init widgets
$( document ).bind( "pagecreate create", function( e ){
	$.mobile.checkboxradio.prototype.enhanceWithin( e.target, true );
});

})( jQuery );
