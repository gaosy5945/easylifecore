<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("AssetRepaymentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","详情","详情","view()","","","","btn_icon_detail",""},
			{"true","","Button","还款清单","还款清单","repaymentList()","","","","btn_icon_add",""},
			{"true","","Button","导出","导出","asExport()","","","","btn_icon_delete",""},
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
