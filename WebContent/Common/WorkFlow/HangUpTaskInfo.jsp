<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page language="java" 
  import="java.util.*,com.amarsoft.are.sql.*,com.amarsoft.are.util.*,com.amarsoft.context.*,com.amarsoft.web.*,com.amarsoft.web.ui.*,com.amarsoft.web.dw.*" 
    buffer="64kb"  
%>
<%
	//add by byhu 20050708
	String sResourcesPath = (String)session.getAttribute("ResourcesPath");
	String sBusinessDate = DateHelper.getBusinessDate();
%>
<HEAD>
<title>日历选择器</title>
<%
	String d ="'123'";  
	if((request.getParameter("d")!=null)&&(request.getParameter("d").trim().length()!=0))
	{
		d= "'"+request.getParameter("d")+"'";
	}
	d = DataConvert.toString(d);
%>
</HEAD>

<SCRIPT LANGUAGE="JavaScript">

var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurDayOfMonth = dDate.getDate();
var dCurYear = dDate.getFullYear();
var objPrevElement = new Object();

function fToggleColor(myElement) 
{
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText") 
	{
		if (myElement.color == toggleColor) 
		{
			myElement.color = "";
		} 
		else 
		{
			myElement.color = toggleColor;
	   	}
	} 
	else 
	{	
		if (myElement.id == "calCell") 
		{
			for (var i in myElement.children) 
			{
				if (myElement.children[i].id == "calDateText") 
				{
					if (myElement.children[i].color == toggleColor) 
					{
						myElement.children[i].color = "";
					} 
					else 
					{
						myElement.children[i].color = toggleColor;
            		}
         		}
      		}
   		}
   	}

}

function fSetSelectedDay(myElement)
{
	if (myElement.id == "calCell") 
	{
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))) 
		{
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.all.calSelectedDate.value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			var vHour=document.getElementById("tbSelHour").value;
			if(vHour.length<2) vHour = "0"+vHour;
			var vMin = document.getElementById("tbSelMin").value;
			if(vMin.length<2) vMin = "0"+vMin;
			self.returnValue=document.all.tbSelYear.value+"/"+document.all.tbSelMonth.value+"/"+myElement.children["calDateText"].innerText+" "+vHour+":"+vMin+":00";
			window.close();
      }
   }
}

function fGetDaysInMonth(iMonth, iYear) 
{
	var dPrevDate = new Date(iYear, iMonth, 0);
	return dPrevDate.getDate();
}

function fBuildCal(iYear, iMonth, iDayStyle) 
{
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
	} 
	else if (iDayStyle == 1) 
	{
		aMonth[0][0] = "星期日";
		aMonth[0][1] = "星期一";
		aMonth[0][2] = "星期二";
		aMonth[0][3] = "星期三";
		aMonth[0][4] = "星期四";
		aMonth[0][5] = "星期五";
		aMonth[0][6] = "星期六";
	} 
	else 
	{
		aMonth[0][0] = "Su";
		aMonth[0][1] = "Mo";
		aMonth[0][2] = "Tu";
		aMonth[0][3] = "We";
		aMonth[0][4] = "Th";
		aMonth[0][5] = "Fr";
		aMonth[0][6] = "Sa";
	}

	for (d = iDayOfFirst; d < 7; d++) 
	{
		if(iVarDate<10) 
			aMonth[1][d] = "0"+iVarDate;
		else
			aMonth[1][d] = iVarDate;
		
		iVarDate++;
	}

	for (w = 2; w < 7; w++) 
	{
		for (d = 0; d < 7; d++) 
		{	
			if (iVarDate <= iDaysInMonth) 
			{
				if(iVarDate<10) 
					aMonth[w][d] = "0"+iVarDate;
				else
					aMonth[w][d] = iVarDate;
				iVarDate++;
	      }
	   }
	}
	
	return aMonth;
}

function fDrawCal(iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle) 
{
	var myMonth;

	myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	document.write("<table align='right' border='1'  bordercolor='#EEEEEE' cellpadding='0' cellspacing='1'>")
	document.write("<tr>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][0] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][1] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][2] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][3] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][4] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][5] + "</td>");
	document.write("<td align='center' bgcolor='#DDDDDD' nowrap height='20' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: '>" + myMonth[0][6] + "</td>");
	document.write("</tr>");
	for (w = 1; w < 7; w++) 
	{
		document.write("<tr>")
		for (d = 0; d < 7; d++) 
		{
			if (!isNaN(myMonth[w][d])) 
			{
				if(myMonth[w][d]==document.all.calSelectedDate.value)
				{
					document.write("<td align='right' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand;background-color:#c0c0c0;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
					document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>" + myMonth[w][d] + "</font>");
				}
				else
				{
					document.write("<td align='right' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
					document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>" + myMonth[w][d] + "</font>");
				}
			} 
			else 
			{
				document.write("<td align='right' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
				document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>&nbsp;</font>");
			}
			document.write("</td>")
		}
		document.write("</tr>");
	}
	document.write("</table>")
}

function fUpdateCal(iYear, iMonth) 
{
	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	document.all.calSelectedDate.value = "";
	for (w = 1; w < 7; w++) 
	{
		for (d = 0; d < 7; d++) 
		{
			if (!isNaN(myMonth[w][d])) 
			{
				calDateText[((7*w)+d)-7].innerText = myMonth[w][d];
			} 
			else 
			{
				calDateText[((7*w)+d)-7].innerText = " ";
        	}
      	}
   	}
}

function doCancel()
{	
	self.returnValue="";
	window.close();
}

function doClose()
{	
	window.close();
}

</script>


<BODY bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

<form name="frmCalendarSample" method="post" action="">
<input type="hidden" name="calSelectedDate" value="">

<table border="0" align='center' width='100%'>
<tr>
<td align='right'>
<select name="tbSelHour" id=tbSelHour>
<%
	int g;
	for(g=23;g>=0;g--)
	{
		
%>	
		<option value="<%=g%>"><%=g%>时</option>
<%
	}
%>
</select>
<select name="tbSelMin" id=tbSelMin>
<%
	int j;
	for(j=59;j>=0;j--)
	{
%>	
		<option value="<%=j%>"><%=j%>分</option>
<%
	}
%>
</select>
<select name="tbSelYear" onchange='fUpdateCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value)'>
<%
	int i;
	for(i=2200;i>=1800;i--)
	{
%>	
		<option value="<%=i%>"><%=i%></option>
<%
	}
%>
</select>

<select name="tbSelMonth" onchange='fUpdateCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value)'>
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
<td>
<script language="JavaScript">
function isDate(value,separator) 
{
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

var dCurDate = new Date('<%=sBusinessDate%>');
if(isDate("<%=org.apache.commons.lang.StringEscapeUtils.escapeHtml(d)%>","/"))
{
 	dCurDate = new Date("<%=org.apache.commons.lang.StringEscapeUtils.escapeHtml(d)%>");
}

frmCalendarSample.tbSelMonth.options[dCurDate.getMonth()].selected = true;

for (i = 0; i < frmCalendarSample.tbSelYear.length; i++)
if (frmCalendarSample.tbSelYear.options[i].value == dCurDate.getFullYear())
frmCalendarSample.tbSelYear.options[i].selected = true;

if(dCurDate.getDate()<10)
	document.all.calSelectedDate.value = "0"+dCurDate.getDate();
else
	document.all.calSelectedDate.value = dCurDate.getDate();

fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 30, 20, "12px", "", 1);

</script>
</td>
</tr>

<tr>
<%-- <td align='right'>
     <img border='0' src='<%=sResourcesPath%>/close.gif' onclick="javascript:doClose();" style='cursor:hand'>
     <img border='0' src='<%=sResourcesPath%>/zero.gif'  onclick="javascript:doCancel();" style='cursor:hand'>    
</td> --%>
</tr>
</table>
</form>
