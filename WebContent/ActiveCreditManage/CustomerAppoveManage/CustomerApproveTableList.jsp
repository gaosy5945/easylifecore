<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String TempleteNo = CurComp.getParameter("TempleteNo");
	if(TempleteNo == null) TempleteNo = "";
	String BatchNo = CurComp.getParameter("BatchNo");
	if(BatchNo == null) BatchNo = "";

	ASObjectModel doTemp = new ASObjectModel("CustomerApprovalTableList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("BatchNo", BatchNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","下载","下载","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
	};
%>
<HEAD>
<title>预审批列表</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function viewAndEdit(){
	var TempleteNo = "<%=TempleteNo%>";
	var SerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(SerialNo) == "undefined"||SerialNo.length == 0){
		alert("请选择一条记录！");
		return;
	}
	AsControl.PopView("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveTableInfo.jsp", "SerialNo="+SerialNo+"&TempleteNo="+TempleteNo, "resizable=yes;dialogWidth=800px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
