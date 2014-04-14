
$(document).ready(function(){
  CKEDITOR.editorConfig = function(config){
    config.toolbar = 'Basic';

    config.toolbar_Basic =
    [
      { name: 'clipboard', items: ['Undo', 'Redo']},
      { name: 'styles', items : [ 'Format' ] },
      { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Superscript' ]},
      { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']},
      { name: 'links', items : [ 'Link','Unlink'] },
      { name: 'insert', items : [ 'Image','Table' ] },
      // { name: 'tools', items : [ 'Maximize', 'Templates','Scayt' ] },
      { name: 'document', items: ['Source', '-']}
    ];
  };

});
