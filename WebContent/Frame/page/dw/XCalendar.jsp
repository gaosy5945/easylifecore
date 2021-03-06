<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);

    String d ="'123'";  
	if((request.getParameter("d")!=null)&&(request.getParameter("d").trim().length()!=0)){
		d= "'"+request.getParameter("d")+"'";
	}
%>
<head>
<title>日历选择器</title>
</head>
<script type="text/javascript">
var objPrevElement = new Object();

function fToggleColor(myElement) {
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText"){
		if (myElement.color == toggleColor){
			myElement.color = "";
		} else {
			myElement.color = toggleColor;
	   	}
	} else {	
		if (myElement.id == "calCell") {
			for (var i in myElement.children) {
				if (myElement.children[i].id == "calDateText") {
					if (myElement.children[i].color == toggleColor) {
						myElement.children[i].color = "";
					} else {
						myElement.children[i].color = toggleColor;
            		}
         		}
      		}
   		}
   	}
}

function fSetSelectedDay(myElement) {
	if (myElement.id == "calCell") {
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))){
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.getElementById("calSelectedDate").value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			top.returnValue=document.getElementById("tbSelYear").value+"/"+document.getElementById("tbSelMonth").value+"/"+myElement.children["calDateText"].innerText;
			top.close();
      }
   }
}

function fGetDaysInMonth(iMonth, iYear) {
	var dPrevDate = new Date(iYear, iMonth, 0);
	return dPrevDate.getDate();
}

function fBuildCal(iYear, iMonth, iDayStyle) {
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
	var d, w;
	if (iDayStyle == 2) {
		aMonth[0][0] = "Sunday";
		aMonth[0][1] = "Monday";
		aMonth[0][2] = "Tuesday";
		aMonth[0][3] = "Wednesday";
		aMonth[0][4] = "Thursday";
		aMonth[0][5] = "Friday";
		aMonth[0][6] = "Saturday";
	} else if (iDayStyle == 1) {
		aMonth[0][0] = "星期日";
		aMonth[0][1] = "星期一";
		aMonth[0][2] = "星期二";
		aMonth[0][3] = "星期三";
		aMonth[0][4] = "星期四";
		aMonth[0][5] = "星期五";
		aMonth[0][6] = "星期六";
	} else {
		aMonth[0][0] = "Su";
		aMonth[0][1] = "Mo";
		aMonth[0][2] = "Tu";
		aMonth[0][3] = "We";
		aMonth[0][4] = "Th";
		aMonth[0][5] = "Fr";
		aMonth[0][6] = "Sa";
	}

	for (d = iDayOfFirst; d < 7; d++){
		if(iVarDate<10) 
			aMonth[1][d] = "0"+iVarDate;  //add by hxd in 2001/08/27
		else
			aMonth[1][d] = iVarDate;
		
		iVarDate++;
	}

	for (w = 2; w < 7; w++) {
		for (d = 0; d < 7; d++){
			if (iVarDate <= iDaysInMonth){
				if(iVarDate<10) 
					aMonth[w][d] = "0"+iVarDate;  //add by hxd in 2001/08/27
				else
					aMonth[w][d] = iVarDate;
				iVarDate++;
	      }
	   }
	}
	
	return aMonth;
}

function fDrawCal(iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle){
	var myMonth;

	myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	document.write("<table style='margin-left: 8px;' align='center' border='1' bordercolor='#EEEEEE' cellpadding='0' cellspacing='1'>");
	document.write("<tr>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][0] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][1] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][2] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][3] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][4] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][5] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][6] + "</td>");
	document.write("</tr>");
	for (var w = 1; w < 7; w++) {
		document.write("<tr>");
		for (var d = 0; d < 7; d++){
			if (!isNaN(myMonth[w][d])){
				if(myMonth[w][d]==document.getElementById("calSelectedDate").value){
					document.write("<td align='right' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer;background-color:#c0c0c0;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
					document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>" + myMonth[w][d] + "</font>");
				}else{
					document.write("<td align='right' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
					document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>" + myMonth[w][d] + "</font>");
				}
			}else{
				document.write("<td align='right' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
				document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>&nbsp;</font>");
			}
			document.write("</td>");
		}
		document.write("</tr>");
	}
	document.write("</table>");
}

function fUpdateCal(iYear, iMonth){
	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	document.getElementById("calSelectedDate").value = "";
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

function doCancel(){
	top.returnValue="";
	top.close();
}

function doClose(){
	top.close();
}

//实现最大日期选择的功能
function doLargeDate(){
	top.returnValue="9999/12/31";
	top.close();
}

/*~[Describe=支持ESC关闭页面;InputParam=无;OutPutParam=无;]~*/
document.onkeydown = function(){
	if(event.keyCode==27){
		window.close();
	}
};

/**
 * 检查是否IE浏览器
 */
function isIEBrowser(){
	if(navigator.appName=="Microsoft Internet Explorer")
		return true;
	else
		return false;
}
if(!isIEBrowser()){ //firefox innerText define
    HTMLElement.prototype.__defineGetter__("innerText", 
    function(){
        var anyString = "";
        var childS = this.childNodes;
        for(var i=0; i<childS.length; i++) { 
            if(childS[i].nodeType==1)
                //anyString += childS[i].tagName=="BR" ? "\n" : childS[i].innerText;
                anyString += childS[i].innerText;
            else if(childS[i].nodeType==3)
                anyString += childS[i].nodeValue;
        }
        return anyString;
    } 
    ); 
    HTMLElement.prototype.__defineSetter__("innerText", 
    function(sText){
        this.textContent=sText; 
    } 
    ); 
}

</script>

<BODY bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

<form name="frmCalendarSample" method="post" action="" >
<input type="hidden" id="calSelectedDate" name="calSelectedDate" value="">

<table style="border: 0;width: 100%;" align='center'>
<tr>
<td align='right' colspan="5">
<select id="tbSelYear" name="tbSelYear" onchange='fUpdateCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value)'>
<%
	int i;
	for(i=2200;i>=1800;i--){
%>	
		<option value="<%=i%>"><%=i%></option>
<%
	}
%>
</select>

<select id="tbSelMonth" name="tbSelMonth" onchange='fUpdateCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value)'>
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
</td>
</tr>
<tr>
<td colspan="5">
<script type="text/javascript">
//isDate方法在common.js定义
var dCurDate = new Date();
if(isDate(<%=SpecialTools.amarsoft2Real(d)%>,"/")){
 	dCurDate = new Date(<%=SpecialTools.amarsoft2Real(d)%>);
}

frmCalendarSample.tbSelMonth.options[dCurDate.getMonth()].selected = true;

for (var i = 0; i < frmCalendarSample.tbSelYear.length; i++)
if (frmCalendarSample.tbSelYear.options[i].value == dCurDate.getFullYear())
frmCalendarSample.tbSelYear.options[i].selected = true;

if(dCurDate.getDate()<10)
	document.getElementById("calSelectedDate").value = "0"+dCurDate.getDate();
else
	document.getElementById("calSelectedDate").value = dCurDate.getDate();

fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 30, 20, "12px", "", 1);

</script>
</td>
</tr>
<tr>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td nowrap align="center">
	<%=new Button("确定","确定","doClose()","","").getHtmlText()%>
	<%=new Button("取消","取消","doCancel()","","").getHtmlText()%>
	<%=new Button("最大日期","最大日期","doLargeDate()","","").getHtmlText()%>
</td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>
</form>
<%@ include file="/IncludeEnd.jsp"%>