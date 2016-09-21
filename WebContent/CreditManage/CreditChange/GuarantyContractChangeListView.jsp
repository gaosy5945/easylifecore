<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String applyType = CurPage.getParameter("ApplyType");
	String flowFlag = CurPage.getParameter("FlowFlag");
	String taskType = CurPage.getParameter("TaskType");
	String transCode = CurPage.getParameter("TransCode");
	String gcSerialNo = CurPage.getParameter("GCSerialNo");
	
	ASObjectModel doTemp = new ASObjectModel("GuarantyContractChangeListView");	
	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("GCSerialNo",gcSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"DocumentObjectNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var guarantorID=getItemValue(0,getRow(),"GuarantorID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			guarantorID = "";
		}
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var gcSerialNo=getItemValue(0,getRow(),"RelativeObjectNo");
		var rightType = "ReadOnly";
		AsCredit.openFunction("CeilingGCChangeTab", "ObjectNo="+serialNo+"&GuarantyType="+guarantyType+"&GuarantorID="+guarantorID+"&GCSerialNo="+gcSerialNo+"&RightType="+rightType);
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
