<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String RightType = CurPage.getParameter("RightType");
	if(RightType==null) RightType="All";
	ASObjectModel doTemp = new ASObjectModel("CollRepaymentList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CollectionTaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"ReadOnly".equals(RightType)?"false":"true","","Button","新增一行","新增一行","add()","","","","",""},
			{"ReadOnly".equals(RightType)?"false":"true","","Button","删除一行","删除一行","if(confirm('确实要删除吗?'))as_delete(0)","","","","",""},
			{"ReadOnly".equals(RightType)?"false":"true","","Button","提交","提交","dosave()","","","","",""},
			{"ReadOnly".equals(RightType)?"false":"true","","Button","取消","取消","cancel()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		as_add("myiframe0");
		setItemValue(0, getRow(0), "ObjectType", "jbo.acct.ACCT_LOAN");
		setItemValue(0, getRow(0), "ObjectNo", "<%=objectNo%>");
		setItemValue(0, getRow(0), "CollectionTaskSerialNo", "<%=taskSerialNo%>");
		setItemValue(0, getRow(0),"InputDate", "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		setItemValue(0, getRow(0), "InputUserID", "<%=CurUser.getUserID()%>");
		setItemValue(0, getRow(0), "InputOrgID", "<%=CurUser.getOrgID()%>");
		setItemValue(0, getRow(0), "Status", "1");
	}
	function cancel(){
		setItemValue(0, getRow(0), "REPAYAMOUNT", "");
		setItemValue(0, getRow(0), "REPAYDATE", "");
	}
	
	function getSum(){
		var RePayAmount=getItemValue(0,getRow(),"REPAYAMOUNT");
		if(parseInt(RePayAmount)<=0){
			alert("承诺还款金额应大于0");
			setItemValue(0, getRow(0), "REPAYAMOUNT", "");
			return;
		}
	}
	function dosave(){
		getSum();
		as_save(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
