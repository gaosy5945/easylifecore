<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String StatusTemp = CurPage.getParameter("Status");
	if(StatusTemp == null) StatusTemp= "";
	String Status = StatusTemp.replace(",", "','");
	ASObjectModel doTemp = new ASObjectModel("ProjectApproveResultList");
	doTemp.setJboWhere(doTemp.getJboWhere()+" and O.Status in ('"+Status+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("Status", Status);
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","合作项目详情","合作项目详情","projectView()","","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function projectView(){
		var projectSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(projectSerialNo) == "undefined" || projectSerialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var functionID = "ProjectAlterApproveInfo";
		var readFlag = "ReadOnly";
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+projectSerialNo);
		AsCredit.openFunction(functionID,"SerialNo="+projectSerialNo+"&CustomerID="+CustomerID+"&FlowSerialNo="+flowSerialNo+"&readFlag="+readFlag,"");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
