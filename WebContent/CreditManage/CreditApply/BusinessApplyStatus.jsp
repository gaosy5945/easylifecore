<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String approveStatus = CurPage.getParameter("ApproveStatus");
	ASObjectModel doTemp = new ASObjectModel("BusinessApplyStatus");
	if("04".equals(approveStatus)){
		doTemp.setJboWhere("O.APPROVESTATUS in ('04','06') and O.OperateUserID = :UserID ");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.setParameter("ApproveStatus", approveStatus);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		{"false","All","Button","����","����","add()","","","","",""},
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","edit()","","","","",""},
		{"false","All","Button","�Ƴ�","ȡ������","cancel()","","","","",""},
		{"false","All","Button","��ӡ�������","��ӡ�������","opinion()","","","","",""},
		{"false","All","Button","�������","�������","opinionLast()","","","","",""},
	};
	if("04".equals(approveStatus))
	{
		sButtons[0][0] = "true";
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
	}
	if("05".equals(approveStatus))
	{
		sButtons[2][0] = "true";
	}
	if("03".equals(approveStatus))
	{
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function opinionLast(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		AsCredit.openFunction("LastApproveInfo","ApplySerialNo="+serialNo+"&RightType=ReadOnly","");
	}
	function opinion(){
		var BusinessType = getItemValue(0,getRow(0),'BusinessType');
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("������ƷΪ�գ�");//������Ʒ����Ϊ�գ�
			return;
		} 
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+serialNo);//������������������
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+serialNo,"_blank");//��Ӫ��������������
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+serialNo,"_blank");//�������Ŷ�ȴ������������
		}
		
	}
	function add(){
		var serialNo = getItemValue(0,getRow(),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var approveStatus = getItemValue(0, getRow(), "ApproveStatus");
		if(approveStatus == "06"){
			alert("�ñʴ����ѷ�������飡");
			return;
		}
			
		var isStopApprove = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CheckStopApprove","isStopApprove","applySerialNo="+serialNo);
		if(isStopApprove == "1"){
			alert("���ʴ���������飡");
			return;
		}
		
		var CONTRACTARTIFICIALNO = getItemValue(0, getRow(), "CONTRACTARTIFICIALNO");
		var returnValue = PopPage("/CreditManage/CreditApply/BusinessApplyStatusInfo.jsp?SerialNo="+serialNo,"","dialogWidth:550px;dialogHeight:240px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == "false") return;
		if(!confirm("�Ƿ�ȷ������ͬ���Ϊ "+CONTRACTARTIFICIALNO+" �Ĵ�����飿")) return;
		var orgID = "<%=CurUser.getOrgID()%>";
		var userID = "<%=CurUser.getUserID()%>";
		var objectType = "jbo.app.BUSINESS_APPLY";
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.ResderationInfo", "addUser", "SerialNo="+serialNo);
		var SerialNo = returnValue1.split("@")[1];
		var returnValue2 = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.Resderation","run","ApplySerialNo="+SerialNo+",OldApplySerialNo="+serialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		
		alert(returnValue2.split("@")[6]);
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ҳ��
		AsCredit.openFunction("ApplyMessageInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY&RightType=ReadOnly","");
	}
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancel(){
		var objectType = "jbo.app.BUSINESS_APPLY";
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.QueryFlowContext","run","ObjectType="+objectType+",ObjectNo="+serialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		
		var flowSerialNo = "";
		if(returnValue.split("@")[0] == "true"){
			flowSerialNo = returnValue.split("@")[3];
		}
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert("���������⣬�޷��Ƴ���");//��ѡ��һ����Ϣ��
			return;
		}
		if(!confirm("ȷ��ȡ�����룿")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.DeleteInstance","run","FlowSerialNo="+flowSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "true")
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
