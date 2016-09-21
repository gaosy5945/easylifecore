<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	ASObjectModel doTemp = new ASObjectModel("AWEQueryHisList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	sASWizardHtml = "<div><font size=\"2pt\" color=\"#930055\">查询方案列表</font></div>";
	
	String sButtons[][] = {
		{"true","All","Button","新增","新增查询","newRecord()","","","",""},
		{"true","All","Button","详情","查看详情","viewDetail()","","","",""},
		{"true","All","Button","删除","删除","deleteRecord()","","","",""},
  	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
	    OpenPage("/AppConfig/QueryScheme/QuerySchemeInfo.jsp","rightdown","");  
	}

	function viewDetail(){
		mySelectRow();
	}
	
	function deleteRecord(){
		var queryNo = getItemValue(0, getRow(), "QUERYSCHEMENO");
		if(typeof(queryNo)=="undefined" || queryNo.length == 0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_delete("myiframe0");
		}
	}
	function mySelectRow(){
		var queryNo = getItemValue(0, getRow(), "QUERYSCHEMENO");
		if(typeof(queryNo)=="undefined" || queryNo.length == 0){
			return;
		}else{
			AsControl.OpenView("/AppConfig/QueryScheme/QuerySchemeInfo.jsp","queryNo="+queryNo,"rightdown","");
		}
	}
	mySelectRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>