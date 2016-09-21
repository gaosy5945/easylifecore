<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String sMyCurrentJob[][] = new String[100][5];
	int iJobs=0;
	String sSql ="select SerialNo,WorkType,WorkBrief,PlanFinishDate,PromptBeginDate,ActualFinishDate,"
			+"WorkContent "
			+"from WORK_RECORD  "
			+"where  (ActualFinishDate is null or ActualFinishDate=' ') and InputUserID = :UserID "; 
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID", CurUser.getUserID()));
	while(rs.next()){
		sMyCurrentJob[iJobs][0] = rs.getString("SerialNo");
		sMyCurrentJob[iJobs][1] = rs.getString("WorkType");
		sMyCurrentJob[iJobs][2] = SpecialTools.real2Amarsoft(rs.getString("WorkBrief"));
		sMyCurrentJob[iJobs][3] = SpecialTools.real2Amarsoft(rs.getString("WorkContent"));
		sMyCurrentJob[iJobs][4] = rs.getString("PlanFinishDate");
		if(sMyCurrentJob[iJobs][4]==null) sMyCurrentJob[iJobs][4]="";
		iJobs++;
	}
	rs.getStatement().close();
%>
<HEAD>
<title>日历选择器</title>
<link rel="stylesheet" href="<%=sWebRootPath%><%=sSkinPath%>/css/mycalendar.css">
</HEAD>
<script type="text/javascript">
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurDayOfMonth = dDate.getDate();
var dCurYear = dDate.getFullYear();
var objPrevElement = new Object();
var sCurJob = new Array();
<%
String sCurYear,sCurMonth,sDate;
int iCurYear,iCurMonth,iDate;
for(int i=0;i<iJobs;i++){
	if(sMyCurrentJob[i]==null) break;
	if(sMyCurrentJob[i][0]!=null){
		%>
		sCurJob[<%=i%>] = new Array(7);
		sCurJob[<%=i%>][0] = "<%=sMyCurrentJob[i][0]%>";
		sCurJob[<%=i%>][1] = "<%=sMyCurrentJob[i][1]%>";
		sCurJob[<%=i%>][2] = "<%=sMyCurrentJob[i][2]%>";
		sCurJob[<%=i%>][3] = "<%=sMyCurrentJob[i][3]%>";
		<%
		sCurYear = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",1);
		sCurMonth = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",2);
		sDate = StringFunction.getSeparate(sMyCurrentJob[i][4],"/",3);
		
		if(sCurYear==null || sCurYear.equals("")) iCurYear=0;
		else iCurYear=Integer.parseInt(sCurYear);
		if(sCurMonth==null || sCurMonth.equals("")) iCurMonth=0;
		else iCurMonth=Integer.parseInt(sCurMonth);
		if(sDate==null || sDate.equals("")) iDate=0;
		else iDate=Integer.parseInt(sDate);
		
		%>
		sCurJob[<%=i%>][4] = <%=iCurYear%>;
		sCurJob[<%=i%>][5] = <%=iCurMonth%>;
		sCurJob[<%=i%>][6] = <%=iDate%>;
		<%
	}else{
		break;
	}
}
%>

function getTodayJobCount(iYear,iMonth,iDay){
	var iCountWorks=0;
	for(var i=0;i<sCurJob.length;i++){
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay){
			iCountWorks++;
		}
	}
	return iCountWorks;
}

function getTodayTip(iYear,iMonth,iDay){
	var sTips="",sTmp="",j=1;
	for(var i=0;i<sCurJob.length;i++){
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDay){
			//alert(iYear+iMonth+iDay);
			sTmp = sCurJob[i][2];
			if(sTmp==null) sTmp="";
			if(sTmp.length>10) sTmp = sTmp.substring(0,10)+"...";
			sTips += sTmp+"~p";
			j++;
		}
	}
	sTips=""+sTips;
	return sTips;
}

function fToggleColor(myElement){
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText"){
		if (myElement.color == toggleColor){
			myElement.color = "";
		}else{
			myElement.color = toggleColor;
	   	}
	}else{
		if (myElement.id == "calCell"){
			for (var i in myElement.children){
				if (myElement.children[i].id == "calDateText"){
					if (myElement.children[i].color == toggleColor){
						myElement.children[i].color = "";
					}else{
						myElement.children[i].color = toggleColor;
            		}
         		}
      		}
   		}
   	}
}

function fSetSelectedDay(myElement){
	if (myElement.id == "calCell"){
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))){
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.all.calSelectedDate.value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			//modify by hxd in 2001/08/27
			//self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+document.all.calSelectedDate.value;
			self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+myElement.children["calDateText"].innerText;
			window.close();
      	}
   	}
}

function fGetDaysInMonth(iMonth,iYear){
	var dPrevDate = new Date(iYear, iMonth, 0);
	return dPrevDate.getDate();
}

function fBuildCal(iYear, iMonth, iDayStyle){
	var aMonth = new Array();
	aMonth[0] = new Array(7);
	aMonth[1] = new Array(7);
	aMonth[2] = new Array(7);
	aMonth[3] = new Array(7);
	aMonth[4] = new Array(7);
	aMonth[5] = new Array(7);
	aMonth[6] = new Array(7);
	var dCalDate = new Date(iYear, iMonth-1, 1);
	var iDayOfFirst = dCalDate.getDay();
	var iDaysInMonth = fGetDaysInMonth(iMonth, iYear);
	var iVarDate = 1;
	var i, d, w;
	if (iDayStyle == 2) {
		aMonth[0][0] = "Sunday";
		aMonth[0][1] = "Monday";
		aMonth[0][2] = "Tuesday";
		aMonth[0][3] = "Wednesday";
		aMonth[0][4] = "Thursday";
		aMonth[0][5] = "Friday";
		aMonth[0][6] = "Saturday";
	} else if (iDayStyle == 1) {
		aMonth[0][0] = "日";
		aMonth[0][1] = "一";
		aMonth[0][2] = "二";
		aMonth[0][3] = "三";
		aMonth[0][4] = "四";
		aMonth[0][5] = "五";
		aMonth[0][6] = "六";
	} else {
		aMonth[0][0] = "Su";
		aMonth[0][1] = "Mo";
		aMonth[0][2] = "Tu";
		aMonth[0][3] = "We";
		aMonth[0][4] = "Th";
		aMonth[0][5] = "Fr";
		aMonth[0][6] = "Sa";
	}
	//上月月末日历信息
	var gmonth = iMonth-1;
    var gyear  = iYear;
    if(gmonth==0){
    	gmonth=12;
    	gyear=iYear-1;
    }
	var gDaysInMonth = fGetDaysInMonth(gmonth, gyear);
	if(iDayOfFirst==0){
	    iDayOfFirst=7;
	}
    var gDays=gDaysInMonth-iDayOfFirst+1;
    
    for (var n = 0; n < iDayOfFirst; n++){
    	var temp = new Array(3);
   		temp[0]=gyear;
    	temp[1]=gmonth;
    	temp[2]=gDays+n;
      aMonth[1][n] = temp;
    }
    
    //当月日历信息 
	for (d = iDayOfFirst; d < 7; d++) {
	    var temp = new Array(3);
   		 temp[0]=iYear; 
   	 	 temp[1]=iMonth;
		if(iVarDate<10) 
			 temp[2] = "0"+iVarDate;  //add by hxd in 2001/08/27
		else
			 temp[2] = iVarDate;
		aMonth[1][d] = temp;
		iVarDate++;
	}
	
    for (w = 2; w <7; w++){
		for (d = 0; d < 7; d++) {
			if (iVarDate <= iDaysInMonth) {
				var temp = new Array(3);
   		 		temp[0]=iYear; 
   	 	 		temp[1]=iMonth;
				if(iVarDate<10) 
					temp[2] = "0"+iVarDate; //add by hxd in 2001/08/27
				else
					temp[2] = iVarDate;
				aMonth[w][d] = temp;
				iVarDate++;
	        }
	   }
	}
	//下月月初日历信息
	var nmonth = iMonth+1;
    var nyear  = iYear;
    if(nmonth==13){
    	nmonth=1;
    	nyear=iYear+1;
    }
	var nDays=6*7-(iDayOfFirst+iDaysInMonth); 
	for (n =0 ; n<nDays ; n++){
	    var temp = new Array(3);
        temp[0]=nyear;
      	temp[1]=nmonth;
	    temp[2]=nDays-n;
	   if(n<7){
		 aMonth[6][6-n]  = temp;
	   }else{
	  	 aMonth[5][13-n] = temp;
	   }
    }
	
	return aMonth;
}

function fDrawCal(iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle) {
	var myMonth;
	var sReturn = "";
	myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	sReturn += ("<table align='center' border='0' cellpadding='0' cellspacing='0'>");
	sReturn += ("<tr>");
	sReturn += ("<td align='center' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][0] + "</td>");
	sReturn += ("<td align='center' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][1] + "</td>");
	sReturn += ("<td align='center' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][2] + "</td>");
	sReturn += ("<td align='center' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][3] + "</td>");
	sReturn += ("<td align='center' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][4] + "</td>");
	sReturn += ("<td align='center' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][5] + "</td>");
	sReturn += ("<td align='centesMyCurrentJobr' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][6] + "</td>");
	sReturn += ("</tr>");
	var tdClickEvent="";
	var gstype="";
	for (var w = 1; w < 7; w++) {
		sReturn += ("<tr>");
		for (var d = 0; d < 7; d++) {
			    tdClickEvent = " onClick=newTask("+myMonth[w][d][0]+","+myMonth[w][d][1]+","+myMonth[w][d][2]+") ";
			    if(myMonth[w][d][0] == iYear&&myMonth[w][d][1] == iMonth){
				      gstype = 'CURSOR:Hand;FONT-FAMILY:Arial;COLOR:#000000;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "';
				    }else{
				      gstype = 'CURSOR:Hand;FONT-FAMILY:Arial;COLOR:#a8a8a8;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "';
				 }
				if(myMonth[w][d][0]==dCurDate.getFullYear() && myMonth[w][d][1]==(dCurDate.getMonth()+1) && myMonth[w][d][2]==document.all.calSelectedDate.value)
				{
					if(getTodayJobCount(myMonth[w][d][0],myMonth[w][d][1],parseInt(myMonth[w][d][2],10))>0){
						sReturn += ("<td class='today' align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand;' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(myMonth[w][d][0],myMonth[w][d][1],parseInt(myMonth[w][d][2],10))+"\')"+tdClickEvent+" >");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='"+gstype + "'  onMouseOut='fToggleColor(this)' >");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d][2] +"");
						sReturn += ("</b>");
						sReturn += ("</font>");
					}else{
						sReturn += ("<td class='today' align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand;' onmouseout='hidelayer(0,this)' onMouseOver='showlayer(0,this)'"+tdClickEvent+">");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='"+gstype + "'  onMouseOut='fToggleColor(this)'  >");
						sReturn += (""+ myMonth[w][d][2] +"");
						sReturn += ("</font>");
					}
				}else{
					if(getTodayJobCount(myMonth[w][d][0],myMonth[w][d][1],parseInt(myMonth[w][d][2],10))>0){
						sReturn += ("<td class='today-alert' align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onMouseOver=showTipOfToday(1,this,\'"+getTodayTip(myMonth[w][d][0],myMonth[w][d][1],parseInt(myMonth[w][d][2],10))+"\') "+tdClickEvent+">");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='"+gstype + "' onMouseOut='fToggleColor(this)' >");
						sReturn += ("<b>");
						sReturn += (""+ myMonth[w][d][2] +"");
						sReturn += ("</b>");
						sReturn += ( "</font>");
					}else{
						sReturn += ("<td align='center' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onmouseout='hidelayer(0,this)'  onMouseOver='showlayer(0,this)'"+tdClickEvent+">");
						sReturn += ("<font id=calDateText onMouseOver='fToggleColor(this)' style='"+gstype + "' onMouseOut='fToggleColor(this)' >");
						sReturn += (""+ myMonth[w][d][2] +"");
						sReturn += ( "</font>");
					}
				}
		}
		sReturn += ("</tr>");
	}
	sReturn += ("</table>");
	return sReturn;
}

function fUpdateCal(iYear, iMonth) {
	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	document.all.calSelectedDate.value = "";
	for (var w = 1; w < 7; w++) {
		for (var d = 0; d < 7; d++) {
			if (!isNaN(myMonth[w][d])) {
				calDateText[((7*w)+d)-7].innerText = myMonth[w][d];
			} else {
				calDateText[((7*w)+d)-7].innerText = " ";
        	}
      	}
   	}
}

//跳转上月日历
function gotoMonth(){
	var month = frmCalendarSample.tbSelMonth.value-1;
    var year  = frmCalendarSample.tbSelYear.value;
    if(month==0){
    	month=12;
    	year=year-1;
    	for (var i = 0; i < frmCalendarSample.tbSelYear.length; i++){
    		if (frmCalendarSample.tbSelYear.options[i].value == year)
        		frmCalendarSample.tbSelYear.options[i].selected = true;
        }
    } 
    frmCalendarSample.tbSelMonth.options[month-1].selected = true;
    drawHtmlToObject(document.all("MyCalendar"),fDrawCal(year,month, 30, 20, "11px", "", 1));
    //fUpdateCal(year, month);
}
//跳转下月日历
function nextMonth(){	
	var month = frmCalendarSample.tbSelMonth.value-0+1;
    var year  = frmCalendarSample.tbSelYear.value;
    if(month==13){
    	month=1;
    	year=year-0+1;
    	for (var i = 0; i < frmCalendarSample.tbSelYear.length; i++){
    		if (frmCalendarSample.tbSelYear.options[i].value == year)
        		frmCalendarSample.tbSelYear.options[i].selected = true;
        }		
    } 
    frmCalendarSample.tbSelMonth.options[month-1].selected = true;
    drawHtmlToObject(document.all("MyCalendar"),fDrawCal(year,month, 30, 20, "11px", "", 1));
    //fUpdateCal(year, month);
}

function isDate(value,separator){
	var sItems = value.split(separator);
	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false; 
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2050) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
	return true;
}

function showTipOfToday(id,e,sText){  
   	sText = sText.replace(/~p/gi,"");
    sHtmlTmp = "";
//    sHtmlTmp += "<table   border=1 cellspacing=0 cellpadding=3 bordercolorlight=#99999 bordercolordark=#FFFFFF width=110 ><tr><td class=SubMenuTd2>";
    sHtmlTmp +='<div>';
    sHtmlTmp += sText;
    sHtmlTmp += "</div>";
    document.all('subMenu'+id).innerHTML = sHtmlTmp;
  	var length = sText.length;
  	var length_zn = sText.replace(/[0-9a-zA-Z._:]/g,"").length;
  	var width = length_zn*14+(length-length_zn)*8;
    showlayer(id,e,width);
}

function newTask(iYear,iMonth,iDate){
	var sSerialNo="";
	for(var i=0;i<sCurJob.length;i++){
		//alert(sCurJob[i][4]+"/"+sCurJob[i][5]+"/"+sCurJob[i][6]);
		if(sCurJob[i][4]==iYear && sCurJob[i][5]==iMonth && sCurJob[i][6]==iDate){
			sSerialNo=sCurJob[i][0];
			editWork(sSerialNo);
			return;
		}
	}
	editWork("");
}
function editWork(sSerialNo){
	popComp("WorkRecordInfo","/DeskTop/WorkRecordInfo.jsp","SerialNo="+sSerialNo+"&NoteType=All", "","");
	reloadSelf();
}

function hidelayer(id,e){
	document.getElementById('subMenu'+id).style.visibility="hidden";
}

function showlayer(id,e,width){
	/**modify by cdzhai in 2014年4月25日,tip:td的高为21，宽为30*/;
	if(width==null) return false;
	var position = $(e).position();
	var tdLeft = position.left;
	var tdTop = position.top;
	tdLeft = Number(tdLeft);
	var left = tdLeft;
	var top = tdTop-22;
	if(left+width>document.body.offsetWidth)
		left = document.body.offsetWidth - width;
	else{
		if(left-(width-30)/2<0)
			left = 0;
		else
			left = left-(width-30)/2;
	}
	if(top<0) top = 0;
	var subMenu = document.getElementById('subMenu'+id);
	subMenu.style.left = left;
	subMenu.style.top = top;
	//subMenu.width = width;
    
//     if(getRealLeft(e)+ e.offsetWidth + document.all('subMenu'+id).offsetWidth >document.body.offsetWidth)
//     	document.all('subMenu'+id).style.left = getRealLeft(e) - document.all('subMenu'+id).offsetWidth;
    
//     if(getRealTop(e)+ e.offsetHeight + document.all('subMenu'+id).offsetHeight >document.body.offsetHeight)
//     	document.all('subMenu'+id).style.top = getRealTop(e) - document.all('subMenu'+id).offsetHeight;
    
    subMenu.style.visibility="visible";
}
function getRealTop(imgElem) {
    yPos = eval(imgElem).offsetTop;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) {
        yPos += tempEl.offsetTop;
        tempEl = tempEl.offsetParent;
    }
    return yPos;
}
function getRealLeft(imgElem) {
    xPos = eval(imgElem).offsetLeft;
    tempEl = eval(imgElem).offsetParent;
    while (tempEl != null) {
        xPos += tempEl.offsetLeft;
        tempEl = tempEl.offsetParent;
    }
    return xPos;
}
</script>
<BODY leftmargin="0" topmargin="0">
<input type="hidden" name="calSelectedDate" value="">
<form name="frmCalendarSample" method="post" action="">
<table style="border: 0;width: 100%" align='center'>
<tr>
<td align="center" style="height:26px;border:none;border:0px;display: inline;margin-bottom: 4px; margin-top: 4px;" onMouseOver="showlayer(0,this)">
<a onclick="gotoMonth()" class="leftm"></a>
<div style=" width:200px; float:left">
<select name="tbSelYear" onchange='drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1))'>
<%
	int i;
	for(i=2000;i<=2025;i++){
%>	
		<option value="<%=i%>"><%=i%></option>
<%
	}
%>
</select>

<select name="tbSelMonth" onchange='drawHtmlToObject(document.all("MyCalendar"),fDrawCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value, 30, 20, "11px", "", 1))'>
	<option value="01">一月</option>
	<option value="02">二月</option>
	<option value="03">三月</option>
	<option value="04">四月</option>
	<option value="05">五月</option>
	<option value="06">六月</option>
	<option value="07">七月</option>
	<option value="08">八月</option>
	<option value="09">九月</option>
	<option value="10">十月</option>
	<option value="11">十一月</option>
	<option value="12">十二月</option>
</select> 
</div>
<a onclick="nextMonth()" class="rightm"></a>
</td>
</tr>
<tr>
	<td id=MyCalendar style="border:none;border:0px;"></td>
</tr>
</table>
</form>
<div id="subMenu0" style="position:absolute; left:0px; top:0px; visibility:hidden" ></div>
<div id="subMenu1"  onMouseOver='showlayer(0,this)'></div>
<script type="text/javascript">
var dCurDate = new Date();

frmCalendarSample.tbSelMonth.options[dCurDate.getMonth()].selected = true;

for (var i = 0; i < frmCalendarSample.tbSelYear.length; i++){
	if (frmCalendarSample.tbSelYear.options[i].value == dCurDate.getFullYear())
		frmCalendarSample.tbSelYear.options[i].selected = true;
}

if(dCurDate.getDate()<10)
	document.all.calSelectedDate.value = "0"+dCurDate.getDate();
else
	document.all.calSelectedDate.value = dCurDate.getDate();

drawHtmlToObject(document.all("MyCalendar"),amarsoft2Real(fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 30, 20, "11px", "", 1)));
</script>
<%@ include file="/IncludeEnd.jsp"%>