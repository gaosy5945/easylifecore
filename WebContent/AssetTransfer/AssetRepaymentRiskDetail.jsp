<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("AssetRepaymentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","����","����","view()","","","","btn_icon_detail",""},
			{"true","","Button","�����嵥","�����嵥","repaymentList()","","","","btn_icon_add",""},
			{"true","","Button","����","����","asExport()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function view(){
		 var sUrl = "";
		 OpenPage(sUrl,'_self','');
	}
	
	function repaymentList(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		var sUrl = "/AssetTransfer/RepaymentList.jsp";
		AsControl.OpenView(sUrl,"ObjectNo="+serialNo,"_blank");
	}
	
	function asExport(){
		amarExport("myiframe0");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
