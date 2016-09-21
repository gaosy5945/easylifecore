<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
		Author:   qzhang  2014/12/04
		Tester:
		Content: ��ͬ��ǩ��Ϣ�б�
		Input Param:	 
		Output param:
		History Log: 
	*/

	//��ȡǰ�˴���Ĳ���
    String sStatus = DataConvert.toString(CurPage.getParameter("Status"));//��ǩ״̬
    
    if(sStatus == null) sStatus = "";
    String tempNo = "";
    if("020".equals(sStatus)){
    	tempNo = "ContractInterviewList1";
    }else{
    	tempNo = "ContractInterviewList";
    }
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	if(CurUser.hasRole("PLBS0001") || CurUser.hasRole("PLBS0002"))
	{
	    doTemp.appendJboWhere(" and O.OperateUserID=:UserID ");
	}
	 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID()+","+CurUser.getUserID());

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","","Button","��ǩ����","��ǩ����","deal()","","","","",""},
			{("020".equals(sStatus)?"true":"false"),"","Button","��ǩ���","��ǩ����鿴","viewSignResult()","","","","",""},
		};
	 if("010".equals(sStatus)){
		sButtons[0][0] = "true";
	}

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function deal(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerId = getItemValue(0,getRow(),"CustomerId");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("ContractInterviewTab", "CustomerId="+sCustomerId+"&SerialNo="+sSerialNo);	
		reloadSelf();
	}
	
	function viewSignResult()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerId = getItemValue(0,getRow(),"CustomerId");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		//AsControl.OpenComp("/CreditManage/CreditContract/ContractInterviewInfo.jsp", "RightType=ReadOnly&CustomerId="+sCustomerId+"&SerialNo="+sSerialNo, "", "_blank");
		AsCredit.openFunction("ContractInterviewTab", "CustomerId="+sCustomerId+"&SerialNo="+sSerialNo+"&RightType=ReadOnly");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
