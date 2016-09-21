<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String serialNo =  CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	//ASObjectModel doTemp = new ASObjectModel("EntCustomerEContract");
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("EntCustomerEContract", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();

	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	doTemp.setDefaultValue("EFFECTDATE", DateHelper.getBusinessDate());
	doTemp.setDefaultValue("STATUS", "1");
	doTemp.setDefaultValue("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","ALSObjectWindowFunctions.addRow(0,'','add()')","","","","btn_icon_add",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){		
		
	}
	function saveRecord()
	{
		as_save("reloadPage()");
	}
	function reloadPage(){
		reloadSelf();
	}

	function del(){
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
}
	/*~[Describe=日历选择;InputParam=无;OutPutParam=无;]~*/
	function selectIDExpiry()
	{
		var sEffectDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=250px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sEffectDate)!="undefined")
		{
			setItemValue(0,getRow(),"EFFECTDATE",sEffectDate);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
