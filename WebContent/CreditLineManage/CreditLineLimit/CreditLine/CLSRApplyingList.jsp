<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//ASObjectModel doTemp = new ASObjectModel("CLSRApplyingList");
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	String status = CurPage.getAttribute("Status");
	if(status==null)status="";
	
	String dowhere = "";
	if(status.indexOf("@")>0){
		String [] statsList = status.split("@");
		for(int i=0;i<statsList.length;i++){
			dowhere += " O.FLOWTODOSTATUS='"+statsList[i]+"' or ";
		}
		dowhere = dowhere.substring(0, dowhere.lastIndexOf("or"));
	}else{
		dowhere += " O.FLOWTODOSTATUS='"+status+"'";
	}
	dowhere = " and ("+dowhere+")";
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("OrgID", CurUser.getOrgID());
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CLSRApplyingList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	doTemp.setJboWhere(doTemp.getJboWhere() + dowhere);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{("1".equals(status)?"true":"false"),"All","Button","�����ͣ","�����ͣ","add()","","","","",""},
			{("1".equals(status)?"true":"false"),"All","Button","��Ȼָ�","��Ȼָ�","recoverApply()","","","","",""},
			{("1".equals(status)||"2".equals(status)?"true":"false"),"All","Button","����","����","deal()","","","","",""},
			{"true","All","Button","�������","�������","view()","","","","",""},
			{("1".equals(status)?"true":"false"),"All","Button","ɾ��","ɾ��","deleteRecord()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function add(){
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		var returnValue = AsDialog.SelectGridValue("SelectCLNSList", "20,"+inputOrgID, "SerialNo@Status","", "","","","1");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("@");
		var CLSerialNo = returnValue[0];
		var preStatus = returnValue[1];
		
		var checkresult = CreditLineManage.checkCL(CLSerialNo);
		if("true"!=checkresult){
			alert("��ǰ�������;��δ��Ч�Ķ�ȵ������ף����ɽ��ж����ͣ������");
			return;
		}
		
		CreditLineManage.importCLStopApply(CLSerialNo, preStatus, inputOrgID , inputUserID,  inputDate);
		reloadSelf();
	}
	
	function deal(){
		
		var COSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		var BCSerialNo = getItemValue(0,getRow(0),"BCSERIALNO");
		
		if(typeof(COSerialNo)=="undifined"||COSerialNo.length==0){
			alert(getHtmlMessage(1));
			return;
		}
		
		AsCredit.openFunction("CLStopApplyTab","BCSerialNo="+BCSerialNo+"&COSerialNo="+COSerialNo+"&doStatus=<%=status%>");
		reloadSelf();
	}
	function recoverApply(){
		
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		var returnValue = AsDialog.SelectGridValue("SelectCLNSList", "30,"+inputOrgID, "SerialNo@Status","", "","","","1");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		
		returnValue = returnValue.split("@");
		var CLSerialNo = returnValue[0];
		var preStatus = returnValue[1];
		
		var checkresult = CreditLineManage.checkCL(CLSerialNo);
		if("true"!=checkresult){
			alert("��ǰ�������;��δ��Ч�Ķ�ȵ������ף����ɽ��ж�Ȼָ�������");
			return;
		}
		
		CreditLineManage.importCLStopApply(CLSerialNo, preStatus, inputOrgID, inputUserID, inputDate);
		reloadSelf();
	}
	
	function view(){
		var SerialNo = getItemValue(0,getRow(0),"BCSERIALNO");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("��ѡ��һ�����룡");
			return;
		}
		AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&RightType=ReadOnly");
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_delete("myiframe0");
		}
		reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
