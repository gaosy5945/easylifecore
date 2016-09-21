
<%@page import="com.amarsoft.awe.util.json.JSONValue"%>
<%@page import="com.amarsoft.app.als.sys.widget.DwTempTools"%><%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/dw/list.css">

<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "RecordChangeInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//只读模式

	dwTemp.genHTMLObjectWindow(serialNo);

	
	String json=dwTemp.toJson(serialNo);
	Map<String,String> map=(Map<String,String>)JSONValue.parse(json);
	String sDisplayLogMap=map.get("DISPLAYLOGMAP");
	 
 
	dwTemp.replaceColumn("DisPlayLogMap", "<div id='showDetail'></div>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","返回","返回","goBack(0)","","","",""}
	}; 
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<textarea  style='display:none' ID='DISPLAYMAP'><%=sDisplayLogMap%></TEXTAREA>
<script>

	function showDetail(){
		 sDisplayLogMap=$("#DISPLAYMAP").val();//
		// alert(sDisplayLogMap);
		
		 var sDisplayLogMap=JSON.parse(sDisplayLogMap);
			var detail=$("#showDetail");
			detail.html("");
			var dev=$("<DIV id=Table_Content_0></div>").appendTo(detail);
			 var tb=$("<table style='width90%;left:10px'   border=0 cellSpacing=0 cellPadding=0 lockCols=\"0\" origFloatHeight=\"100\" origFloatWidth=\"800\"></table>").appendTo(dev);
			 $('<THEAD class=list_topdiv_header><tr  style="BACKGROUND-COLOR: #f2f2f2" id=TR_Right_myiframe0_0 lightColor="#DEE5CD" origColor="#f2f2f2"><th  class=list_all_no> &nbsp;&nbsp;&nbsp; </th><th width=200px >字段名称</th><th width=200px>修改前</th><th width=200px>修改后</th></tr></THEAD>').appendTo(tb);
			 var inum=1;
			var tbody=$("<TBODY id=myiframe0_order_GridBody_Cells></tbody>").appendTo(tb);
			 for(var o in sDisplayLogMap){
				var map=sDisplayLogMap[o];
				if(inum%2==0){
				 $('<tr style="BACKGROUND-COLOR: #f2f2f2" id=TR_Right_myiframe0_0 lightColor="#DEE5CD" origColor="#f2f2f2"><td  class=list_all_no style="width:10px">&nbsp;&nbsp;'+inum+'&nbsp;&nbsp;</td><td  class=list_all_td>&nbsp;'+map["ColHeader"]+'</td><td class=list_all_td>&nbsp;'+map["OldValue"]+'</td><td class=list_all_td>'+map["NewValue"]+'&nbsp;</td></tr>').appendTo(tbody);
				}else{
					 $('<tr style="BACKGROUND-COLOR: #fff" id=TR_Right_myiframe0_1  lightColor="#DEE5CD" origColor="#FFF"><td  class=list_all_no  style="width:10px">&nbsp;&nbsp;'+inum+'&nbsp;&nbsp; </td><td class=list_all_td>&nbsp;'+map["ColHeader"]+'</td><td class=list_all_td>&nbsp;'+map["OldValue"]+'</td><td class=list_all_td>'+map["NewValue"]+'&nbsp;</td></tr>').appendTo(tbody);
				}
				inum++;
			 }
	}
	$(function(){
		showDetail();
	});

	function goBack(){
		
		AsControl.OpenPage("/CreditManage/Other/RecordChangeList.jsp","","_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
