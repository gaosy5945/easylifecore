



function spreadsheetPrintout(data){
	var fileName = createTemporaryFile(data);
	
	lApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(fileName);
	
	xlBook.Sheets(1).PrintOut();
	xlBook.Close();
}

function spreadsheetprintPreview(data){
	var fileName = createTemporaryFile(data);
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.open(fileName);
	
	xlApp.Application.Visible = true;
	xlApp.windows.visible = true;
	xlBook.Sheets.PrintPreview();
	xlBook.Close();
}

function spreadsheetTransfer(data){
	var fileName = createTemporaryFile(data);
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(fileName);
	
	xlApp.Application.Visible = true;
	xlApp.windows(1).visible = true;
}

function printPreviewSpreadsheet(data){
	var fileName = createTemporaryFile(data);
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(fileName);
	
	xlApp.Application.Visible = true;
	xlApp.windows(1).visible = true;
	xlBook.Sheets(1).PrintPreview();
	xlBook.Close();
}

function createTemporaryFile(data){
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var TemporaryFolder = 2;
	var tfolder = fso.GetSpecialFolder(TemporaryFolder);
	var fileName = tfolder+"\\"+fso.GetTempName()+".xls";
	var tfile = fso.CreateTextFile(fileName);
	tfile.write("<html><head><meta http-equiv='Content-Type' content='text/html; charset=gb2312' /></head><body>"+data+"</body></html>");
	tfile.close();
	return fileName;
}

function writeToTheEndOfFile(fileName,data) {
	var objFS = new ActiveXObject("Scripting.FileSystemObject");
	f = objFS.OpenTextFile(fileName, 8, true);
	f.write(data);
	f.close();
}

function myFormatNumber(dMoney,iType){
	return FormatNumber(dMoney,iType,-1,0,0);
}









function export2Excel(tableid){
	var sHead = "<style type='text/css'>"+
				".tbl_nor{font-size:12px; color:#5a5a5a;border-collapse:collapse;border-width:thin;}"+
				".td_nor{border:1px solid #949494;padding:5px;width:auto;}"+
				".tr_title{font-size:14px; font-weight:bold;}"+
				"input{border:0px;border-bottom:1px solid #949494;}</style>";
	var sContent = document.getElementById(tableid).outerHTML;
	if(sContent && sContent != ""){
		var sFormName = "form_export"+ randomNumber();
		var sHTML = "";
		var form = document.createElement("form");
		form.setAttribute("method","post");
		form.setAttribute("name",sFormName);
		form.setAttribute("id",sFormName);
		form.setAttribute("target","_blank");
		form.setAttribute("action",sWebRootPath+"/servlet/view/stream?CompClientID="+sCompClientID);
		
		sHTML += "<div style='display:none'>";
		sHTML += "<textarea name='stream'>"+sHead+ sContent+"</textarea>";
		sHTML += "<input type=hidden name=contenttype value='application/html'>";
		sHTML += "<input type=hidden name=encodingfrom value='GBK'>";
		sHTML += "<input type=hidden name=encodingto value='GBK'>";
		sHTML += "<input type=hidden name=viewtype value='save'>";
		sHTML += "<input type=hidden name=filename value='export.xls'>";
		sHTML += "</div>";
		form.innerHTML = sHTML;
		document.body.appendChild(form);
		form.submit();
	}
}