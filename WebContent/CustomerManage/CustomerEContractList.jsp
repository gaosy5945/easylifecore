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

	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	doTemp.setDefaultValue("EFFECTDATE", DateHelper.getBusinessDate());
	doTemp.setDefaultValue("STATUS", "1");
	doTemp.setDefaultValue("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","ALSObjectWindowFunctions.addRow(0,'','add()')","","","","btn_icon_add",""},
			{"true","All","Button","����","����","saveRecord()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
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
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
}
	/*~[Describe=����ѡ��;InputParam=��;OutPutParam=��;]~*/
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
