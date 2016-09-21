





function hideItem(iDW,iRow,sCol){
	showItem(iDW,iRow,sCol,'none');
}








function showItem(iDW,iRow,sCol,display){
	if(display==undefined || display=="block") display = ""; //暂时这么处理
	var iCol = getColIndex(iDW,sCol);
	var oInput = window.frames["myiframe"+iDW].document.getElementById("R"+iRow+"F"+iCol);
	while(true){
		if(oInput.tagName.toUpperCase()=="TR") break;
		oInput = oInput.parentNode;
	}
	oInput.style.display = display;
}








function setItemDisabled(iDW,iRow,sCol,bDisabled){
	iCol = getColIndex(iDW,sCol);
	window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].disabled = bDisabled; 
}








function setItemReadOnly(iDW,iRow,sCol,bReadOnly){
	iCol = getColIndex(iDW,sCol);
	window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].readOnly = bReadOnly;
	if(DZ[iDW][1][iCol][11]==21){
		var flatSelect = $("#R"+iRow+"F"+iCol, window.frames["myiframe"+iDW].document).data("FlatSelect");
		if(flatSelect) $(flatSelect["input"]).prop("readonly", bReadOnly);
	}
}

function setEditMaskByIndex(iDW,iRow,iCol){
	var obj = getASObjectByIndex(iDW,iRow,iCol);
	obj.value = amarMoney(amarsoft2Real(DZ[iDW][2][my_index[iDW][iRow]][iCol]),DZ[iDW][1][iCol][12]);
}

function setEditMask(iDW,iRow,sCol){
	iCol = getColIndex(iDW,sCol); 
	setEditMaskByIndex(iDW,iRow,iCol); 
} 

function setItemFocusByIndex(iDW,iRow,iCol){
	window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].focus();
	window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].select();
}







function setItemFocus(iDW,iRow,sCol){
	iCol = getColIndex(iDW,sCol);
	setItemFocusByIndex(iDW,iRow,iCol);
}

//for myLastCB是只响应鼠标事件me,没响应键盘事件ku(也不能)，应该响应onblur
function getItemValueByIndex(iDW,iRow,iCol){
	if(rr_c[iDW]<=0 || iRow<0 || iCol<0 || iRow>rr_c[iDW] || iCol >f_c[iDW])
		return;  
	else{
		if(DZ[iDW][1][iCol][2]==1){ //是否显示
			try {  
				if(DZ[iDW][2][my_index[iDW][iRow]][iCol] != real2Amarsoft(amarValue(getASObjectByIndex(iDW,iRow,iCol).value,DZ[iDW][1][iCol][12])))
				{
					hC_noUI(iDW,iRow,iCol,DZ[iDW][2][my_index[iDW][iRow]][iCol]);
					return real2Amarsoft(amarValue(getASObjectByIndex(iDW,iRow,iCol).value,DZ[iDW][1][iCol][12]));
				}
			} catch(e) {  } 
		}

		return amarsoft2Real(DZ[iDW][2][my_index[iDW][iRow]][iCol]);	
	}
}

function getItemValueByName(iDW,iRow,sCol){
	iCol = getColIndex(iDW,sCol);
	return getItemValueByIndex(iDW,iRow,iCol);
}








function getItemValue(iDW,iRow,sCol){
	return getItemValueByName(iDW,iRow,sCol);
}







function getColLabel(iDW,sCol){
	var i = 0;
	for(i=0;i<DZ[iDW][1].length;i++){
		if(DZ[iDW][1][i][15].toUpperCase()==sCol.toUpperCase()) return DZ[iDW][1][i][0];
	};
	return "";
}






function getRowCount(iDW){
	return rr_c[iDW];
}






function getRow(iDW){
	return iCurRow;  
}

function getCol(iDW){
	return iCurCol;
}

function getColIndex(iDW,sCol){
	var i = 0;
	for(i=0;i<DZ[iDW][1].length;i++){
		if(DZ[iDW][1][i][15]==sCol) return i;
	};
	return -1;
}
function getColIndexIngoreCase(iDW,sCol){
	var i = 0;
	for(i=0;i<DZ[iDW][1].length;i++){
		
		if(typeof(sCol)=="string"){
			if(DZ[iDW][1][i][15].toUpperCase()==sCol.toUpperCase()) return i;
		}
		else{
			if(DZ[iDW][1][i][15]==sCol) return i;
		}
	};
	return -1;
}	







function getColName(iDW,iCol){
	if(iCol>=DZ[iDW][1].length) return "";
  	return DZ[iDW][1][iCol][15];
}	
	
function setItemValueByIndex(iDW,iRow,iCol,sValue){
	if(rr_c[iDW]<=0 || iRow<0 || iCol<0 || iRow>rr_c[iDW] || iCol >f_c[iDW])
		return false;

	if(DZ[iDW][1][iCol][2]==1){ //是否显示
		//DZ[iDW][2][my_index[iDW][iRow]][iCol] = real2Amarsoft(sValue);  
		myframename = "myiframe"+iDW;	
		objp = window.frames[myframename];
		itemname = "R"+iRow+"F"+iCol;
		if(DZ[iDW][1][iCol][11]==21){
			var flatSelect = $('#'+itemname, objp.document).data("FlatSelect");
			if(flatSelect && typeof flatSelect["setValue"] == "function")
				flatSelect["setValue"](amarsoft2Real(sValue));
		}
		objp.document.forms[0].elements[itemname].value=amarsoft2Real(sValue);
		hC(objp.document.forms[0].elements[itemname],myframename);
		// RADIO
		if(DZ[iDW][1][iCol][11]==5||DZ[iDW][1][iCol][11]==6)
		try {
			var radios = objp.document.forms[0].elements[itemname+'_Radio'];
			if(!radios || radios.length == 0) return false;
			for(var ii = 0; ii < radios.length; ii++){
				if(sValue == radios[ii].value){
					radios[ii].checked = true;
					break;
				}
			}
		}catch(e){}
		// CHECKBOX
		else if(DZ[iDW][1][iCol][11]==7)
		try{
			var checkboxs = objp.document.forms[0].elements[itemname+'_Checkbox'];
			if(!checkboxs || checkboxs.length == 0) return false;
			var sTempValue = ","+sValue+",";
			for(var ii = 0; ii < checkboxs.length; ii++){
				checkboxs[ii].checked = sTempValue.indexOf(","+checkboxs[ii].value+",")>-1;
			}
		}catch(e){}
		// 单个复选框，主要用于List多选MultiSelectionFlag
		else if(DZ[iDW][1][iCol][11]==-1)
		try{
			var checkbox = objp.document.forms[0].elements[itemname];
			if(!checkbox) return false;
			checkbox.checked = (sValue == "√");
		}catch(e){}
		// FLAT_DROPDOWN
		else if(DZ[iDW][1][iCol][11]==9)
		try {
			mySelectBL(objp.document.getElementById('R'+iRow+'F'+iCol),iDW,iRow,iCol);
		}catch(e){}
		return true;
	}else{
		hC_noUI(iDW,iRow,iCol,sValue);
		return true;
	}
}









function setItemValue(iDW,iRow,sCol,sValue){
	iCol = getColIndex(iDW,sCol);
	return setItemValueByIndex(iDW,iRow,iCol,sValue);			
}
 
function a_b(my_sort,my_listo,sw,sort_begin,sort_end,my_index){
	if(my_sort==2) return;
	
	var my_list =new Array();
	var k;
	for(k=0;k<my_index.length;k++) 
		if(my_index[k]!=-1)
			my_list[k]=my_listo[my_index[k]][sw];
		else break;
	if(sort_end>my_index.length-1) sort_end=my_index.length-1;
	
	var lastExchange,j,i=sort_end-1;
	var temp,temp2;
	while(i>sort_begin) {
		lastExchange=sort_begin;
		for(j=sort_begin;j <= i;j++) {
			if(my_list[j+1]<my_list[j]) {
				temp = my_list[j];temp2 = my_index[j];
				my_list[j]=my_list[j+1];my_index[j]=my_index[j+1];
				my_list[j+1]=temp;my_index[j+1]=temp2;
				lastExchange=j;
			}
		}
		i = lastExchange;
	}
	
	if(my_sort!=1){
		var sort_mid=sort_begin+(sort_end-sort_begin)/2;
		for(i=sort_begin;i<sort_mid;i++) {
			temp=my_index[i];
			my_index[i]=my_index[sort_end+sort_begin-i];
			my_index[sort_end+sort_begin-i]=temp;
		}		
	}
}
 



function init(bSetPageSize){
	if(!beforeInit(bSetPageSize)) return;
	var myoldstatus = window.status;  
	window.status="正在初始化数据，请稍候....";  
	var i;
	for(i=0;i<DZ.length;i++) {
		f_c[i]=DZ[i][1].length;
		r_c[i] =DZ[i][2].length;		
		rr_c[i]=DZ[i][2].length;		
		f_css[i]=new Array();
		for(var j=0;j<f_c[i];j++)
			f_css[i][j]="";

		if(arguments.length==0 || (arguments.length>=1 && bSetPageSize) ){
			if(DZ[i][0][0]==1) { pagesize[i]=99999999;pageone[i]=1; } 
			else               pagesize[i]=1; 
		}
		 
		pagenum[i]=Math.ceil(rr_c[i]/pagesize[i]);
		curpage[i]=0;
		
		bDoUnload[i] = false;
	}
	
	for(i=0;i<DZ.length;i++) {
		my_change[i] = new Array();
		for(var iTemp=0;iTemp<rr_c[i];iTemp++){
			my_change[i][iTemp] = new Array();
			for(var jTemp=0;jTemp<f_c[i];jTemp++)
				my_change[i][iTemp][jTemp]=0;
		}		
	}
		
	for(i=0;i<DZ.length;i++) {
		my_changedoldvalues[i] = new Array();
		for(iTemp=0;iTemp<rr_c[i];iTemp++){
			my_changedoldvalues[i][iTemp] = new Array();
			for(jTemp=0;jTemp<f_c[i];jTemp++)
				my_changedoldvalues[i][iTemp][jTemp]="";
		}		
	}
	for(i=0;i<DZ.length;i++) {
		my_attribute[i] = new Array();
		for(j=0;j<rr_c[i];j++)
			my_attribute[i][j] = 0;
	}
	for(i=0;i<DZ.length;i++) {
		my_notnull[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull[i][j] = DZ[i][1][j][4];
	}
	for(i=0;i<DZ.length;i++) {
		last_sel_rec[i]=-1;
		cur_sel_rec[i]=-1;
		last_sel_item[i]="";
		cur_sel_item[i]="";
		needReComputeIndex[i]=1;
		my_index[i]=new Array();
		for(j=0;j<rr_c[i];j++)
			my_index[i][j]=j;
		cur_sortfield[i]=0;
		cur_sortorder[i]=2; 
		sort_begin[i]=0;
		sort_end[i]=rr_c[i]-1;
	}
 
	iCurRow = -1;
	iCurCol = 0;

	window.status="Ready";  
	window.status=myoldstatus;  
}

//直接将方法名转接，避免参数arguments判断出错
window.init_show= init;

function getRecNum(myi,iField,sValue){
	for(var j=0;j<rr_c[myi];j++)
		if(sValue==DZ[myi][2][my_index[myi][j]][iField]) return j;
	
	return -1;
}

function MRK1(myobjname,myact,my_sortorder,sort_which){
	if(!beforeMRK1(myobjname,myact,my_sortorder,sort_which)) return;
	
	if(myact==6) {
		var myobj=window.frames[myobjname];
		var myi=myobj.name.substring(myobj.name.length-1);
		for(var i=0;i<f_c[myi];i++) {
			if(DZ[myi][1][i][2]==0) continue; 
			if(myobj.document.forms[0].elements["txtField"+i].value!=""){
				iRec = getRecNum(myi,i,myobj.document.forms[0].elements["txtField"+i].value);
				if(iRec!=-1){
					myobj.document.forms[0].elements["txtJump"].value=parseInt(iRec/pagesize[myi])+1;
					MR1(myobjname,5,my_sortorder,sort_which);
					sR(cur_sel_rec[myi],iRec,myobjname);
					return;
				}
			}
		}	
		alert("无匹配记录！");
		return;
	}
	
	if(myact==7) {
		var myobj=window.frames[myobjname];
		var myi=myobj.name.substring(myobj.name.length-1);
		for(i=0;i<f_c[myi];i++) {
			if(DZ[myi][1][i][2]==0) continue; 
			myobj.document.forms[0].elements["txtField"+i].value="";
		}
		return;
	}
	
	if(myact==8) {
		alert("save");
		return;
	}
	
	if(myact==9) {
		alert("print");
		return;
	}
	
   	if(window.frames[myobjname].event.keyCode==13) {   
		if(isNaN(window.frames[myobjname].document.forms[0].elements["txtJump"].value)) 
			alert("输入内容必须为数字！");
		else
			MR1(myobjname,myact,my_sortorder,sort_which);
	}
}

function myDoCalendar(myobjname,myTableName,mycell){
	var myobj=window.frames[myobjname];
	var myStr1 = myobj.document.all[myTableName].cells[mycell].innerHTML;
	if(myStr1.indexOf("<INPUT",10)==-1) {
		var myStr2 = " <input name=showCalendar class='inputBrow' type=button value='...' "+" " +
				"onclick='javascript:parent.myShowCalendar(\"" + myobjname + "\",\"" + myTableName + "\"," + mycell + ");'> " ;
		myobj.document.all[myTableName].cells[mycell].innerHTML = myStr1 + myStr2; 
	}
}

function amarRand(){
	today = new Date();
	num = Math.abs(Math.sin(today.getTime()));
	return num;  
}

function myShowCalendar(myobjname,myInputName,myTableName,mycell){
	var myobj = window.frames[myobjname];
	var myInputObj = myobj.document.forms[0].elements[myInputName];
//------------老的调用处理------------------------	
//	var myOldValue="",myNewValue = "",myValue="";
//	myOldValue = myInputObj.value;
//	myValue = showModalDialog(sWebRootPath+"/Frame/page/dw/XCalendar.jsp?rand="+amarRand()+"&d="+myOldValue,"",
//			"dialogWidth=300px;dialogHeight=220px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
//	if(typeof(myValue)!="undefined" && myValue!="undefined"){
//		myNewValue = myValue;
//		if(myOldValue!=amarsoft2Real(myNewValue)){
//			myInputObj.value = amarsoft2Real(myNewValue);
//			hC(myInputObj,myobjname);
//		}
//	}
//------------老的调用处理------------------------
	var myOldValue = "";
	myOldValue = myInputObj.value;
	//改为调用统一日历框  add by xhgao 2012/09/19
	AsDialog.OpenCalender(myInputObj,"yyyy/MM/dd","1900/01/01","2100/12/31",function(myOldValue){//增加后续事件
		var myNewValue = "",myValue="";
		myValue = this.dayValue;
		if(typeof(myValue)!="undefined" && myValue!="undefined"){
		myNewValue = myValue;
		if(myOldValue!=amarsoft2Real(myNewValue)){
			myInputObj.value = amarsoft2Real(myNewValue);
			hC(myInputObj,myobjname);
			}
		}
	},0,document.getElementById("DWTR").offsetTop);
}

function myDoRemoveCalendar(myobjname,myTableName,mycell){
	var myobj=window.frames[myobjname];
	var myStr = myobj.document.all[myTableName].cells[mycell].innerHTML;
	var myIndex = myStr.indexOf("<INPUT",10);
	myobj.document.all[myTableName].cells[mycell].innerHTML = myStr.substring(0,myIndex-1);
}
function isIEBrowser(){
	if(navigator.appName=="Microsoft Internet Explorer")
		return true;
	else
		return false;
}
//for amarchange at grid when rec>100 then release need some mins.
function MR1(myobjname,myact,my_sortorder,sort_which,need_change){
	if(!beforeMR1(myobjname,myact,my_sortorder,sort_which,need_change)) return;

	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  
	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	cur_sel_rec[myi]=-1;		
	cur_sel_item[myi]="";		
	
	var curPP=0;
	if(myact==5) curPP=myobj.document.forms[0].elements["txtJump"].value;
	
	myobj.document.writeln("<script type='text/javascript'>");
	myobj.document.writeln("window.history.forward(1);");
	myobj.document.writeln("</script>");
//	myobj.document.clear();	
	myobj.document.close();
	
	switch(myact) {
		case 1:
			curpage[myi]=0;
			break;
		case 2:
			if(curpage[myi]>0) curpage[myi]--;
			break;
		case 3:
			if(curpage[myi]<pagenum[myi]-1) curpage[myi]++;
			break;
		case 4:
			curpage[myi]=pagenum[myi]-1;
			break;				
		case 5:
			curpage[myi]=curPP-1;
			if(curpage[myi]<0) curpage[myi]=0;
			if(curpage[myi]>pagenum[myi]-1) curpage[myi]=pagenum[myi]-1;			
			break;				
	}
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<html>");
	sss[jjj++]=("<head>");

	var hmGdTdContentInput ;
	var hmGdTdContentArea ;
	var hmGdTdContentSelect ;	
	hmGdTdContentInput = hmGdTdContentInput1;
	hmGdTdContentArea = hmGdTdContentArea1;
	hmGdTdContentSelect = hmGdTdContentSelect1;	
	if(arguments.length==5){
		if(need_change==1){
			hmGdTdContentInput = hmGdTdContentInput2;
			hmGdTdContentArea = hmGdTdContentArea2;
			hmGdTdContentSelect = hmGdTdContentSelect2;	
		}
	}
	
	if(DZ[myi][0][2]==0){
		hmGdTdContentInput = hmGdTdContentInput2;
		hmGdTdContentArea = hmGdTdContentArea2;
		hmGdTdContentSelect = hmGdTdContentSelect2;	
	}

	sss[jjj++]=(sContentType);
	if(DZ[myi][0][0]==1){
		sss[jjj++]=("<link href='"+dwCSSPath+"style_dw.css' rel=stylesheet>");
		sss[jjj++]=("<link href='"+sWebRootPath+sSkinPath+"/css/style_dw.css' rel=stylesheet>");
	}else{
		sss[jjj++]=("<link href='"+dwCSSPath+"style_ff.css' rel=stylesheet>");
		sss[jjj++]=("<link href='"+sWebRootPath+sSkinPath+"/css/style_ff.css' rel=stylesheet>");
	}
	sss[jjj++]=("</head>");

	sss[jjj++]=("<body oncontextmenu='self.event.returnValue=false' "+
			"onresize='parent.change_height(\""+myobj.name+"\")' "+
			"onmousedown='if(parent.mE(event, \""+myobj.name+"\")==true){parent.mySelectRow();}' "+
			"onkeydown='parent.kD(event, \""+myobj.name+"\")' "+
			"onkeyup='parent.kU(event, \""+myobj.name+"\");parent.mySelectRow()' >"); 

	if(bNeedCA) 
		sss[jjj++]=(" <object id=doit style='display:none' classid='CLSID:8BE89452-A144-49BC-9643-A3D436D83241' border=0 width=0 height=0></object>  ");
	
	sss[jjj++]=("<form name='form1' class='gdform' >");
	
	var myS=new Array("","readonly","disabled","readonly","","disabled","disabled","disabled"); 
	var myR=DZ[myi][0][2]; 
	var myFS,myHeaderUnit; 
	var myAlign=new Array(""," align=left "," align=center "," align=right ");
	var myAlign2=new Array("","left","center","right");
	
	sss[jjj++]=("<span style='display:none'>");
	sss[jjj++]=("<span style='font-size: 9pt'>");
	sss[jjj++]=("<a href='javascript:parent.MR1(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>首页</a> "+
			" <a href='javascript:parent.MR1(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>前一页</a> "+
			" <a href='javascript:parent.MR1(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>后一页</a> "+
			" <a href='javascript:parent.MR1(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>尾页</a> ");
	sss[jjj++]=("&nbsp;&nbsp;共&nbsp;"+rr_c[myi]+"&nbsp;条记录,共&nbsp;"+pagenum[myi]+"&nbsp;页,当前为第&nbsp;"+(curpage[myi]+1)+"&nbsp;页");
	sss[jjj++]=("</span><br>");
	
	sss[jjj++]=("<span style='font-size: 9pt'>按&nbsp;");
	for(var i=0;i<f_c[myi];i++) {
		if(DZ[myi][1][i][2]==0) continue; 
		sss[jjj++]=DZ[myi][1][i][0]+"：<input type=text name=txtField"+i+" style='FONT-SIZE: 9pt;border-style:groove;text-align:center;width:40pt;height:13pt' size=1>";
	}
	sss[jjj++]=("<input type=button name=btnReset  value='重置' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",7,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("<input type=button name=btnSearch value='查找' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",6,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("<input type=button name=btnSave   value='另存' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",8,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("<input type=button name=btnPrint  value='打印' style='cursor:pointer;FONT-SIZE: 8pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onclick='javascript:parent.MRK1(\""+myobjname+"\",9,"+my_sortorder+","+sort_which+")'>");
	sss[jjj++]=("</span><br>");
	sss[jjj++]=("</span>");
	sss[jjj++]=("<div id='tableContainer' class='tableContainer' style='overflow:auto;'>");
	sss[jjj++]=("<table "+hmGDTable +">");
	if(isIEBrowser())
		sss[jjj++]=("<thead class='fixedHeader'>");
	else {
		sss[jjj++]=("<tbody class='scrollContent fixedHeader' >");
	}

	if(window.topHtml){
	sss[jjj++]=("<tr style='display:table-row'>");
    sss[jjj++]=("<td colspan="+(f_c[myi]+1)+" align=left>");
    sss[jjj++]=(window.topHtml);
    sss[jjj++]=("</td>");
    sss[jjj++]=("</tr>");
	}
    //显示表头
    sss[jjj++]=("<tr "+hmGDHeaderTr +">");
    sss[jjj++]=("<th "+hmGDTdHeader+">");
    sss[jjj++]=(!document.getElementById("FilterArea")?"&nbsp;":"<div onclick='parent.showFilterArea("+myi+")' class='GDTdHeaderSearch'></div>");
    sss[jjj++]=("</th>");
    
	for(i=0;i<f_c[myi];i++) {
		if(DZ[myi][1][i][2]==0) continue; 
		var sLastStyle = hmGDTdHeader;
		if(i==f_c[myi]-1)sLastStyle=hmGDTdHeader_last;
		myHeaderUnit=DZ[myi][1][i][0]+DZ[myi][1][i][17]+sGDTitleSpace;
		if(DZ[myi][1][i][6]==1) {
			if(sort_which==i) sss[jjj++]=("<th "+sLastStyle +" " + myAlign[2] + " onclick='parent.my_load_s("+my_sortorder+","+i+",\""+myobj.name+"\")' >"+myHeaderUnit+myimgstr+"</th>");
			else              sss[jjj++]=("<th "+sLastStyle +" " + myAlign[2] + "  onclick='parent.my_load_s("+my_sortorder+","+i+",\""+myobj.name+"\")' >"+myHeaderUnit+"</th>");
		}
		else 		          sss[jjj++]=("<th "+sLastStyle +" " + myAlign[2] + "   >"+myHeaderUnit+"</th>");
	}
	sss[jjj++]=("</tr>");
	if(isIEBrowser()){
		sss[jjj++]=("</thead>");
		sss[jjj++]=("<tbody class='scrollContent' >");
	}
	var myCale;
	var myevent_num=""; 
//	var tjTMP="";
	var mytj=new Array();
	for(i=0;i<f_c[myi];i++){
		mytj[i]=0;
	}
	for(var j=curpage[myi]*pagesize[myi];j<(curpage[myi]+1)*pagesize[myi]&&j<rr_c[myi];j++){
		sss[jjj++]=("<tr height=1");
		if (j%2==0){
			sss[jjj++]=(" class='corss_walk1'");
		}else{
			sss[jjj++]=(" class='corss_walk2'");
		}
		if(j==curpage[myi]*pagesize[myi])
			sss[jjj++]=(" id='DWTRDATA'");
		sss[jjj++]=(">");
		
		sss[jjj++]=("<td id='R"+j+"FZ' class='serial_td' "+ hmGdTdSerial +">"+(j+1)+"</td>");
		
		for(i=0;i<f_c[myi];i++){
			if(DZ[myi][1][i][2]==0) continue; 
			
			myFS = DZ[myi][1][i][11];  
			
			if(myR==1 || (myR==0&&(DZ[myi][1][i][3]==1)) )
				str2=myS[myFS];    
			else
				str2=" ";	
			
			if(DZ[myi][1][i][7]==0) str3=" ";			
			else                    str3=" maxlength="+DZ[myi][1][i][7];
			
			myevent_num=""; 
			if( DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5)	
				myevent_num="  onblur=parent.myNumberBL(this,'"+myobjname+"') onkeyup=parent.myNumberKU(this,event) onbeforepaste=parent.myNumberBFP(this) "; 
			else 
				myevent_num=" "; 
			
			str3 = str3+myevent_num; 
			
			// 单个选择框
			if(myFS==-1) {
				sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+myAlign[2]+"><input type='checkbox' onclick=this.value=this.checked?'√':'' name=R"+j+"F"+i+" "+_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+"/></td>";
			}
			//文本框
			if(myFS==1) {
				if(DZ[myi][1][i][12]==3 && myR==0)	myCale = " "+hmDate+" onclick='javascript:parent.myShowCalendar(\""+myobj.name+"\",\"R"+j+"F"+i+"\",\"dataTable\","+((j-curpage[myi]*pagesize[myi]+1)*(f_c[myi]+1)+i+1)+");'> ";
				else				myCale = " ";
				
				if(DZ[myi][1][i][8]==1) 
					sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" ><input   "+" " +hmGdTdContentInput + " "+str2+" "+_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+
						" type=text value='"+amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12])+"' name=R"+j+"F"+i+"  "+str3+" >"+myCale+"</td>";
				else
					sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" ><input   "+" " +hmGdTdContentInput + " "+str2+" "+_getStyle(DZ[myi][1][i][10], "background-color: transparent;text-align:"+myAlign2[DZ[myi][1][i][8]]+";")+
						" type=text value='"+amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12])+"' name=R"+j+"F"+i+"  "+str3+" >"+myCale+"</td>";
			}
			
			//Textarea框
			if(myFS==3) 
				sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" >"+
					"<textarea "+" " +hmGdTdContentArea + 
					"  onkeydown=parent.textareaMaxByIndex("+myi+","+j+","+i+") "+
					"  onkeyup=parent.textareaMaxByIndex("+myi+","+j+","+i+")  "+
					"  type=textfield "+str2+" "+_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+" name=R"+j+"F"+i+" >"+DZ[myi][2][my_index[myi][j]][i]+"</textarea></td>";					
			//选择框
			if(myFS==2){
				sss[jjj++] = "<td id=TDR"+j+"F"+i+" "+hmGdTdContent +" >";
				if(myR==1){
					sss[jjj++] = "<input value='"+amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12])+"' type='hidden' name=R"+j+"F"+i+" >";
					for(var k=0;k<DZ[myi][1][i][20].length/2;k++){
						if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i]){
							sss[jjj++] = "<input   "+" " +hmGdTdContentInput + " readonly "+_getStyle(DZ[myi][1][i][10], "background-color: transparent;text-align:center;")+
								" type=text value='"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"' "+str3+" name=R"+j+"F"+i+"Name >";
							break;
						}
					}
				}else{
					sss[jjj++] = " <select "+" " +hmGdTdContentSelect + " "+str2+" " +_getStyle(DZ[myi][1][i][10], "min-width:100%;")+" name=R"+j+"F"+i+//background-color: transparent;
						" value='"+DZ[myi][2][my_index[myi][j]][i]+"'    "+
						" onchange='parent.mE(event, \""+myobj.name+"\");parent.myHandleSelectChangeByIndex("+myi+","+j+","+i+");'   >";
					
					for(var k=0;k<DZ[myi][1][i][20].length/2;k++){
						if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i])
							sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"' selected>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
						else
							sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"'>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
					}
					sss[jjj++] = "</select>";
				}
				sss[jjj++] = "</td>";
			}
			
			//radio(5横向6竖向)
			if(myFS==5||myFS==6){
				var mybr = "<br>";
				if(myFS==5) mybr="";
				sss[jjj++] = "<td id=TDR"+j+"F"+i+ " "+hmGdTdContent +hmGdTdContentSelect+">";
				for(var k=0;k<DZ[myi][1][i][20].length/2;k++){
					if(DZ[myi][1][i][20][2*k+1]=='') continue;
					if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i]){
						sss[jjj++] = "<label style='cursor: pointer;'><input name=R"+j+"F"+i+"_Radio type='radio' value='"+DZ[myi][1][i][20][2*k]+"' checked " + " "+str2+" " +_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+
								"onclick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobj.name+"');\"/>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr+"</label>";
					}else
						sss[jjj++] = "<label style='cursor: pointer;'><input name=R"+j+"F"+i+"_Radio type='radio' value='"+DZ[myi][1][i][20][2*k]+"' "+str2+" " +_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+
								"onclick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobj.name+"');\"/>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr+"</label>";
				}
				sss[jjj++] = "<input name=R"+j+"F"+i+" type='hidden' value='"+DZ[myi][2][my_index[myi][j]][i]+"'/>";
				sss[jjj++] =  "</td>";
			}
			
			//checkbox
			if(myFS==7){
				sss[jjj++] = "<td id=TDR"+j+"F"+i+ " "+hmGdTdContent +hmGdTdContentSelect+">";
				for(k=0;k<DZ[myi][1][i][20].length/2;k++){
					if(DZ[myi][1][i][20][2*k+1]=='') continue;
					
					if(DZ[myi][2][my_index[myi][j]][i]=='' || 
							!ArrayOfcontains(DZ[myi][2][my_index[myi][j]][i].split(','),DZ[myi][1][i][20][2*k]))
						sss[jjj++] = "<label style='cursor: pointer;'><input type=checkbox name=R"+j+"F"+i+"_Checkbox value='"+DZ[myi][1][i][20][2*k]+"' " +str2+" " +_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+
								"onclick=\"document.all('R"+j+"F"+i+"').value = parent.getCheckboxValue("+j+","+i+",'"+myobj.name+"');parent.hC(document.all('R"+j+"F"+i+"'),'"+myobj.name+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</label>";
					else
						sss[jjj++] = "<label style='cursor: pointer;'><input type=checkbox name=R"+j+"F"+i+"_Checkbox value='"+DZ[myi][1][i][20][2*k]+"' checked " +str2+" " +_getStyle(DZ[myi][1][i][10], "background-color: transparent;")+
								"onclick=\"document.all('R"+j+"F"+i+"').value = parent.getCheckboxValue("+j+","+i+",'"+myobj.name+"');parent.hC(document.all('R"+j+"F"+i+"'),'"+myobj.name+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</label>";
				}
				sss[jjj++] = "<input name=R"+j+"F"+i+" type='hidden' value='"+DZ[myi][2][my_index[myi][j]][i]+"'/>";
				sss[jjj++] =  "</td>";
			}
			
			if(DZ[myi][1][i][14]!=1){
				//tjTMP +="第"+(j+1)+"行第"+(i+1)+"列小计前="+mytj[i]+"，加值="+DZ[myi][2][my_index[myi][j]][i]+"\r\n";
				//小计值处理
				mytj[i] += DZ[myi][2][my_index[myi][j]][i];
			}
		}
		sss[jjj++]=("</tr>");
	}
		
	if(DZ[myi][0][4]==1){ //my_load_show:ShowSummary
		//小计
		sss[jjj++]=("<tr "+hmRPPageSumTr +"  style='line-height:"+hmCountLineHeight+"px;'>");
		sss[jjj++] = "<td "+hmRPPageSumTdSerial+" id=R"+rr_c[myi]+"F0 align="+myAlign2[DZ[myi][1][0][8]]+" >小计</td>";
		for(i=0;i<f_c[myi];i++){
			if(DZ[myi][1][i][2]==0) continue; 
			if(DZ[myi][1][i][14]==2)          //sum
				sss[jjj++] = "<td "+hmRPPageSumTd+" id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+amarMoney(mytj[i],DZ[myi][1][i][12])+"&nbsp;</td>";
			else if(DZ[myi][1][i][14]==3)     //avg
				sss[jjj++] = "<td "+hmRPPageSumTd+" id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+amarMoney(mytj[i]/rr_c[myi],DZ[myi][1][i][12])+"&nbsp;</td>";
			else if(DZ[myi][1][i][14]==4)     //count
				sss[jjj++] = "<td "+hmRPPageSumTd+" id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+rr_c[myi]+"&nbsp;</td>";
			else
				sss[jjj++] = "<td "+hmRPPageSumTd+" >&nbsp;</td>";
		}
		sss[jjj++]=("</tr>");
		
		//总计
		sss[jjj++]=("<tr "+hmRPTotalSumTr +" style='line-height:"+hmCountLineHeight+"px;'>");
		sss[jjj++] = "<td "+hmRPTotalSumTdSerial+" id=R"+rr_c[myi]+"F0 align="+myAlign2[DZ[myi][1][0][8]]+" >总计</td>";
		for(i=0;i<f_c[myi];i++){
			if(DZ[myi][1][i][2]==0) continue; 
			if(DZ[myi][1][i][14]==2)          //sum
				sss[jjj++] = "<td "+hmRPTotalSumTd+" id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+amarMoney(DZ[myi][3][i],DZ[myi][1][i][12])+"&nbsp;</td>";				
			else if(DZ[myi][1][i][14]==3)     //avg
				sss[jjj++] = "<td "+hmRPTotalSumTd+" id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+amarMoney(getItemTotalByIndex(myi,i)/rr_c[myi],DZ[myi][1][i][12])+"&nbsp;</td>";
			else if(DZ[myi][1][i][14]==4)     //count
				sss[jjj++] = "<td "+hmRPTotalSumTd+" id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+rr_c[myi]+"&nbsp;</td>";
			else
				sss[jjj++] = "<td "+hmRPTotalSumTd+" >&nbsp;</td>";
		}
		sss[jjj++]=("</tr>");
	}

	if(pagenum[myi]>1 || s_p_c[myi]>1 )
		sss[jjj++]=("	<tr style='display:table-row'> ");
	else
		sss[jjj++]=("	<tr style='display:none'> ");
	
    sss[jjj++]=("          <td colspan="+(f_c[myi]+1)+" "+hmGdTdPage+" align=left>");
	sss[jjj++]=("<input type=hidden name=txtJump >");
	 	
	//服务器端分页
	if(s_p_c[myi]>1 ){
 		if(pagenum[myi]>1 ){ 
 		    sss[jjj++]=("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"); 
 		}
 	    sss[jjj++]=("                <span class='ServerFirstPage' style='display:inline-block;' title='第一页(服务器)' onclick='javascript:parent.MR1_s(\""+myobjname+"\",1,"+my_sortorder+","+sort_which+")'>&nbsp;</span>"); 
 	    sss[jjj++]=("                <span class='ServerPrevPage' style='display:inline-block;' title='前一页(服务器)' onclick='javascript:parent.MR1_s(\""+myobjname+"\",2,"+my_sortorder+","+sort_which+")'>&nbsp;</span>"); 
 		sss[jjj++]=("                &nbsp"+(s_c_p[myi]+1)+"/"+s_p_c[myi]+"&nbsp;("+s_r_c[myi]+")&nbsp;"); 
 	    sss[jjj++]=("                <span class='ServerNextPage' style='display:inline-block;' title='下一页(服务器)' onclick='javascript:parent.MR1_s(\""+myobjname+"\",3,"+my_sortorder+","+sort_which+")'>&nbsp;</span>"); 
 	    sss[jjj++]=("                <span class='ServerLastPage' style='display:inline-block;' title='最后一页(服务器)' onclick='javascript:parent.MR1_s(\""+myobjname+"\",4,"+my_sortorder+","+sort_which+")'>&nbsp;</span>"); 
 		sss[jjj++]=("		     &nbsp;&nbsp;跳至&nbsp;<input type=text name=txtJump_s class='GdJumpInput' onmousedown=parent.AsLink.stopEvent(event) onkeyup=parent.AsLink.stopEvent(event) onkeydown='javascript:parent.MR1_s(\""+myobjname+"\",5,"+my_sortorder+","+sort_which+", null, event)'>&nbsp;页");
 	}
	
    sss[jjj++]=("          </td>");
    sss[jjj++]=("   </tr>	");
    if(window.bottomHtml){
    sss[jjj++]=("<tr style='display:table-row'>");
    sss[jjj++]=("<td colspan="+(f_c[myi]+1)+" align=left>");
    sss[jjj++]=(window.bottomHtml);
    sss[jjj++]=("</td>");
    sss[jjj++]=("</tr>");
    }
	
	sss[jjj++]=("</tbody>");
	sss[jjj++]=("</table>");
	sss[jjj++]=("</div>");
	sss[jjj++]=("</form>");
	sss[jjj++]=("</body>");
	sss[jjj++]=("</html>");

	myobj.document.writeln(amarsoft2Html(sss.join('')));		
	myobj.document.close();		
	
	//myobj.document.getElementById('tableContainer').style.height = myobj.document.body.clientHeight - myobj.document.getElementById('tableContainer').offsetTop; 
	//记录当前表格的单元格的样式
	try {
		for(j=0;j<my_index[myi].length;j++){
			if(DZ[myi][0][0]==1) {
				if(my_index[myi][j]==-1) break; 
				for(i=0;i<f_c[myi];i++){
					if(DZ[myi][1][i][2]==1){
						f_css[myi][i]=myobj.document.getElementById("TDR0F"+i).style.cssText;
					}
				}
				break;
			} else {
				for(i=0;i<f_c[myi];i++)			
					f_css[myi][i]=myobj.document.getElementById("TDR"+curpage[myi]+"F"+i).style.cssText;
				break;				
			}		
		}	
	} catch(e) { }
	
	window.status="Ready";  
	window.status=myoldstatus;  
	
	//for default:line 1 highlight
	if(rr_c[myi] >0 && bHighlightFirst){
		sR(-1,curpage[myi]*pagesize[myi],myobjname);
		iCurRow=curpage[myi]*pagesize[myi];
	}
	
	//myAfterLoadGrid(myi);
	change_height(myobj.name);
}

function change_height(framename){
	var myobj = frames[framename];
	//alert(myobj.document.body.style.paddingLeft);
	//alert("myobj.document.body.offsetWidth="+myobj.document.body.offsetWidth+",myobj.document.getElementById('tableContainer').offsetLeft="+myobj.document.getElementById('tableContainer').offsetLeft);
	var width = myobj.document.body.offsetWidth-15;//- myobj.document.getElementById('tableContainer').offsetLeft*2;
	if(width > 0) myobj.document.getElementById('tableContainer').style.width = width;
	var height = myobj.document.body.clientHeight - myobj.document.getElementById('tableContainer').offsetTop - 15;
	if(height > 0) myobj.document.getElementById('tableContainer').style.height = height;
}

function MRK2(myobjname,myact){
	if(!beforeMRK2(myobjname,myact)) return;

	if(window.frames[myobjname].event.keyCode==13) {   
		if(isNaN(window.frames[myobjname].document.forms[0].elements["txtJump"].value)) 
			alert("输入内容必须为数字！");
		else
			MR2(myobjname,myact);
	}
}

function as_decrypt(Password){
	var pwd,key,i,j;
    pwd = "";
    key = "AmarsoftDataWindowEncrypt12345";
	for(i=0;i<=Password.length/2-1;i++){
		j = parseInt("0x"+Password.substr(i*2,2));
		j = j - key.charCodeAt(i - parseInt(i/30)*30);
		jj = j+255;
		if(j<0)
			pwd += String.fromCharCode(jj);
		else
			pwd += String.fromCharCode(j);
	}
	
	return pwd;
}

function as_nochange(iDW){
	var i = 0;	
	for(i=0;i<my_index[iDW].length;i++){
		if(my_index[iDW][i]==-1) break; 	
		my_attribute[iDW][i]=0;	
		for(var j=0;j<my_change[iDW][i].length;j++) {	
			my_change[iDW][i][j]=0;	
			my_changedoldvalues[iDW][i][j]="";	
		}
	}
}

function isValid(){
	return true;
}






























//for amarchange at grid when rec>100 then release need some mins.







function my_load(my_sortorder,sort_which,myobjname,need_change){
	if(!beforeMy_load(my_sortorder,sort_which,myobjname,need_change)) return;
	if(!isValid()) return;

	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	cur_sortorder[myi] = my_sortorder;
	cur_sortfield[myi] = sort_which;			
	
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  
	
	if(needReComputeIndex[myi]==1) {
		cur_sel_rec[myi]=-1;		
		cur_sel_item[myi]="";		
		a_b(my_sortorder,DZ[myi][2],sort_which,sort_begin[myi],sort_end[myi],my_index[myi]);
	}
	
	if(my_sortorder==1) {
		myimgstr="<span class='sort_up' style='display:inline-block;'>&nbsp;</span>";
		my_sortorder=0;
	} else if(my_sortorder==0) {
		myimgstr="<span class='sort_down' style='display:inline-block;'>&nbsp;</span>";
		my_sortorder=1;
	} else if(my_sortorder==2) {
		myimgstr="&nbsp;";
		my_sortorder=0;
	}
//	myobj.document.clear();	
	myobj.document.close();
	
	curpage[myi]=0;
	if(DZ[myi][0][0]==1){
		if(arguments.length==4) 
			MR1(myobjname,1,my_sortorder,sort_which,need_change);
		else
			MR1(myobjname,1,my_sortorder,sort_which);
	}else                   
		MR2(myobjname,1);
		
	window.status="Ready";  
	window.status=myoldstatus;  
 
	if(bShowUnloadMessage)
		document.body.onbeforeunload=closeCheck;//(myobjname);
}

function my_load_show(my_sortorder,sort_which,myobjname){
	my_load(my_sortorder,sort_which,myobjname);
}

function getCodeTitle(codeArray,codeno){
	if(!codeArray)return codeno;
	for(var i=0;i<codeArray.length-1;i+=2){
		if(codeno==codeArray[i])
			return codeArray[i+1];
	}
	return codeno;
}

function sR(lastRec,iRec,myname){
	if(!beforeSR(lastRec,iRec,myname)) return;

	var myi=myname.substring(myname.length-1);
	
	last_sel_rec[myi]=lastRec;
	cur_sel_rec[myi]=iRec;
	iCurRow = iRec;
	if( DZ[myi][0][0]==1) {
		var ii,sStyle,mya;
		if(last_sel_rec[myi]!=-1) {
			mya = my_attribute[myi][my_index[myi][lastRec]];
			for(ii=0;ii<f_c[myi];ii++) {
				if(DZ[myi][1][ii][2]==0) continue;
				sName="TDR"+last_sel_rec[myi]+"F"+ii;
				
				sStyle = "";
				sStyle=DZ[myi][1][ii][10];
				if(sStyle!="") {    
					sStyle=sStyle.substring(sStyle.indexOf("style=\"")+7);
					sStyle=sStyle.substring(0,sStyle.length-1);
					sStyle=";"+sStyle;
				}
				var _obj = window.frames[myname].document.getElementById(sName);
				if(_obj.className){
					var classes = _obj.className.split(" ");
					var newClass = "";
					for(var i = 0; i < classes.length; i++){
						if(classes[i] == "high_light") continue;
						newClass += " " + classes[i];
					}
					_obj.className = newClass;
				}
				_obj.style.cssText=f_css[myi][ii]+sStyle;
				if(mya==3 || mya==4 || mya==5 || mya==6) _obj.style.cssText=f_css[myi][ii]+sStyle+";border-style:none;border-width:thin;background-color:#EEEEEE;color:#AAAAAA";
			}
		}
		if(cur_sel_rec[myi]!=-1) {
			for(ii=0;ii<f_c[myi];ii++) {
				if(DZ[myi][1][ii][2]==0) continue;
				sName="TDR"+cur_sel_rec[myi]+"F"+ii;
				if(bHighlight)
					var _obj = window.frames[myname].document.getElementById(sName);
					_obj.className = _obj.className + " high_light";
					_obj.style.cssText=f_css[myi][ii]+";border-style:none;border-width:thin;";
			}
		}
	}		
}

function CSS(iRec,myname){
	if(!beforeCSS(iRec,myname)) return;

	var myi=myname.substring(myname.length-1);
	{
		var ii,mya;
		mya = my_attribute[myi][my_index[myi][iRec]];
		for(ii=0;ii<f_c[myi];ii++) {
			if(DZ[myi][1][ii][2]==0) continue;
			sName="TDR"+cur_sel_rec[myi]+"F"+ii;
			if(mya==1 || mya==2)  
				window.frames[myname].document.getElementById(sName).style.cssText=f_css[myi][ii]+
					";border-style:none;border-width:thin;background-color:#FDFDF3;color:#0000FF";
			if(mya==3 || mya==4 || mya==5 || mya==6)  
				window.frames[myname].document.getElementById(sName).style.cssText=f_css[myi][ii]+
					";border-style:none;border-width:thin;background-color:#EEEEEE;color:#AAAAAA";			
		}
	}
}

function sR_show(lastRec,iRec,myname){
	if(!beforeSR_show(lastRec,iRec,myname)) return;
	var myi=myname.substring(myname.length-1);

	last_sel_rec[myi]=lastRec;
	cur_sel_rec[myi]=iRec;
	if( DZ[myi][0][0]==1) {
		var ii,sStyle,mya;
		if(last_sel_rec[myi]!=-1) {
			mya = my_attribute[myi][my_index[myi][lastRec]];
			for(ii=0;ii<f_c[myi];ii++) {
				if(DZ[myi][1][ii][2]==0) continue;
				sName="R"+last_sel_rec[myi]+"F"+ii;
				
				sStyle = "";
				sStyle=DZ[myi][1][ii][10];
				if(sStyle!="") {    
					sStyle=sStyle.substring(sStyle.indexOf("style=\"")+7);
					sStyle=sStyle.substring(0,sStyle.length-1);
					sStyle=";"+sStyle;
				}
				
				try {
					var _obj = window.frames[myname].document.getElementById(sName);
					if(_obj.className){
						var classes = _obj.className.split(" ");
						var newClass = "";
						for(var i = 0; i < classes.length; i++){
							if(classes[i] == "high_light") continue;
							newClass += " " + classes[i];
						}
						_obj.className = newClass;
					}
					_obj.style.cssText="font-size:9pt"+";"+f_css[myi][ii];
					if(mya==3 || mya==4 || mya==5 || mya==6) _obj.style.cssText=f_css[myi][ii]+";border-style:none;border-width:thin;background-color:#EEEEEE;color:#AAAAAA;";    
				} catch(e) { }
			}
		}
		
		if(cur_sel_rec[myi]!=-1) {
			for(ii=0;ii<f_c[myi];ii++) {
				if(DZ[myi][1][ii][2]==0) continue;
				sName="R"+cur_sel_rec[myi]+"F"+ii;
				try {
					if(bHighlight){
						var _obj = window.frames[myname].document.getElementById(sName);
						_obj.className = _obj.className + " high_light";
						_obj.style.cssText="font-size:9pt"+";"+f_css[myi][ii]+";border-style:none;border-width:thin;";
					}
				} catch(e) {}
			}
		}
	}		
}

function myLastCB(myframename,curItemName){
	if(!beforeMyLastCB(myframename,curItemName)) return;
	if(myframename=="") return;
	if(curItemName=="") return;
	
	var myi,objp;
	var iBegin,iEnd,iField,iRec;
	myi=myframename.substring(myframename.length-1);
	objp = window.frames[myframename];
	last_sel_item[myi]=cur_sel_item[myi];
	cur_sel_item[myi]=curItemName;
		
	if(last_sel_item[myi]!=""){
		iBegin=last_sel_item[myi].indexOf("R");
		iEnd=last_sel_item[myi].indexOf("F");
		if(iBegin!=-1&&iEnd!=-1) {
			iRec=parseInt(last_sel_item[myi].substring(iBegin+1,iEnd));
			iField=parseInt(last_sel_item[myi].substring(iEnd+1));
			if(("HXD"+amarValue(objp.document.forms[0].elements[last_sel_item[myi]].value,DZ[myi][1][iField][12]))!=("HXD"+DZ[myi][2][my_index[myi][iRec]][iField])) 
				hC(objp.document.forms[0].elements[last_sel_item[myi]],myframename);
			/*if(cur_sel_item[myi]!=last_sel_item[myi])
				vI(objp.document.forms[0].elements[last_sel_item[myi]],myframename);
				*/
		}
	}
}

function mE(e, myframename){
 try{
 	if(!beforeMouseDown(myframename)) return;
 	if(myframename==""){
		if(cur_frame!="") {
			last_frame=cur_frame;
			cur_frame="";
			myLastCB(last_frame,"");
		}
		return;
	}	
	
	if(cur_frame=="") cur_frame=myframename;
	
	var curItemName0 = cur_sel_item[cur_frame.substring(cur_frame.length-1)];
	var iBegin0,iEnd0,iField0,iRec0,myi0,obj0;
	myi0 = myframename.substring(myframename.length-1);
	obj0 = window.frames[myframename].document.forms[0].elements[curItemName0];
	iBegin0=curItemName0.indexOf("R");

	if(iBegin0!=-1 ) {
		iEnd0=curItemName0.indexOf("F");
		iRec0=parseInt(curItemName0.substring(iBegin0+1,iEnd0));
		iField0=parseInt(curItemName0.substring(iEnd0+1));
		if(obj0.onchange!=null && ("HXD"+amarValue(obj0.value,DZ[myi0][1][iField0][12])) !=("HXD"+DZ[myi0][2][my_index[myi0][iRec0]][iField0])  )   
		{
			hC(obj0,myframename);
			DZ[myi0][2][my_index[myi0][iRec0]][iField0] = real2Amarsoft(amarValue(obj0.value,DZ[myi0][1][iField0][12]));

			try {
				obj0.amar_onchange();
			} catch(err) {  }
		}
	}
	
	var myi,objp,obj,curItemName;
	var iBegin,iEnd,iField,iRec,sName;
	myi=myframename.substring(myframename.length-1);
	objp = window.frames[myframename];
	e = e || objp.event;
	obj = e.srcElement||e.target;
	
	if( obj.tagName=="BODY" || (obj.tagName=="TD"&& obj.id.substring(0,2)!="TD")|| (obj.tagName=="A" && obj.href!=null) || (obj.onclick!=null) )  	 	
	{
		myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
		return;
	}
	
	if(typeof(obj)!='undefined' && obj.name!='undefined' && obj.name!=null && obj.name!="") {
		curItemName=obj.name;
	}else{
		curItemName="";	
		if(obj.tagName=='TD'&& obj.id.substring(0,2)=="TD") curItemName = obj.id.substring(2);
	}
	if(obj.name=='txtJump') return; 
	
	if(myframename!=cur_frame) {
		last_frame=cur_frame;
		cur_frame=myframename;
		myLastCB(last_frame,"");
	}else{
		myLastCB(myframename,curItemName);
	}
	
	if(curItemName!="") {
		if((iBegin=curItemName.indexOf("img"))!=-1) {
			iRec=parseInt(curItemName.substring(iBegin+3));
			sR(cur_sel_rec[myi],iRec,myframename);
			for(var i=0;i<f_c[myi];i++) 
				if(DZ[myi][1][i][2]==1) break; 			
			sName="R"+iRec+"F"+i;
			try {
	  		if(!objp.document.forms[0].elements[sName].disabled) 
	  			objp.document.forms[0].elements[sName].focus();
	  		} catch(e) { }
		}else {
			iBegin=curItemName.indexOf("R");
			iEnd=curItemName.indexOf("F");
			iRec=parseInt(curItemName.substring(iBegin+1,iEnd));
			iField=parseInt(curItemName.substring(iEnd+1));
			iCurRow=iRec; iCurCol=iField;
			if(iBegin!=-1) {
				sR(cur_sel_rec[myi],iRec,myframename);
				cur_sel_item[myi]=curItemName;
		  	}
		}
	}else {
		if(cur_sel_rec[myi]!=-1) {
			for(i=0;i<f_c[myi];i++) 
				if(DZ[myi][1][i][2]==1) break; 			
			sName="R"+cur_sel_rec[myi]+"F"+i;
			try {
				if(!objp.document.forms[0].elements[sName].disabled && (obj.parentNode.tagName.toUpperCase()!='SELECT')) 
					objp.document.forms[0].elements[sName].focus();
	  		} catch(e) { }
  		}
	}	
		   
	doMouseDown(myframename);
	afterMouseDown(myframename);
  } catch(e) {	
	alert(e.name+" "+e.number+" :"+e.message); 
  } 	
  return true;
}

function mE_show(e, myframename){
 try {
 	if(!beforeMouseDown_show(myframename)) return;
	if(myframename==""){
		if(cur_frame!="") {
			last_frame=cur_frame;
			cur_frame="";
			myLastCB(last_frame,"");
		}
		return;
	}	
	
	var myi,objp,obj,curItemName;
	var iBegin,iEnd,iField,iRec;
	myi=myframename.substring(myframename.length-1);
	objp = window.frames[myframename];
	e = e || objp.event;
	obj = e.srcElement||e.target;
	if(typeof(obj)!='undefined' && obj.id!='undefined' && obj.id!=null && obj.id!="") 
		curItemName=obj.id;
	else
		curItemName="";	
	
	if(curItemName!="") {
		iBegin=curItemName.indexOf("R");
		iEnd=curItemName.indexOf("F");
		iRec=parseInt(curItemName.substring(iBegin+1,iEnd));
		iField=parseInt(curItemName.substring(iEnd+1));
		iCurRow=iRec; iCurCol=iField;
		
		sR_show(cur_sel_rec[myi],iRec,myframename);		
	}
	
	doMouseDown_show(myframename);
	afterMouseDown_show(myframename);   
  }catch(e){  } 	
}


function myTabNext(myname,iRec,cutItemName){
	var myi=myname.substring(myname.length-1);
	var i,j="O",sName2="";
	for(i=0;i<window.frames[myname].document.all.length;i++){
		if(window.frames[myname].document.all[i].name==cutItemName){
			j="1";
			continue;
		}
		if (j == "1"
				&& window.frames[myname].document.all[i].name != null
				&& window.frames(myname).document.all[i].name.indexOf("R") != -1) {
			sName2=window.frames[myname].document.all[i].name;
			break;
		}
	}
	if(sName2!="") {
		var iBegin2,iEnd2,iField2,iRec2;
		iBegin2=sName2.indexOf("R");
		iEnd2=sName2.indexOf("F");
		iRec2=parseInt(sName2.substring(iBegin2+1,iEnd2));
		iField2=parseInt(sName2.substring(iEnd2+1));
		try {
		if(DZ[myi][1][iField2][3]==0)
			window.frames[myname].document.forms[0].elements[sName2].focus();
		} catch(e) {  }
		if(iRec!=iRec2)
	  		sR(cur_sel_rec[myi],iRec2,myname);
	}
}

function kU_show(e, myframename){
	if(!beforeKeyUp_show(e, myframename)) return;
	var objp = window.frames[myframename];
	e = e || objp.event;
	if(e.keyCode==113){	
		AsSaveResult("myform"+myframename.substring(myframename.length-1));	
		return;	
	}	
	if( e.keyCode==123 && e.shiftKey  && e.ctrlKey && e.altKey ){
		alert("Welcome!  This is Amarsoft@DataWindow!  Copyright (C) 1998-2012 Amarsoft Corporation!  All rights reserved!");
		return;
	}
	if( e.keyCode==122 && e.shiftKey  && e.ctrlKey && e.altKey ){
		objp.document.body.oncontextmenu = 'self.event.returnValue=true';
		return;
	}

	doKeyUp_show(myframename);
	afterKeyUp_show(myframename);   	
}

function kD(e, myframename){
	if(!beforeKeyDown(myframename)) return;
	if(myHandleSpecialKey(e, myframename,true)) return;
	var objp = window.frames[myframename];
	e = e || objp.event;
	if( e.keyCode==122 && e.shiftKey  && e.ctrlKey && e.altKey ){
		objp.document.body.oncontextmenu = 'self.event.returnValue=true';
		return;
	}
	if(e.keyCode==114 || e.keyCode==122 || (e.keyCode==78 && e.ctrlKey) ){
		e.keyCode=0; 	
		e.returnValue=false; 	
	    return false;	
	}	
	if( e.keyCode==123 && e.shiftKey  && e.ctrlKey && e.altKey){
		alert("Welcome!  This is Amarsoft@DataWindow!  Copyright (C) 1998-2012 Amarsoft Corporation!  All rights reserved!");
		return;
	}

	//只处理TAB事件和回车事件
	if(e.keyCode!=9 && e.keyCode!=13) return;
	
	var myi0=myframename.substring(myframename.length-1);
	
	//仅对select and input and textarea进行处理	
	var obj0 = e.srcElement||e.target;
	if(obj0.tagName!="SELECT" && obj0.tagName!="INPUT" && obj0.tagName!="TEXTAREA" ) return;

	//处理onchange
	var curItemName0 = obj0.name;
	var iBegin0,iEnd0,iField0,iRec0;
	obj0 = objp.document.forms[0].elements[curItemName0];
	iBegin0=curItemName0.indexOf("R");
	if(iBegin0!=-1 ){
		iEnd0=curItemName0.indexOf("F");
		iRec0=parseInt(curItemName0.substring(iBegin0+1,iEnd0));
		iField0=parseInt(curItemName0.substring(iEnd0+1));
		if( obj0.value != amarMoney(amarsoft2Real(DZ[myi0][2][my_index[myi0][iRec0]][iField0]),DZ[myi0][1][iField0][12]) ){
			myLastCB(myframename,curItemName0);
			//DZ[myi0][2][my_index[myi0][iRec0]][iField0] = real2Amarsoft(amarValue(obj0.value,DZ[myi0][1][iField0][12]));
			hC(obj0,myframename);
			obj0.value = amarMoney(amarsoft2Real(DZ[myi0][2][my_index[myi0][iRec0]][iField0]),DZ[myi0][1][iField0][12]);
			if(obj0.onchange!=null){
				try {
					obj0.amar_onchange();
				} catch(e) {  }
			}
		}
	}
	
	doKeyDown(myframename);
	afterKeyDown(myframename);
}


function kU(e, myframename){
	if(!beforeKeyUp(myframename)) return;
	if(myHandleSpecialKey(e, myframename)) return;
	
	var objp = window.frames[myframename];
	e = e || objp.event;
	if( e.keyCode==122 && e.shiftKey  && e.ctrlKey && e.altKey ){
		objp.document.body.oncontextmenu = 'self.event.returnValue=true';
		return;
	}
	if(e.keyCode==114 || e.keyCode==122 || (e.keyCode==78 && e.ctrlKey)){
		e.keyCode=0; 	
		e.returnValue=false; 	
	    return false;	
	}	
	if(e.keyCode==113){	 //F2:save
		AsSaveResult("myform"+myframename.substring(myframename.length-1));	
		return;	
	}	
	
	if( e.keyCode==123 && e.shiftKey  && e.ctrlKey && e.altKey ){
		alert("Welcome!  This is Amarsoft@DataWindow!  Copyright (C) 1998-2012 Amarsoft Corporation!  All rights reserved!");
		return;
	}

	if(e.keyCode==keyF7){ 	 //keyF7==117:F7:is show_select_button
		var myitem;
		for(var i=0;i<objp.document.forms[0].elements.length;i++){
			myitem = objp.document.forms[0].elements[i];
			if(myitem.name.substring(0,4)=="btnR")	
				if(myitem.style.display == "none")
					myitem.style.display = "Inline";
				else
					myitem.style.display = "none";
		}					
	}

	var myi=myframename.substring(myframename.length-1);
	var obj = e.srcElement||e.target;
	var iBegin,iEnd,iField,iRec,sName;
	try {
		iBegin=obj.name.indexOf("R");
		iEnd=obj.name.indexOf("F");
		iRec=parseInt(obj.name.substring(iBegin+1,iEnd));
		iField=parseInt(obj.name.substring(iEnd+1));
		
		if(cur_frame=="") cur_frame=myframename;
		if(iBegin!=-1) cur_sel_item[myi]=obj.name;
	}catch(e) {
		if(obj.prop == null || obj.name==null) {
			if(cur_sel_rec[myi]!=-1) {
				for(i=0;i<f_c[myi];i++) 
					if(DZ[myi][1][i][2]==1) break; 			
				sName="R"+cur_sel_rec[myi]+"F"+i;
				try {
		  		if(!objp.document.forms[0].elements[sName].disabled) 
		  			objp.document.forms[0].elements[sName].focus();
		  		} catch(e) { }
	  		}
	  		return;
		}
		else	return;
	}
	
	if(obj.tagName=="TEXTAREA"){
		myLastCB(myframename,obj.name);  
		iCurRow=iRec; 
		iCurCol=iField; 
		return;
	}
	
	if(iBegin==-1) return;
	
//	var kkk1=0,kkk2=0; 
   	if(e.keyCode==38){ //上移键
   		return;
		/*if(DZ[myi][0][0]==2) return;
   		if(iRec==curpage[myi]*pagesize[myi])
			kkk1=1;//alert("已经到了记录头或本页头！");
		else		
			if(iRec>curpage[myi]*pagesize[myi] && iRec<(curpage[myi]+1)*pagesize[myi] && iRec<rr_c[myi]) { 
				iRec--;
			  	sName = "R" + iRec + "F"+ iField;
			  	try {
				  	if(!objp.document.forms[0].elements[sName].disabled) 
				  		objp.document.forms[0].elements[sName].focus();
					sR(cur_sel_rec[myi],iRec,myframename);
			  		if(!objp.document.forms[0].elements[sName].disabled) 
			  			objp.document.forms[0].elements[sName].focus();
		  		} catch(e) { }
			}*/
   	}else if(e.keyCode==40){ //下移键
   		return;
		/*if(DZ[myi][0][0]==2) return;
   		var i;
   		for(i=0;i<my_index[myi].length;i++) if(my_index[myi][i]==-1) break;		
   		if(iRec==((curpage[myi]+1)*pagesize[myi]-1) || iRec==(rr_c[myi]-1) )
			kkk2=1;//alert("已经到了记录尾或本页尾！");
		else		
			if(iRec>=curpage[myi]*pagesize[myi] && iRec<(curpage[myi]+1)*pagesize[myi] && iRec<(rr_c[myi]-1)){ 
	   			iRec++;
			  	sName = "R" + iRec + "F"+ iField;
			  	try {
			  	if(!objp.document.forms[0].elements[sName].disabled) 
			  		objp.document.forms[0].elements[sName].focus();
			  	} catch(e) {  }
			  	sR(cur_sel_rec[myi],iRec,myframename);
			}*/
   	}else if(e.keyCode==13){
   		if(obj.tagName!="TEXTAREA"){
			myLastCB(myframename,obj.name);  		
   			myTabNext(myframename,iRec,obj.name);
   			obj.value = amarMoney(amarsoft2Real(DZ[myi][2][my_index[myi][iRec]][iField]),DZ[myi][1][iField][12]);   			
   		}   
   	}else if(e.keyCode==9){
		myLastCB(myframename,obj.name);  
  		sR(cur_sel_rec[myi],iRec,myframename);
   	}		
   	iCurRow=iRec; iCurCol=iField;		
 
	doKeyUp(myframename);
	afterKeyUp(myframename);  
}
	
function hC(obj,objpname){
	if(!obj.name) return; // 单选框、复选框通过隐藏表单处理 --或判断为数字!isNaN(obj.length)
	if(!beforeHC(obj,objpname)) return;
	var myi=objpname.substring(objpname.length-1);
	if(DZ[myi][0][2]==1) {
		return;
	}
	var iBegin,iEnd,iField,iRec;
	iBegin=obj.name.indexOf("R");
	iEnd=obj.name.indexOf("F");
	iRec=parseInt(obj.name.substring(iBegin+1,iEnd));
	iField=parseInt(obj.name.substring(iEnd+1));
	var mya=my_attribute[myi][my_index[myi][iRec]];
	
	if(mya==0||mya==3)
		my_changedoldvalues[myi][my_index[myi][iRec]][iField]=DZ[myi][2][my_index[myi][iRec]][iField];
	if(mya==1||mya==5){
		if(my_change[myi][my_index[myi][iRec]][iField]==0)
			my_changedoldvalues[myi][my_index[myi][iRec]][iField]=DZ[myi][2][my_index[myi][iRec]][iField];
	}			
	DZ[myi][2][my_index[myi][iRec]][iField]=real2Amarsoft(amarValue(obj.value,DZ[myi][1][iField][12]));
	if(""+DZ[myi][2][my_index[myi][iRec]][iField] != ""+real2Amarsoft(amarValue(""+my_changedoldvalues[myi][my_index[myi][iRec]][iField],DZ[myi][1][iField][12])))
		my_change[myi][my_index[myi][iRec]][iField]=1;
	
	if(mya==0){ 
		my_attribute[myi][my_index[myi][iRec]]=1;
	}else if(mya==3){ 
		my_attribute[myi][my_index[myi][iRec]]=5;
	}else if(mya==4){ 
		my_attribute[myi][my_index[myi][iRec]]=6;
	}
	mya=my_attribute[myi][my_index[myi][iRec]];
}

function hC_noUI(iDW,iRow,iCol,sValue){
	var myi=iDW;
	iRec=iRow;
	iField=iCol;
	var mya=my_attribute[myi][my_index[myi][iRec]];
	
	if(mya==0||mya==3)
		my_changedoldvalues[myi][my_index[myi][iRec]][iField]=DZ[myi][2][my_index[myi][iRec]][iField];
	if(mya==1||mya==5){
		if(my_change[myi][my_index[myi][iRec]][iField]==0)
			my_changedoldvalues[myi][my_index[myi][iRec]][iField]=DZ[myi][2][my_index[myi][iRec]][iField];
	}			
	DZ[myi][2][my_index[myi][iRec]][iField]=real2Amarsoft(sValue);
	if(""+DZ[myi][2][my_index[myi][iRec]][iField] != ""+real2Amarsoft(my_changedoldvalues[myi][my_index[myi][iRec]][iField],DZ[myi][1][iField][12]))
		my_change[myi][my_index[myi][iRec]][iField]=1;
	
	if(mya==0){ 
		my_attribute[myi][my_index[myi][iRec]]=1;
	}else if(mya==3){ 
		my_attribute[myi][my_index[myi][iRec]]=5;
	}else if(mya==4){ 
		my_attribute[myi][my_index[myi][iRec]]=6;
	}
	mya=my_attribute[myi][my_index[myi][iRec]];
}







function vI(obj,objpname){		
	if(!beforeVI(obj,objpname)) return;
	var myi=objpname.substring(objpname.length-1);
	var iBegin,iEnd,iField,iRec;
	iBegin=obj.name.indexOf("R");
	iEnd=obj.name.indexOf("F");
	iRec=parseInt(obj.name.substring(iBegin+1,iEnd));
	iField=parseInt(obj.name.substring(iEnd+1));
	if( (obj.value==null||obj.value==""||typeof(obj.value)=='undefined') && my_notnull[myi][iField]==1 ){
		showTipMsg(objpname,obj.name," '"+DZ[myi][1][iField][0]+"'不能为空！");
		return false;
	}
	if( obj.value==null||obj.value==""||typeof(obj.value)=='undefined' )
		return true;
	switch(DZ[myi][1][iField][12]){
		case 1:
			break;
		case 2: 
			if(isNaN(obj.value.replace(/,/g, ""))) {
				showTipMsg(objpname,obj.name,"["+DZ[myi][1][iField][0]+"]应为数字！");
				return false;
			}
			break;
		case 3: 
			if(!isASDate(obj.value,"/")) {
				showTipMsg(objpname,obj.name,"["+DZ[myi][1][iField][0]+"]应为合适的日期(yyyy/mm/dd)！");
				return false;
			}
			break;
		case 4: 
			break;
		case 5: 
			if(isNaN(obj.value.replace(/,/g, ""))) {
				showTipMsg(objpname,obj.name,"["+DZ[myi][1][iField][0]+"]应为数字！");
				return false;
			}
			break;
	}
	obj.value = amarMoney(amarsoft2Real(DZ[myi][2][my_index[myi][iRec]][iField]),DZ[myi][1][iField][12]);
	return true;
}





function as_add(objname){
	if(!beforeAsAdd(objname)) return;
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	cur_frame = objname; 
	
	var myobj=window.frames[objname];
	var myi=objname.substring(objname.length-1);
	if(DZ[myi][0][2]==1) {
		alert("此数据不可做新增操作！");
		return;
	}
	
	var iTemp;
	DZ[myi][2][rr_c[myi]]=new Array();
	my_changedoldvalues[myi][rr_c[myi]]=new Array();
	my_change[myi][rr_c[myi]]=new Array();
	for(iTemp=0;iTemp<f_c[myi];iTemp++){
		DZ[myi][2][rr_c[myi]][iTemp]=DZ[myi][1][iTemp][9];
		if(DZ[myi][1][iTemp][9]!="")
			my_change[myi][rr_c[myi]][iTemp]=1; 
		else
			my_change[myi][rr_c[myi]][iTemp]=0; 
	}
	my_attribute[myi][rr_c[myi]]=2;			
	r_c[myi] = r_c[myi] + 1;		
	rr_c[myi] = rr_c[myi] + 1;
	pagenum[myi]=Math.ceil(rr_c[myi]/pagesize[myi]); 
	if(cur_sel_rec[myi]==-1) {
		cur_sel_rec[myi] = rr_c[myi]-2;
		my_index[myi][rr_c[myi]-1]=rr_c[myi]-1;
	}else{
		var jj;
		for(jj=rr_c[myi]-2;jj>=cur_sel_rec[myi]+1;jj--)
			my_index[myi][jj+1]=my_index[myi][jj]; 
		my_index[myi][cur_sel_rec[myi]+1]=rr_c[myi]-1;
	}
	var oldrec = cur_sel_rec[myi]+1;                
	needReComputeIndex[myi]=0;		
	sort_end[myi]=rr_c[myi]-1;
	if(DZ[myi][0][0]==2) curpage[myi]=rr_c[myi]-1; 
	if(DZ[myi][0][0]==1){
		cur_sel_rec[myi] = oldrec;	                
		myobj.document.forms[0].elements["txtJump"].value=parseInt(cur_sel_rec[myi]/pagesize[myi])+1; 
		MR1(objname,5,cur_sortorder[myi],cur_sortfield[myi]);
		cur_sel_rec[myi] = oldrec;	  
		for(var i=0;i<f_c[myi];i++) 
			if(DZ[myi][1][i][2]==1) break; 			
		sR(-1,cur_sel_rec[myi],objname);   
		
		var i1=0,ii=0;
		for(i1=0;i1<rr_c[myi];i1++) {
			var realRow = my_index[myi][i1];
			if(my_attribute[myi][realRow]<3) continue;
			for(ii=0;ii<f_c[myi];ii++) {
				if(DZ[myi][1][ii][2]==1) {
					var sFName="R"+i1+"F"+ii;
					window.frames[objname].document.all(sFName).style.cssText += ";text-decoration: line-through ";					
				}
			}
		}

		
	}else{
		cur_sel_rec[myi] = oldrec;	                
		MR2_add(objname,5);//MR2(objname,5);
		cur_sel_rec[myi] = oldrec;	  
		for(i=0;i<f_c[myi];i++) 
			if(DZ[myi][1][i][2]==1) break; 			
	}
	needReComputeIndex[myi]=1;
	iCurRow = cur_sel_rec[myi];
}





function as_del(objname){
	if(!beforeAsDel(objname)) return;
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	
	var myi=objname.substring(objname.length-1);
	if(cur_sel_rec[myi]==-1) {
		alert("请先选择一条记录！");
		return;
	}
	var i=my_attribute[myi][my_index[myi][cur_sel_rec[myi]]];
	if(i==3||i==4||i==5||i==6)
		return;
	if(i==0 ||i==1)
		my_attribute[myi][my_index[myi][cur_sel_rec[myi]]]=3;
	else if(i==2)
		my_attribute[myi][my_index[myi][cur_sel_rec[myi]]]=4;
	
	if( DZ[myi][0][0]==1) {
		var ii,sName;
		window.frames[objname].document.getElementById("R"+cur_sel_rec[myi]+"FZ").innerText += "(*)";
		for(ii=0;ii<f_c[myi];ii++){
			sName="TDR"+cur_sel_rec[myi]+"F"+ii;
			if(DZ[myi][1][ii][2]==1)   {
				//window.frames[objname].document.getElementById(sName).style.cssText = 
				//	f_css[myi][ii]+";border-style:none;border-width:thin;background-color:#999999;color:#AAAAAA";
				var sFName="R"+cur_sel_rec[myi]+"F"+ii;
				window.frames[objname].document.all(sFName).style.cssText += ";text-decoration: line-through ";
			}
		}
	}
}


function showTips(sCol,msg,className){
	showTip("myiframe0", sCol, msg, className);
}








function showTip(myiframe, sCol, msg, className){
	var myIndex = myiframe.substring(8);
	var colIndex = getColIndex(myIndex, sCol);
	if(colIndex==-1) {//字段不对应，直接给出消息
		alert(msg);
		return;
	}
	var sName = "R0F"+colIndex;
	showTipMsg(myiframe, sName, msg, className);
}

function showTipMsg(myiframe,sName,msg,className){
	var msgLabel = window.frames[myiframe].document.getElementById(sName + "_label");
	if(!msgLabel){
		alert(msg);
		return;
	}
	if(typeof(className)=="undefined"||className=='') msgLabel.className = "error";
	else msgLabel.className = className;
	msgLabel.innerHTML = msg;
}

function toNumber(value){
	if(typeof(value)=="number")
		return value;
	else
		return parseFloat(value.replace(/,/g,''));
}
function isNumber(value){
	if(value==undefined)
		return false;
	if(value.indexOf("/")>-1)
		return false;
	if(isNaN(value)==false)
		return true;
	else{
		if(isNaN(toNumber(value))==false)
			return true;
		else
			return false;
	}
}





function vI_all(objpname){
	if(!beforeVIAll(objpname)) return false;
	if(SAVE_TMP)return true;
	if(_user_validator.length>1){
		if($("#form1",frames[objpname].document).validate(_user_validator[1])==undefined)return true;
		//alert($("#form1",frames[objpname].document).validate(_user_validator[1]).form);
		var validator = $("#form1",frames[objpname].document).validate(_user_validator[1]); 
		var result =  validator.form();
		//alert("result="+result);
		if(result==false){
			var errorList = validator.errorList;
			if(errorList.length>0){
				var error = errorList[0].element;
				if(frames[objpname].document.getElementById(error.id))
					try{frames[objpname].document.getElementById(error.id).focus();}catch(e){}
			}
		}
		return result;
	}
	else{//list模式
		var tableIndex = 0;
		var form;
		if(!document.getElementById("listvalid0")){
			var formobj = document.createElement("form");
			formobj.setAttribute("id","listvalid0");
			document.body.appendChild(formobj);
		}
		//alert(document.getElementById("listvalid0"));
		form = $("#listvalid" +tableIndex );
		//alert(form);
		var element = document.createElement("input");//document.getElementById("element_listvalid" + tableIndex);
		element.setAttribute("type","hidden");
		//alert("element="+element);
		var errmsgs = new Array();
		//alert(_user_validator[0]);
		var rules = _user_validator[0].rules;
		//alert("rules="+ rules);
		var firstErrorID = "";
		for(sColName in rules){//sColName为字段名
			var colValidators = rules[sColName];
			//alert("colValidators="+ colValidators);
			for(method in colValidators){
				var iColIndex = getColIndexIngoreCase(tableIndex,sColName);
				if(iColIndex==-1)continue;
				//alert("iColIndex=" + iColIndex);
				
				rule = { method: method, parameters: colValidators[method] };
				//alert(rule.method);
				//逐行获得数据值
				var iDataSize = DZ[tableIndex][2].length;
				for(var i=0;i<iDataSize;i++){
					element.setAttribute("errorInfo",undefined);
					
					var sColValue = getItemValueByIndex(tableIndex,i,iColIndex);//获得字段值
					//alert("sColValue="+ sColValue);
					if(typeof(sColValue)=='string')
					sColValue = sColValue.replace(/\r/g, "");
					element.name = getColName(tableIndex,iColIndex);
					element.value = sColValue;
					var bValid = false;
					bValid = jQuery.validator.methods[method].call( form.validate(), sColValue, element, rule.parameters,i );
					if(bValid==false){
						//bResult = false;
						if(!firstErrorID){
							firstErrorID = "R"+i+"F"+iColIndex;
							//高亮选择行
							sR(cur_sel_rec[tableIndex], i, objpname);
							iCurRow=i;
						}
						var title = DZ[tableIndex][1][iColIndex][0];
						//alert(element.getAttribute("errorInfo"));
						if(element.getAttribute("errorInfo")==undefined || element.getAttribute("errorInfo")=='undefined')
							errmsgs[errmsgs.length]=title + ":" + _user_validator[0].messages[sColName.toUpperCase()][method] + (_user_validator.length>1?"":"[第" + (i+1) +"行]");
						else
							errmsgs[errmsgs.length]=title + ":" + element.getAttribute("errorInfo") + (_user_validator.length>1?"":"[第" + (i+1) +"行]");
					}
				}
			}
		}
		if(errmsgs.length>0){
			try{frames[objpname].document.getElementsByName(firstErrorID)[0].focus();}catch(e){}
			alert(errmsgs.join('\n'));
			return false;
		}
		else
			return true;
	}
	
	/*
	if(cur_frame=="") //for cur_frame may be ""
		cur_frame=objpname;
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);

	var myi=objpname.substring(objpname.length-1);
	var sName;
	var passFlag = true;
	for(var j=0;j<rr_c[myi];j++){
		for(var i=0;i<f_c[myi];i++){
			
			//clear label
			var msgLabel = window.frames[objpname].document.getElementById("R"+j+"F"+i + "_label");
			if(typeof(msgLabel)!="undefined"&&msgLabel!=null){
				msgLabel.className = "";
				msgLabel.innerHTML = "";
			}
			
			var myValue;
			myValue = DZ[myi][2][my_index[myi][j]][i];
			//first check notnull(required), and pk 也归为 notnull	
			if(my_notnull[myi][i]==1 && (myValue==null||myValue==""||typeof(myValue)=='undefined') ){
				//for szcb_num_0_and num is space so kick				  
				if(myValue=="")   
					if( ("HXD"+myValue)!="HXD") continue;   
				showTipMsg(objpname,"R"+j+"F"+i," '"+DZ[myi][1][i][0]+"'不能为空！");
				passFlag = false;
			}
			if( myValue==null||myValue==""||typeof(myValue)=='undefined' ) 
				continue;
			switch(DZ[myi][1][i][12]){
				case 1:
				case 4:
					break;
				case 2: 
				case 5: 
				case 11: 
				case 12: 
				case 13: 
				case 14: 
				case 15: 
				case 16: 
				case 17: 
				case 18: 
				case 19: 
				case 20: 
					if(isNaN(myValue)){
						showTipMsg(objpname,"R"+j+"F"+i,"["+DZ[myi][1][i][0]+"]应为数字！");
						passFlag = false;
					}
					break;
				case 3: 
					if(!isASDate(myValue,"/")){
						showTipMsg(objpname,"R"+j+"F"+i,"["+DZ[myi][1][i][0]+"]应为合适的日期(yyyy/mm/dd)！");
						passFlag = false;
					}
					break;
				case 6: 
				case 7: 
				case 8: 
				case 9: 
					if(!check6789(DZ[myi][1][i][12],myValue)) passFlag = false;
					break;
			}
		}
	}
	
	return passFlag;
	*/
}

function as_save_return(my_success,myIndex,msg,sAfterAction){
	var obj;
	/* if(typeof(window.opener)=='undefined')
		obj=window.parent;      
	else
		obj=window.opener.top;   */
	obj=window;
	
	if(my_success==1){
		var myi=myIndex;
		var i,j,k;
		var my_a=new Array();
		for(i=0;i<obj.my_index[myi].length;i++) 
			my_a[i] = obj.my_attribute[myi][obj.my_index[myi][i]];
		for(i=0;i<obj.my_index[myi].length;i++){
			if(obj.my_index[myi][i]==-1) break; 
			obj.my_attribute[myi][i]=0;
			for(j=0;j<obj.my_change[myi][i].length;j++){
				obj.my_change[myi][i][j]=0;
				obj.my_changedoldvalues[myi][i][j]="";
			}
		}
		var my_newindex=new Array();
		for(i=0,j=0,k=0;i<my_a.length;i++){
			if(my_a[i]==0 || my_a[i]==1 || my_a[i]==2)
				my_newindex[j++]=obj.my_index[myi][i];
			else
				k++;	
		}
		obj.sort_end[myi]=obj.sort_end[myi]-k; 
		
		for(i=0;i<my_newindex.length;i++)
			obj.my_index[myi][i]=my_newindex[i];	
		for(i=my_newindex.length;i<obj.my_index[myi].length;i++)
			obj.my_index[myi][i]=-1;		
			
		obj.rr_c[myi]=my_newindex.length;
		obj.r_c[myi]=my_newindex.length;
		obj.curpage[myi]=0;	
		obj.cur_sel_item[myi]=""; //add in 2009/11/05 for del reload
		obj.cur_sel_rec[myi]=-1;
		setNeedCheckRequired(myi);//将必输项设置回来	add 20120114 页面不需调用该函数了
		obj.my_load(2,0,"myiframe"+myi);
		//add by hxd in 2004/11/02 for turn page
		if(obj.iCurRow>=obj.rr_c[myi]) obj.iCurRow--; //for delete 
		if(obj.DZ[myi][0][0]==1) obj.iCurRow=-1; //add 05/01/29 hxd
		
		//move to below in 2008/04/10
		//if(obj.bSavePrompt) 
		//	alert("数据保存成功！");
		//obj.sSaveReturn = "1@数据保存成功！"; 
		
		//var sAfterAction = "<%=sAfterAction%>";
		if(sAfterAction!=""){
			//后续处理并关闭(关闭在后续处理的页面中使用self.close)
			//obj.OpenPage(sAfterAction,"_self",""); //window.open
			try{
				if(navigator.appName!='Netscape'){
					eval("obj."+sAfterAction);
				}
				obj.hideMessage(); 	
				if(obj.bSavePrompt) showMess("数据保存成功！"); 
				if(navigator.appName=='Netscape'){
					my_success=2;
					eval("obj."+sAfterAction);
				}
			}catch(e){
				obj.hideMessage(); 	
				ShowMessage("错误："+e.name+" "+e.number+" :"+e.message+"\n\n后续动作定义错误！\n\n示例1：\n\n as_save(\"myiframe0\",\"location.reload();\") \n\n示例2：\n\n as_save(\"myiframe0\",\"alert('abc');\")",true,true);
			}
		}else{
			//add by hxd in 2008/04/10
			obj.hideMessage(); 	
			if(obj.bSavePrompt) showMess("数据保存成功！"); 
		}
				
		my_success=2;	
		//self.close();  
	}else if(my_success==0){
		obj.hideMessage(); 	

		if(obj.bSavePrompt) 
			ShowMessage("数据保存失败！错误原因是："+msg,true,true);
		obj.sSaveReturn = "-2@数据保存失败@"+msg;   //amardw中:-1@数据输入不未通过检查	
		//self.close();  
	}

	//add by hxd in 2008/04/10
	try{
		obj.document.frames["myiframe0"].document.body.oncontextmenu='self.event.returnValue=true';
	}catch(e){}
}









function as_save(objname,afteraction,aftertarget,afterprop){
	if(!isNaN(objname))objname = "myiframe" + objname;
	if(!beforeAsSave(objname,afteraction,aftertarget,afterprop)) return;
	var objdoit=window.frames[objname].document.getElementById('doit'); 
	var sSignature="",sModulus=""; 
	if(bNeedCA) {
		str = objdoit.KLSign("123"); 
		if (str == 0) { 
			sSignature = objdoit.KLGetSignature(); 
			sModulus = objdoit.KLGetModulus(); 
		} else if (str == -232232) { 
			sSaveReturn = "-1@签名表单数据为空"; 
			return sSaveReturn; 
		} else if (str == -232233) { 
			sSaveReturn = "-1@超级用户口令登陆失败"; 
			return sSaveReturn; 
		} else { 
			sSaveReturn = "-1@其它内部错误."; 
			return sSaveReturn; 
		} 
	} 
	
	var sAfterAction = "";  
	var sAfterTarget = "";  
	var sAfterProp = "";  
	if(arguments.length>=2) { sAfterAction = afteraction;	sAfterTarget="_blank2";  sAfterProp="top=1800,left=1600,width=0,height=0"; }  
	if(arguments.length>=3) { sAfterTarget = aftertarget;	sAfterProp="top=1800,left=1600,width=0,height=0"; } 
	if(arguments.length>=4) { sAfterProp   = afterprop;	} 

	if(cur_frame=="") //for cur_frame may be ""
		cur_frame=objname;
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	
	var myi=objname.substring(objname.length-1);
	
	if(!vI_all(objname)) {sSaveReturn="-1@数据输入未通过检查";  return sSaveReturn;} 
	
	//for post...err(weblogic)...gb2312 to unicode...........asConvU2G
//	myform999.document.clear();	
	myform999.document.close();
	myform999.document.write("正在保存数据，请稍等......");
	myform999.document.write("<table border=1 cellpadding=0 cellspacing=0 align='center' class='thistable' style='display:none'>");
	myform999.document.write("  <form id='form1' name='form1'>");
	if(bNeedCA){ 
	    myform999.document.write("  <input type='text' name='bNeedCA' value='Yes' >                       ");
	    myform999.document.write("  签名信息： <textarea name=Signature>" + asConvU2G(sSignature) + "</textarea>   ");
	    myform999.document.write("  证书模信息:<textarea name=Modulus>"   + asConvU2G(sModulus) +  "</textarea>    ");
	}else 
	    myform999.document.write("  <input type='text' name='bNeedCA' value='No' >                       ");
	myform999.document.write("  <input type='text' name='myIndex' checked value="+asConvU2G(myi)+">");
	myform999.document.write("  <input type='text' name='SessionID' checked value="+asConvU2G(DZ[myi][0][1])+">");
	myform999.document.write("  <input type='text' name='afteraction' value="+asConvU2G(sAfterAction)+" >");
	myform999.document.write("  <input type='text' name='aftertarget' value='"+asConvU2G(sAfterTarget)+"' >");
	myform999.document.write("  <input type='text' name='afterprop' value='"+asConvU2G(sAfterProp)+"' >");
	myform999.document.write("  <tbody>");
	var i,j;
	var cflag = 0;
	for(j=0;j<rr_c[myi];j++){
		myform999.document.write("<tr><td>");
		switch(my_attribute[myi][my_index[myi][j]]){
			case 0: 
				break;
			case 1: 
				for(i=0;i<f_c[myi];i++){
				    if(DZ[myi][1][i][18]=="1"){
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".1.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".1.1' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
				        continue; 
				    }
					if(my_change[myi][my_index[myi][j]][i]==1){
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".1.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".1.1' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
					}else{
						if(DZ[myi][1][i][1]==1 || DZ[myi][1][i][5]==1) 
							myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".1.0' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
					}
				}
				break;
			case 2: 
				for(i=0;i<f_c[myi];i++){
				    if(DZ[myi][1][i][18]=="1"){
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".2.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".2.1' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
				        continue; 
				    }
					if(my_change[myi][my_index[myi][j]][i]==1 && DZ[myi][1][i][5]==1) 
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".2.1' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
				}
				break;
			case 3: 
				cflag = 3;
				for(i=0;i<f_c[myi];i++){
				    if(DZ[myi][1][i][18]=="1"){
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".3.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".3.1' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
				        continue; 
				    }
					if(my_change[myi][my_index[myi][j]][i]==1){
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".3.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
					}else{
						if(DZ[myi][1][i][1]==1 || DZ[myi][1][i][5]==1) 
							myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".3.0' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
					}
				}
				break;
			case 4: 
				break;
			case 5: 
				cflag = 5;
				for(i=0;i<f_c[myi];i++){
				    if(DZ[myi][1][i][18]=="1"){
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".5.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".5.1' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
				        continue; 
				    }
					if(my_change[myi][my_index[myi][j]][i]==1)						
						myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".5.0' checked value='"+asConvU2G(my_changedoldvalues[myi][my_index[myi][j]][i])+"' >");
					else{
						if(DZ[myi][1][i][1]==1 || DZ[myi][1][i][5]==1) 
							myform999.document.write("<input type='text' name='"+my_index[myi][j]+"."+i+".5.0' checked value='"+asConvU2G(DZ[myi][2][my_index[myi][j]][i])+"' >");
					}
				}
				break;
			case 6: 
				break;
		}				
		myform999.document.write("</td></tr>");
	}
	myform999.document.write("  </form>");
	myform999.document.write("  </tbody>");
	myform999.document.write("</TABLE>");
	
	$.ajax({
		   type: "POST",
		   url: sWebRootPath+"/Frame/page/dw/datawindow_save_ajax.jsp",
		   processData: false,
		   async:false,
		   data:$("#form1",myform999.document).serialize(),
		   success: function(msg){
			   try{
				   var result = eval("(" + msg + ")");
				   if(result.success){
					   as_save_return(result.success,result.index,result.message,afteraction);		   
					   if(cflag==3||cflag==5){
						   reloadSelf();//删除操作成功后刷新页面取总条数和分页信息
					   }	
				   }else{
					   alert(result.message);
					   window.hideMessage();
				   }
				   			   
			   }catch(e){
				   ShowMessage('保存出错了!',true,true);
			   }
		   }
		});
	//reloadself();//分页和总条数刷新
 	
 	return sSaveReturn; 
}

//转码方式调整
function asConvU2G(sSrc){
	if(sSrc==null) return sSrc;
	return encodeURI(sSrc);		  
}  

//从MR1_s 和my_load_show_action_s 提取出公共部分
function getDWData(myobjname,myact,event){
	var myobj=window.frames[myobjname];
 	var curPP = 0;
 	if(myact==5){
 		event = event || myobj.event;
 	   	if(event && event.keyCode==13){
 			if(isNaN(myobj.document.forms[0].elements["txtJump_s"].value)){
 				alert("输入内容必须为数字！"); 
 				return; 
 			}else 
 				curPP=myobj.document.forms[0].elements["txtJump_s"].value;	 
 		}else 
 			return; 
 	}
	var myi=myobjname.substring(myobjname.length-1); 
 	switch(myact){
 		case 1: 
 			s_c_p[myi]=0; 
 			break; 
 		case 2: 
 			if(s_c_p[myi]>0) s_c_p[myi]--; 
 			break; 
 		case 3: 
 			if(s_c_p[myi]<s_p_c[myi]-1) s_c_p[myi]++; 
 			break; 
 		case 4: 
 			s_c_p[myi]=s_p_c[myi]-1; 
 			break;
 		case 5: 
 			s_c_p[myi]=curPP-1;
 			if(s_c_p[myi]<0) s_c_p[myi]=0;
 			if(s_c_p[myi]>s_p_c[myi]-1) s_c_p[myi]=s_p_c[myi]-1;
 			break;
 	}
 	 
 	var myoldstatus = window.status;
 	window.status="正在从服务器获得数据，请稍候....";
 	var sPageURL = sWebRootPath+"/Frame/page/dw/GetDWData.jsp?dw="+DZ[myi][0][1]+"&pg="+s_c_p[myi];
	var script = $.ajax({url: sPageURL,async: false}).responseText.trim();
	script = replaceAll(replaceAll(script, "<script type=\"text/javascript\">", ""), "</script>", "");
	eval(script);
 	window.status=myoldstatus; 
 	
 	init(false);
 	return "s";
}
function MR1_s(myobjname,myact,my_sortorder,sort_which,need_change, event){
	if(!beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change)) return;

 	s = getDWData(myobjname,myact, event);
 	if(typeof(s)!="undefined") my_load(2,0,myobjname);
} 

function my_load_show_action_s(myobjname,myact,my_sortorder,sort_which,event){
	if(!before_my_load_show_action_s(myobjname,myact,my_sortorder,sort_which)) return;
 
 	if(!isValid()) return;
  
 	s = getDWData(myobjname,myact,event);
 	if(typeof(s)!="undefined") my_load_show(2,0,myobjname);	
 	myUpdateTotalSum(myobjname);
}

function myUpdateTotalSum(myobjname){
	try {
		var myi = myobjname.substring(myobjname.length-1);
//		var mycss = frames(myobjname).document.styleSheets[0].href; 
//		if(DZ[myi][0][4]==1 && mycss.indexOf("style_rp.css")>0 ){ //my_load_show:ShowSummary  && style_rp.css
		if(DZ[myi][0][4]==1){ //my_load_show:ShowSummary
			var mytjTable = frames(myobjname).document.body.getElementsByTagName("TABLE")[0];
			var mytjRow = mytjTable.rows[mytjTable.rows.length-1];
			var mytjCells = mytjRow.cells;

			var i = 0, iColShow = 0;
			for(i=0;i<f_c[myi];i++){
				if(DZ[myi][1][i][2]==0) continue; 
				iColShow ++;
				if(DZ[myi][1][i][14]==2)
					mytjCells[iColShow].innerHTML = "&nbsp;"+amarMoney(DZ[myi][3][i],DZ[myi][1][i][12])+"&nbsp;";
			}
		}
	} 	catch(e) { }
}

function my_load_save(my_sortorder,sort_which,myobjname){
	if(!beforeMyLoadSave(my_sortorder,sort_which,myobjname)) return;

	if(!isValid()) return;

	var myoldstatus = window.status;  
	window.status="正在保存数据，请稍候....";  
	var myi=myobjname.substring(myobjname.length-1);   
	
	var i,j,mystr="";
	var mytjGroup=new Array(),mycntGroup=new Array(),myGroupLevel=0,ijk=0,myGroupIndex=new Array();
	for(i=0;i<f_c[myi];i++){
		if(DZ[myi][1][i][2]==0) continue; 
		if(myGroupLevel<DZ[myi][1][i][16]) myGroupLevel = DZ[myi][1][i][16];   
	}
	for(i=0;i<myGroupLevel;i++){
		myGroupIndex[i]=-1;
		mytjGroup[i]=new Array();
		mycntGroup[i]=new Array();
	}
	for(i=0;i<f_c[myi];i++){
		if(DZ[myi][1][i][2]==0) continue; 
		if(DZ[myi][1][i][16]>0 && myGroupIndex[DZ[myi][1][i][16]-1]==-1 ) myGroupIndex[DZ[myi][1][i][16]-1]=i;     
	}
	
	if(my_sortorder==1){
		myimgstr="<span class='sort_up' style='display:inline-block;'>&nbsp;</span>";
		my_sortorder=0;
	}else if(my_sortorder==0){
		myimgstr="<span class='sort_down' style='display:inline-block;'>&nbsp;</span>";
		my_sortorder=1;
	}else if(my_sortorder==2){
		mystr="&nbsp;";
		my_sortorder=0;
	}
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<html leftmargin='0' topmargin='0'>");
	sss[jjj++]=("<head>");
	sss[jjj++]=(sContentType);
	sss[jjj++]=("<style>");
	sss[jjj++]=(".inputstring {border-style:none;border-width:thin;border-color:#e9e9e9}");
	sss[jjj++]=(".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}");
	sss[jjj++]=(".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}");
	sss[jjj++]=(".inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}");
	sss[jjj++]=(".pt16songud{font-family: '黑体','宋体';font-size: 16pt;font-weight:bold;text-decoration: none}");
	sss[jjj++]=(".myfont{font-family: '黑体','宋体';font-size: 9pt;font-weight:bold;text-decoration: none}");
	sss[jjj++]=("</style>");
	sss[jjj++]=("</head>");
	sss[jjj++]=("<body bgcolor='#DEDFCE'>");
	sss[jjj++]=("<form name='form1'>");
	var myS=new Array("","readonly","disabled","readonly","","disabled","disabled","disabled"); 
	var myR=DZ[myi][0][2]; 
	var myFS,myValue; 
	var myAlign2=new Array("","left","center","right");
	var mytj=new Array();
	for(i=0;i<f_c[myi];i++){
		mytj[i]=0;
		for(ijk=0;ijk<myGroupLevel;ijk++){
			mytjGroup[ijk][i]=0;
			mycntGroup[ijk][i]=0;
		}
	}
	if(DZ[myi][0][0]==1) { 
		sss[jjj++]=("<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF>");
		sss[jjj++]=("<tbody>");
		sss[jjj++]=("<tr bgColor=#cccccc height=24>");		
		sss[jjj++]=("<td nowrap style='"+sHeaderStyle+"' noWrap align=middle>序号</td>");
		for(i=0;i<f_c[myi];i++) {
			if(DZ[myi][1][i][2]==0) continue; 
			if(DZ[myi][1][i][6]==1 && myGroupLevel==0) {
				if(sort_which==i) sss[jjj++]=("<td nowrap style='"+sHeaderStyle+"' onclick='parent.my_load_show("+my_sortorder+","+i+",\""+myobjname+"\")' noWrap align=middle >"+DZ[myi][1][i][0]+DZ[myi][1][i][17]+mystr+"</td>");
				else              sss[jjj++]=("<td nowrap style='"+sHeaderStyle+"' onclick='parent.my_load_show("+my_sortorder+","+i+",\""+myobjname+"\")' noWrap align=middle >"+DZ[myi][1][i][0]+DZ[myi][1][i][17]+"</td>");
			}
			else 		          sss[jjj++]=("<td nowrap style='"+sHeaderStyle+"' noWrap align=middle >"+DZ[myi][1][i][0]+DZ[myi][1][i][17]+"</td>");
		}
		sss[jjj++]=("</tr>");
		
		for(j=0;j<rr_c[myi];j++){
			if(j!=0 && myGroupLevel>0){
				for(ijk=0;ijk<myGroupLevel;ijk++){
					if( DZ[myi][2][my_index[myi][j]][myGroupIndex[ijk]] != DZ[myi][2][my_index[myi][j-1]][myGroupIndex[ijk]] ){
						sss[jjj++]=("<tr >");
						sss[jjj++] = "<td nowrap style='"+sSumTDStyle+" ' id=RR"+rr_c[myi]+"F0 align="+myAlign2[DZ[myi][1][0][8]]+" >&nbsp;</td>";
						for(i=0;i<f_c[myi];i++){
							if(DZ[myi][1][i][2]==0) continue; 
							if(DZ[myi][1][i][14]==2)       
								sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+amarMoney(mytjGroup[ijk][i],DZ[myi][1][i][12])+"</td>";
							else if(DZ[myi][1][i][14]==3)  
								sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+amarMoney(mytjGroup[ijk][i]/mycntGroup[ijk][i],DZ[myi][1][i][12])+"</td>";
							else if(DZ[myi][1][i][14]==4)  
								sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+mycntGroup[ijk][i]+"</td>";
							else{
								if(myGroupIndex[ijk]==i)
									sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"'>&nbsp;"+DZ[myi][2][my_index[myi][j-1]][myGroupIndex[ijk]]+"合计&nbsp;</td>";
								else
									sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"'>&nbsp;</td>";
							}
							
							mytjGroup[ijk][i] = 0;
							mycntGroup[ijk][i] = 0;
						}
						sss[jjj++]=("</tr>");			
					}
				}
			}
			
			sss[jjj++]=("<tr>");
			sss[jjj++]=("<td nowrap  style='"+sTDStyle+"' bgcolor=#E4E4E4 id='R"+j+"FZ' noWrap align=right width=14 ><font style='font-size:9pt'>"+(j+1)+"</font></td>");
			for(i=0;i<f_c[myi];i++){
				if(DZ[myi][1][i][2]==0) continue; 
				myFS = DZ[myi][1][i][11];  
				if(myR==1 || (myR==0&&(DZ[myi][1][i][3]==1)) )
					str2=myS[myFS];    
				else
					str2=" ";	
				if(DZ[myi][1][i][7]==0) str3=" ";			
				else                    str3=" maxlength="+DZ[myi][1][i][7];
				myValue = amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12]);
				if( myGroupLevel>0 && j!=0 && DZ[myi][1][i][16]>0 && DZ[myi][2][my_index[myi][j]][i]==DZ[myi][2][my_index[myi][j-1]][i] )
					myValue = " ";
					
				if(DZ[myi][1][i][8]>=1) 
					sss[jjj++] = "<td "+hmRPContentTD +" id=R"+j+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >&nbsp;"+getCodeTitle(DZ[myi][1][i][20],myValue)+"&nbsp;</td>";
				else
					sss[jjj++] = "<td "+hmRPContentTD +" id=R"+j+"F"+i+"  >&nbsp;"+getCodeTitle(DZ[myi][1][i][20],myValue)+"&nbsp;</td>";
					
				if(DZ[myi][1][i][14]!=1){
					mytj[i]+=DZ[myi][2][my_index[myi][j]][i];				
					for(ijk=0;ijk<myGroupLevel;ijk++){
						mytjGroup[ijk][i]+=DZ[myi][2][my_index[myi][j]][i];				
						mycntGroup[ijk][i]++;
					}
				}
			}
			sss[jjj++]=("</tr>");
		}
		
		if(j!=0 && myGroupLevel>0){
			for(ijk=0;ijk<myGroupLevel;ijk++){
				sss[jjj++]=("<tr>");
				sss[jjj++] = "<td nowrap style='"+sSumTDStyle+" ' id=RR"+rr_c[myi]+"F0 align="+myAlign2[DZ[myi][1][0][8]]+" >&nbsp;</td>";
				for(i=0;i<f_c[myi];i++){
					if(DZ[myi][1][i][2]==0) continue; 
					if(DZ[myi][1][i][14]==2)       
						sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+amarMoney(mytjGroup[ijk][i],DZ[myi][1][i][12])+"</td>";
					else if(DZ[myi][1][i][14]==3)  
						sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+amarMoney(mytjGroup[ijk][i]/mycntGroup[ijk][i],DZ[myi][1][i][12])+"</td>";
					else if(DZ[myi][1][i][14]==4)  
						sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+mycntGroup[ijk][i]+"</td>";
					else{
						if(myGroupIndex[ijk]==i)
							sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"'>&nbsp;"+DZ[myi][2][my_index[myi][j-1]][myGroupIndex[ijk]]+"合计&nbsp;</td>";
						else
							sss[jjj++] = "<td nowrap style='"+sSumTDStyle+"'>&nbsp;</td>";
					}
				}
				sss[jjj++]=("</tr>");			
			}
		}
		
		if(DZ[myi][0][4]==1){
			sss[jjj++]=("<tr>");
			sss[jjj++] = "<td nowrap style='"+sTDStyle+" ' id=R"+rr_c[myi]+"F0 align="+myAlign2[DZ[myi][1][0][8]]+" >&nbsp;合计&nbsp;</td>";
			for(i=0;i<f_c[myi];i++){
				if(DZ[myi][1][i][2]==0) continue; 
				if(DZ[myi][1][i][14]==2)               
					sss[jjj++] = "<td nowrap style='"+sTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+amarMoney(mytj[i],DZ[myi][1][i][12])+"</td>";
				else if(DZ[myi][1][i][14]==3)          
					sss[jjj++] = "<td nowrap style='"+sTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+amarMoney(mytj[i]/rr_c[myi],DZ[myi][1][i][12])+"</td>";
				else if(DZ[myi][1][i][14]==4)          
					sss[jjj++] = "<td nowrap style='"+sTDStyle+"' id=R"+rr_c[myi]+"F"+i+" align="+myAlign2[DZ[myi][1][i][8]]+" >"+rr_c[myi]+"</td>";
				else
					sss[jjj++] = "<td nowrap style='"+sTDStyle+"'></td>";
			}
			sss[jjj++]=("</tr>");			
		}
	}else{
	}
			
	sss[jjj++]=("</tbody>");
	sss[jjj++]=("</table>");
	sss[jjj++]=("</form>");
	sss[jjj++]=("</body>");
	sss[jjj++]=("</html>");
	window.status="Ready";  
	window.status=myoldstatus;  
	return(amarsoft2Html(sss.join('')));  
}

function AsSaveResult(myobjname){
	if(!beforeAsSaveResult(myobjname)) return;
	var myoldstatus = window.status;  
	var sFileName; 
	try { 
		if ( (sFileName=prompt("请输入文件名称(需要包含路径名,例如C:\\1.xls):", "c:\\1.xls")) ){ 
			window.status="正在保存数据，请稍候....";  
			var objname="myform"+myobjname.substring(myobjname.length-1);	
			var mysss = my_load_save(2,0,objname);
			var fso = new ActiveXObject("Scripting.FileSystemObject"); 
			var a = fso.CreateTextFile(sFileName, true); 
			a.WriteLine(mysss);
			a.Close();
			alert("保存成功！文件名为："+sFileName+"."); 
		}else
			alert("您没有输入正确的文件名！"); 
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message); 
	} 
	window.status="Ready";
	window.status=myoldstatus;
}

function over_change(index,src,clrOver){
	if (!src.contains(event.fromElement)){ 
 		src.style.cursor = 'pointer';
 		src.background = clrOver;
	}
}

function out_change(index,src,clrIn){
	if (!src.contains(event.toElement)){
		src.style.cursor = 'default';
		src.background = clrIn;
	}
}






function isModified(objname){
	if(!beforeIsModified(objname)) return;
	if(cur_frame=="") //for cur_frame may be ""
		cur_frame=objname;

	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	
	var myi=objname.substring(objname.length-1);
	var i,j,bModified=false;
	
	try {
		for(i=0;i<rr_c[myi];i++)
		    for(j=0;j<f_c[myi];j++)
				if(my_change[myi][i][j]!=0) {bModified=true;break;}
	} catch(e) {  }
	
	return bModified;
}

function AsMaxWindow(){
	window.moveTo(0,0);
	if (document.all) { 
  		top.window.resizeTo(screen.availWidth,screen.availHeight); 
	} else if (document.layers||document.getElementById) { 
  		if (top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth) { 
    		top.window.outerHeight = screen.availHeight; 
    		top.window.outerWidth = screen.availWidth; 
  		} 
	} 
} 
 
function getASObjectByIndex(iDW,iRow,iCol){
	var obj; 
	obj = window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol]; 
	return obj; 
} 

function getASObject(iDW,iRow,sCol){
	var iCol = getColIndex(iDW,sCol); 
	var obj; 
	obj = getASObjectByIndex(iDW,iRow,iCol); 
	return obj; 
} 
 
function as_save_ex(objname,bSSS){
	bSavePrompt = bSSS; 
	as_save(objname); 
} 

function getItemTotalByIndex(iDW,iCol){
	if(rr_c[iDW]<=0 || iCol<0 || iCol >f_c[iDW])	 
		return null;	 
	else{
		var mysum=0;
		var i;
		for(i=0;i<rr_c[iDW];i++)
			mysum += DZ[iDW][2][my_index[iDW][i]][iCol];
		return mysum;
	}
}
	 
function getItemTotal(iDW,sCol){
	iCol = getColIndex(iDW,sCol);
	return getItemTotalByIndex(iDW,iCol);
}

function window_open(myURL,myTarget,myProp){
	if(myTarget==null || typeof(myTarget)=='undefined') myTarget="";	
	if(myProp==null || typeof(myProp)=='undefined') myProp="";	
	try {
		if(arguments.length>3) {
			if(cur_frame=="")
				cur_frame="myiframe0";   
			myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);   
		}
	} catch(e) { }  
	var i=myURL.indexOf("?"),j;
	if(i==-1)
		window.open(myURL,myTarget,myProp,true);	 
	else{
		if(myTarget==""||myTarget=="_blank"){
			today = new Date();	 
			rnum = Math.abs(Math.sin(today.getTime()));	 
			myTarget = myTarget + rnum.toString(10).substring(2);	 
			window.open(location.pathname.substring(0,location.pathname.indexOf("/",1))+"/amarsoft.html",myTarget,myProp,true);	 
		}	 
		var myAction = myURL.substring(0,i);
		var myStr = myURL.substring(i+1).split("&");
		
//		myform999.document.clear();	
		myform999.document.close();
		myform999.document.write("正在打开窗口，请稍等......");
		myform999.document.write("<form name='form1' method='post' action="+myAction+" >");
		for(i=0;i<myStr.length;i++){
			j=myStr[i].indexOf("=");
			myform999.document.write("<input type='text' name='"+myStr[i].substring(0,j)+"' value="+asConvU2G(myStr[i].substring(j+1))+" >");
		}
		myform999.document.write("<input type='text' name='AmarsoftPost' value='window_open' >");
		
		if(arguments.length>3){
			var myi=0;
			//第四个参数以后（包括第四个参数）都是dw的序号,只考虑freeform的，不考虑grid的
			for(j=3;j<arguments.length;j++){
				myi = arguments[j];
				for(i=0;i<f_c[myi];i++){
					//for 数组取值不能反映change,so getItemValue
					//myform999.document.write("<input type='text' name='"+DZ[myi][1][i][15]+"."+myi+"' value='"+asConvU2G(DZ[myi][2][0][i])+"' >");					
					if( (DZ[myi][1][i][12]==2||DZ[myi][1][i][12]==5) && ('a'+getItemValueByIndex(myi,0,i) )==('a') )	
						myform999.document.write(" ");
					else	
						myform999.document.write("<input type='text' name='"+DZ[myi][1][i][15]+"."+myi+"' value='"+asConvU2G(getItemValueByIndex(myi,0,i))+"' >");
				}
			}
		}
		
		myform999.document.write("</form>");
		myform999.document.forms["form1"].target=myTarget; 
		myform999.document.forms["form1"].submit();	
	}
}	

function closeCheck(){
	if(!beforeCloseCheck()) return;
	var myobjname = cur_frame;
	if(isModified(myobjname)){
		var myi=myobjname.substring(myobjname.length-1);   
		if(!bDoUnload[myi]){
			//"当前页面内容已经被修改，按“确定”则不保存修改过的数据并且离开当前页，按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据。";
			event.returnValue=sUnloadMessage;
			if(bDoUnloadOne) bDoUnload[myi]=true;
			return;
		}
	}
}

function setPageSize(i,iSize){
	if(!beforeSetPageSize(i,iSize)) return;
	pagesize[i]=iSize;
	pagenum[i]=Math.ceil(rr_c[i]/pagesize[i]);
}