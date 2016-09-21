<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%>
 
 
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/dw/list.css">

<div id='showDetail'></div>
<style>
 table{
 margin-left: 10px;
 }
</style>
 <script type="text/javascript">
 function showDetail(sDisplayLogMap){
	 
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
</script>
 
<%@ include file="/IncludeEnd.jsp"%>