<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="net.sf.json.*"%>
<%@page import="com.amarsoft.app.base.config.impl.*"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String phaseNo = CurPage.getParameter("PhaseNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String flowNo = Sqlca.getString(new SqlObject("select FlowNo from flow_instance where serialno = :SerialNo").setParameter("SerialNo", flowSerialNo));
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String checkListName = CurPage.getParameter("CheckListName");

	BusinessObject checkList = CreditCheckConfig.getCheckList(flowNo, phaseNo, checkListName);
	Map<String,String> parametersMap = new HashMap<String,String>();
	parametersMap.put("flowSerialNo", flowSerialNo);
	parametersMap.put("orgname", CurUser.getOrgName());
	Map<String,String> checkListParameters = CreditCheckConfig.getCheckListParameters(checkList, Sqlca, parametersMap);
	
	String sTempletNo = "CreditTelCheckList";
	String jsonData = CreditCheckConfig.getCreditTelCheckListJsonData(checkList,checkListParameters,Sqlca);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(sTempletNo, BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setDataQueryClass("com.amarsoft.awe.dw.ui.htmlfactory.imp.JsonListHtmlGenerator");
	dwTemp.Style = "1";//freeform
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(jsonData);
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
// 			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��ʼ�˲�","��ʼ�绰�˲�","startCheck()","","","","",""},
			{"true","","Button","�˲��¼","�鿴�˲��¼","viewCheck()","","","","btn_icon_detail",""},

		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
    //���ݹ�ѡ�ĺ˲�����к˲�
	function startCheck(){
		var rows=getCheckedRows(0);

		if(typeof(rows)=="undefined" || rows.length==0) {
			alert("��ѡ���¼��");
			return;
		}
		var checkTypes = "";
		for(var i=0;i<rows.length;i++){
			checkTypes+="@"+getItemValue(0,rows[i],"CheckType");
		}
		
		var params = "ObjectType=jbo.flow.FLOW_OBJECT&ObjectNo=<%=objectNo%>&FlowSerialNo=<%=flowSerialNo%>&TaskSerialNo=<%=taskSerialNo%>&PhaseNo=<%=phaseNo%>&CheckListName=TelCheck&checkTypes="+checkTypes;
		AsControl.OpenPage("/CreditManage/CreditApprove/TelCheck.jsp",params,"_self","");
	}
	
	//�鿴�Ѿ�����ĺ˲��¼
	function viewCheck(){
		var ObjectType = "<%=objectType%>";
		var ObjectNo = "<%=objectNo%>";
		var FlowNo = "<%=flowNo%>";
		var PhaseNo = "<%=phaseNo%>";
		var checkListName = "<%=checkListName%>";
		var ViewCheckGroupIds = RunJavaMethodSqlca("com.amarsoft.app.als.credit.approve.action.FlowCheckListManager","getCheckGroupIdsSavedInCheckList","ObjectType="+ ObjectType + ",ObjectNo=" + ObjectNo + ",FlowNo=" + FlowNo +",PhaseNo=" + PhaseNo +",checkListName=" + checkListName);
		if(typeof(ViewCheckGroupIds)==undefined || ViewCheckGroupIds.length == 0 ){
			alert("�ÿͻ���δ�����κε绰�˲飡");
			return;
		}
		//��ȡ���ݿ����Ѿ��洢�ĺ˲���
		var params = "ObjectType=jbo.flow.FLOW_OBJECT&ObjectNo=<%=objectNo%>&FlowSerialNo=<%=flowSerialNo%>&TaskSerialNo=<%=taskSerialNo%>&PhaseNo=<%=phaseNo%>&RightType=ReadOnly&CheckListName=TelCheck&checkTypes="+ViewCheckGroupIds;
		AsControl.OpenPage("/CreditManage/CreditApprove/TelCheck.jsp",params,"_self","");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
