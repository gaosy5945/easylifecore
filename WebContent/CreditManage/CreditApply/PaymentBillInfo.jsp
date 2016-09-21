<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe: ���֧���嵥��Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
		Output Param:
		HistoryLog:gftang ��DW��ΪOW,������ҳ���ȡ
	 */
	String PG_TITLE = "���֧���嵥��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
	String sPutoutSerialNo    = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sSerialNo    = CurPage.getParameter("SerialNo");
// 	��������
	String sPurpose ="",sBusinessSum="",sPaymentMode="",sBusinessCurrency="",customerID="",customerName="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_PUTOUT" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", sPutoutSerialNo).getSingleResult(false);
	if(bo!=null){
		sPurpose =bo.getAttribute("Purpose").getString();
		double dBusinessSum = bo.getAttribute("BusinessSum").getDouble();
		sBusinessSum=String.valueOf(dBusinessSum);
		sPaymentMode=bo.getAttribute("PaymentMode").getString();
		sBusinessCurrency=bo.getAttribute("BusinessCurrency").getString();
		customerID=bo.getAttribute("CustomerID").getString();
		customerName=bo.getAttribute("CustomerName").getString();
	}
	if(sSerialNo == null ) sSerialNo = ""; 
	if(sObjectType == null) sObjectType = "";
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sPaymentMode == null) sPaymentMode = ""; 
    if(sPurpose == null) sPurpose = ""; 
    
    if(customerID == null) customerID = "";
    if(customerName == null) customerName = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PaymentBillInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
  	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if (!ValidityCheck()){
			return;
		}else{
			if(bIsInsert){
				beforeInsert();
			}else
				beforeUpdate();		
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/PaymentBillList.jsp","_self","");
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//��ǰ֧����ˮ��
		var sPICurrency = getItemValue(0,getRow(),"Currency");//��ǰ֧��ҳ��ı���
		var sBPCurrency = "<%=sBusinessCurrency%>";//��ǰ�Ŵ�ҳ��ı���

		var currentPaymentSum = getItemValue(0,getRow(),"PaymentSum");//��ȡ��ǰҳ���֧�����
		var sReturn = RunMethod("BusinessManage","ChangeToRMB",currentPaymentSum+","+sPICurrency);
		currentPaymentSum = parseFloat(sReturn);
		
		paymentSum1 = RunMethod("BusinessManage","GetCurrentPaymentSum",sSerialNo);//��ȡ��ǰ֧����ˮ�Ŷ�Ӧ��֧�����
		if(paymentSum1>0){
			paymentSum1 = paymentSum1;//����ҳ��
		}else{
			paymentSum1 = 0;//����ҳ��
		}
				
		sParaString = "<%=sPutoutSerialNo%>"+","+"<%=sObjectType%>";		
		sReturn = RunMethod("BusinessManage","GetPaymentAmount",sParaString);//��ȡ�Ѿ������֧�����
		var paymentSum = parseFloat(sReturn);//
		
		sReturn = RunMethod("BusinessManage","ChangeToRMB","<%=sBusinessSum%>"+","+sBPCurrency);
		var putoutSum = parseFloat(sReturn);//��ȡ�Ŵ����
		if((paymentSum+currentPaymentSum-paymentSum1)<= putoutSum){
			return true;
		}else{
			alert("֧���ܽ����ڷſ���!");
			return false;
		}
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			setItemValue(0,0,"PutoutSerialNo","<%=sPutoutSerialNo%>");
			setItemValue(0,0,"PaymentMode","<%=sPaymentMode%>");
			setItemValue(0,0,"CapitalUse","<%=sPurpose%>");
			setItemValue(0,0,"CustomerID","<%=customerID%>");
			setItemValue(0,0,"CustomerName","<%=customerName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			initSerialNo();
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "Payment_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>