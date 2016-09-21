


function hc_drawInputbox(name, header, colspan, tag, readonly, defaultValue){
	document.write("<td nowrap align='left' valign='bottom'>&nbsp;&nbsp;<span class='ibheader'>"+ header +"</span></td>"+"\r");
	document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><input class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></td>"+"\r");
}

function hc_drawMemoInputbox(name, header, colspan, tag, readonly, defaultValue){
	document.write("<td nowrap align='left' valign='top'>&nbsp;&nbsp;<span  class='ibheader1'>"+ header +"</span></td>"+"\r");
	document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><textarea rows='6' class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></textarea></td>"+"\r");
}

function hc_drawDateInputbox(name, header, colspan, tag, readonly, defaultValue){
	document.write("<td nowrap align='left' valign='bottom'>&nbsp;&nbsp;<span class='ibheader'>"+ header +"</span></td>"+"\r");
	document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><input class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></td>"+"\r");
}


function hc_drawFreeForm(obj,width,totalColumns,defaultColspan,defaultColspanForLongType,defaultPosition){
	document.write("<table cellspacing=0 cellpadding=0 border=0 width='"+width+"'>"+"\r");
	var remainColumns = 0;
	var colwidth;
	
	var a = width.replace("%","");
	if(a<=100){
		colwidth = (a/totalColumns);
		colwidth = colwidth +"%";
	}else{
		colwidth = a/totalColumns;	
	}
	 
	document.write("<tr>");
	for(var j=0; j<totalColumns; j++){
		document.write("<td width='"+colwidth+"'></td>");
	}
	document.write("</tr>");
	
	for(var j=0; j<obj.length; j++){
		//取得colspan
		temp=obj[j][3];
		if(temp==""){
			colspan = defaultColspan;
		}else{
			colspan = temp;
		}

		//取得position
		temp=obj[j][4];
		if(temp==""){
			position = defaultPosition;
		}else{
			position = temp;
		}

		//显示<tr>
		if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
			if (remainColumns > 0){
				document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
			}
			remainColumns = totalColumns;
			document.write("<tr height='8'></tr><tr>");
		}

		//显示内容
		if(obj[j][2]=="string"){
			hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
			remainColumns = remainColumns -colspan;
		}
		if(obj[j][2]=="memo"){
			hc_drawMemoInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
			remainColumns = remainColumns -colspan;
		}
		if(obj[j][2]=="date"){
			hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
			remainColumns = remainColumns -colspan;
		}
		if(obj[j][2]=="dropdownlist"){
			hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
			remainColumns = remainColumns -colspan;
		}

		//显示</tr>
		if (position=="FULLROW"){
			if (remainColumns > 0){
				document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
			}
			remainColumns=0;
		}
	}

	document.write("</table>");
}


function hc_drawTab(tabID, tabStrip,selectedStrip){
	document.write("<table id='"+tabID+"'cellspacing=0 cellpadding=0 border=0><tr>"+"\r");
	for(var i=0; i<tabStrip.length; i++){
		var selected="";
		if(i==(selectedStrip-1)){
			selected="sel";
		}else{
			selected="desel";
		}
		document.write("<td class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r");
	}

	document.write("</tr><tr>"+"\r");
	for(var i=0; i<tabStrip.length; i++){
		if(i==0){
			if(i==(selectedStrip-1)){
				document.write("<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}else{
				document.write("<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}
		}
		if(i==(selectedStrip-1)){
			document.write("<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
		}else{
			document.write("<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
		}
		if(i==(tabStrip.length-1)){
			if(i==(selectedStrip-1)){
				document.write("<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}else{
				document.write("<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}	
		}			
	}

	document.write("</tr></table>"+"\r");
}

function hc_drawTabToIframe(tabID, tabStrip,selectedStrip,sObject){
//	sObject.document.clear();
	sObject.document.close();
	
	sObject.document.write("<html>"+"\r");
	sObject.document.write("<head>"+"\r");
	sObject.document.write("<link rel='stylesheet' href='"+sWebRootPath+"/Frame/page/resources/css/Style.css'>"+"\r");
	sObject.document.write("<meta http-equiv='Content-Type' CONTENT='text/html; charset=gb2312'>"+"\r");
	sObject.document.write("</head>"+"\r");		
	sObject.document.write("<body class='pagebackground' leftmargin='0' topmargin='0' >"+"\r");
	sObject.document.write("<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'><tr>"+"\r");
	for(var i=0; i<tabStrip.length; i++){
		var selected="";
		if(i==(selectedStrip-1)){
			selected="sel";
		}else{
			selected="desel";
		}
		sObject.document.write("<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r");
	}
	sObject.document.write("</tr><tr>"+"\r");
	for(var i=0; i<tabStrip.length; i++){
		if(i==0){
			if(i==(selectedStrip-1)){
				sObject.document.write("<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}else{
				sObject.document.write("<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}	
		}
		if(i==(selectedStrip-1)){
			sObject.document.write("<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
		}else{
			sObject.document.write("<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
		}	
		if(i==(tabStrip.length-1)){
			if(i==(selectedStrip-1)){
				sObject.document.write("<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}else{
				sObject.document.write("<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r");		
			}	
		}			
	}

	sObject.document.write("</tr></table>"+"\r");
	sObject.document.write("</body>\r");
	sObject.document.write("</html>\r");
	//alert(sObject.document.src);
}

function hc_drawTabToTable(tabID, tabStrip,selectedStrip,sObject){
	sObject.innerHTML="";
	sInnerHTML = "";
	sInnerHTML += "<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'>"+"\r";
	sInnerHTML += "<tr>"+"\r";
	
	for(var i=0; i<tabStrip.length; i++){
		var selected="";
		if(i==(selectedStrip-1)){
			selected="sel";
		}else{
			selected="desel";
		}
		sInnerHTML += "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r";
	}
	sInnerHTML += "</tr><tr>"+"\r";
	
	for(var i=0; i<tabStrip.length; i++){
		if(i==0){
			if(i==(selectedStrip-1)){
				sInnerHTML += "<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r";
			}else{
				sInnerHTML += "<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r";
			}	
		}
		if(i==(selectedStrip-1)){
			sInnerHTML += "<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r";
		}else{
			sInnerHTML += "<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r";
		}
		if(i==(tabStrip.length-1)){
			if(i==(selectedStrip-1)){
				sInnerHTML += "<td class='tabline1'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r";
			}else{
				sInnerHTML += "<td class='tabline'><span style='display:inline-block;'>&nbsp;</span></td>"+"\r";
			}
		}
	}

	sInnerHTML += "</tr></table>"+"\r";
	sObject.innerHTML=sInnerHTML;
} 
	
function drawHtmlToObject(oObject,sHtml){
	oObject.innerHTML="";
	oObject.innerHTML=sHtml;
}