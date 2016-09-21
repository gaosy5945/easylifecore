/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.skin= 'office2003'; 
	//config.filebrowserBrowseUrl = 'ckeditor/uploader/browse.jsp'; 
    //config.filebrowserImageBrowseUrl = 'ckeditor/uploader/browse.jsp?type=Images'; 
    //config.filebrowserFlashBrowseUrl = 'ckeditor/uploader/browse.jsp?type=Flashs'; 
    config.filebrowserUploadUrl = 'ckextend/uploadfile.jsp'; 
    config.filebrowserImageUploadUrl = 'ckextend/uploadimage.jsp'; 
    config.filebrowserFlashUploadUrl = 'ckextend/uploadfile.jsp'; 
    config.filebrowserWindowWidth = '640'; 
    config.filebrowserWindowHeight = '480'; 
};
