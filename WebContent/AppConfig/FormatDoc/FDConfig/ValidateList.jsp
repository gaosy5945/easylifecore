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
		{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("��֤��������");
	function newRecord(){
	    AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateInfo.jsp","Dono=<%=sDono%>","rightdown","");
	}
	
	function deleteRecord(){
		if(confirm('ȷʵҪɾ��������¼?')){
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