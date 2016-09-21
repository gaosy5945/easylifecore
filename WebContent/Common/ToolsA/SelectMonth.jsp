<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<head>
<title>请选择年月</title>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

<script>
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

function fSetSelectedMonth(month){
	top.returnValue=document.getElementById("Year").value+"/"+month;
	top.close();
}

function doCancel(){
	top.returnValue="";
	top.close();
}

function doClose(){
	top.close();
}

/*~[Describe=支持ESC关闭页面;InputParam=无;OutPutParam=无;]~*/
document.onkeydown = function(){
	if(event.keyCode==27){
		top.close();
	}
};
</script>
<div align=center>
<form name="item">
<table>
<tr><td align="right">
<select id="Year" name="Year">
<%
int dCurYear = Calendar.getInstance().get(Calendar.YEAR);
out.println("<option selected value='"+dCurYear+"'>"+dCurYear+"</option>");
for(int i=dCurYear-1;i>dCurYear-50;i--){
	out.println("<option value='"+i+"'>"+i+"</option>");
}
%>
</select>年
</td>
</tr>
<tr>
<td>
<table align='right' border='1' bordercolor='#EEEEEE' cellpadding='0' cellspacing='1'>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('01')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('01')">一月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('02')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('02')">二月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('03')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('03')">三月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('04')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('04')">四月</font>
</td>
</tr>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('05')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('05')">五月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('06')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('06')">六月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('07')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('07')">七月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('08')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('08')">八月</font>
</td>
</tr>
<tr>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('09')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('09')">九月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('10')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('10')">十月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('11')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('11')">十一月</font>
</td>
<td align='right' valign='top' width='50' height='28' id=calCell style='cursor:pointer;' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('12')">
<font id=calDateText onMouseOver='fToggleColor(this)' style='cursor:pointer;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick="fSetSelectedMonth('12')">十二月</font>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td align='right'>
	<%=new Button("关闭","关闭","doClose()","","").getHtmlText()%>
	<%=new Button("清空","清空","doCancel()","","").getHtmlText()%>
</td>
</tr>
</table>
</form>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>