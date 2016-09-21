<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDono=CurPage.getParameter("Dono");
 	if(sDono == null) sDono = "";
 	ASObjectModel doTemp = new ASObjectModel("ValidateList");
 	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1"; 
	dwTemp.ReadOnly = "1";
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow(sDono);

	String sButtons[][] = {
		{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add"},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("验证规则设置");
	function newRecord(){
	    AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateInfo.jsp","Dono=<%=sDono%>","rightdown","");
	}
	
	function deleteRecord(){
		if(confirm('确实要删除该条记录?')){
			//as_delete(0,'getresult()');
			as_delete(0);
		}
	}
	
	mySelectRow();
	function mySelectRow(){
		var serialno = getItemValue(0,getRow(),"Serialno");
		if(typeof(serialno)=="undefined" || serialno.length==0) {
		}else{
			AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateInfo.jsp","Serialno="+serialno,"rightdown"); 
		}
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>