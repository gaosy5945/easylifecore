<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sFlowSerialNo = CurPage.getParameter("FlowSerialNo");
	String sTaskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flag = CurPage.getParameter("Flag");
	if(sSerialNo == null) sSerialNo = "";
	if(sFlowSerialNo == null) sFlowSerialNo = "";
	if(sTaskSerialNo == null) sTaskSerialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("ClassifyDuebillList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("FlowSerialNo",sFlowSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var duebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(duebillSerialNo)=="undefined" || duebillSerialNo.length==0) return;
		if("<%=flag%>" =="RiskWarning"){
			AsControl.OpenComp("/BusinessManage/RiskWarningManage/RiskWarningManageInfo.jsp","SerialNo="+duebillSerialNo,"rightdown","");
		}else if("<%=flag%>" =="CLColl"){
			AsControl.OpenComp("/CreditManage/Collection/CLCollTaskInfo.jsp","ObjectNo="+duebillSerialNo+"&ObjectType=jbo.app.BUSINESS_DUEBILL","rightdown","");
		}else
			AsControl.OpenComp("/CreditManage/AfterBusiness/DuebillInfo.jsp","DuebillSerialNo="+duebillSerialNo,"rightdown","");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
