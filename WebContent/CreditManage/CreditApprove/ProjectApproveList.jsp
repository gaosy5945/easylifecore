<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String projectSerialNo = CurPage.getParameter("ProjectSerialNo");
    if(projectSerialNo == null) projectSerialNo = "";
    String tempno = "ProjectApproveList";
    ASObjectModel doTemp = new ASObjectModel(tempno);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("PROJECTSERIALNO", projectSerialNo);
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
		var phaseNo = getItemValue(0,getRow(),"PHASENO");
		var flowNo = getItemValue(0,getRow(),"FLOWNO");
		var flowVersion = getItemValue(0,getRow(),"FLOWVERSION");
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.PopView("/CreditManage/CreditApprove/ProjectApproveInfo.jsp", "FlowSerialNo="+flowSerialNo+"&TaskSerialNo="+taskSerialNo+"&RightType=ReadOnly");
		//AsCredit.openFunction("SignTApproveInfo","FlowNo="+flowNo+"&FlowVersion="+flowVersion+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&RightType=ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
