<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from FLOW_OBJECT where ObjectNo = :ObjectNo and ObjectType =:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
	String flowVersion = Sqlca.getString(new SqlObject("select FlowVersion from FLOW_OBJECT where ObjectNo = :ObjectNo and ObjectType =:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";
    String tempno = "CreditApproveList2";
    ASObjectModel doTemp = new ASObjectModel(tempno);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("objectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		var flowSerialNo = getItemValue(0,getRow(),"FLOWSERIALNO");
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("SignTApproveInfo1","TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>");
		//var returnValue = AsControl.RunASMethod("BusinessManage","QueryIsCanReadOpinion","<%=CurUser.getUserID()%>,"+flowSerialNo);
		//if(returnValue == "false"){
		//	alert("对不起！您没有权限查看详情。");
		//	return;
		//}else{
		//}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
