<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sContractSerialNo = CurPage.getParameter("CONTRACTSERIALNO");
	String sDocumentObjectNo = CurPage.getParameter("DOCUMENTOBJECTNO");
	//����ֵת���ɿ��ַ���
	if(sContractSerialNo == null) sContractSerialNo = "";
	if(sDocumentObjectNo == null) sDocumentObjectNo = "";

	ASObjectModel doTemp = new ASObjectModel("LimitChangeTransList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.setParameter("SerialNo", sDocumentObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		{"true","All","Button","����","������ƽ��Ľ��","importApply()","","","","",""},
		{"true","All","Button","�Ƴ�","�Ƴ�ѡ�еĴ��ƽ��Ľ��","removeApply()","","","","",""},
		{"true","All","Button","ҵ������","�鿴�������","view()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function importApply()
	{
		var result = AsDialog.SelectGridValue("SelectLimitChangeTransList", "<%=sContractSerialNo%>,<%=sDocumentObjectNo%>", "SerialNo","","","","");
		
		if(typeof(result) == "undefined" || result.length == 0 ){
			return;
		}
		
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "changeDuebillToDo", "SerialNo="+result+",ApplySerialNo=<%=sDocumentObjectNo%>,DoFlag=imported");
		if(returnValue1=="true")
		{
			alert("����ɹ���");
			
		}else{
			alert("����ʧ�ܣ�ʧ��ԭ��"+returnValue1);
		}
		reloadSelf();
	}
	
	function removeApply()
	{
		
		var serialno = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialno) == "undefined" || serialno.length == 0 ){
			return;
		}
		
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "changeDuebillToDo", "SerialNo="+serialno+",DoFlag=remove");
		if(returnValue1=="true")
		{
			alert("����ɹ���");
			
		}else{
			alert("����ʧ�ܣ�ʧ��ԭ��"+returnValue1);
		}
		reloadSelf();
	}
	
	function view()
	{
		
		var serialno = getItemValue(0,getRow(0),"ObjectNo");
		if(typeof(serialno) == "undefined" || serialno.length == 0 ){
			return;
		}
		
		AsControl.PopView("/CreditManage/AfterBusiness/DuebillInfo.jsp", "DuebillSerialNo="+serialno,"");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
