<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@page import="com.amarsoft.app.base.config.impl.TransactionConfig"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xjzhao 2015/11/17
		Tester:
		Content: ��������
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String serialNo =CurPage.getParameter("SerialNo");//������ˮ��
	
	BusinessObjectManager bom = new BusinessObjectManager();
	BusinessObject bo = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction,"SerialNo",serialNo);
	if(bo == null)  throw new Exception("���ײ����ڣ�");
	String transCode = bo.getString("TransCode");
	String transStatus = bo.getString("TransStatus");
	String relaObjectType = bo.getString("RelativeObjectType");
	String relaObjectNo = bo.getString("RelativeObjectNo");
	String documentNo = bo.getString("DocumentNo");
	String documentType = bo.getString("DocumentType");
	//ģ�壬�������ͣ���������ʹ����
	BusinessObject templete = TransactionConfig.getTransactionConfig(transCode);
	String templeteNo=templete.getString("ViewTempletNo");
	String tranType=templete.getString("Type");
	
	String businessDate = DateHelper.getBusinessDate();
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", documentType);
	inputParameter.setAttributeValue("ObjectNo", documentNo);
	inputParameter.setAttributeValue("TransactionSerialNo", serialNo);
	
	//ͨ����ʾģ�����ASObjectModel����doTemp
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templeteNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	DefaultObjectWindowController dwcontroller = new DefaultObjectWindowController();
	dwcontroller.initDataWindow(dwTemp,bom.keyLoadBusinessObject(relaObjectType, relaObjectNo));
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLObjectWindow
	dwTemp.genHTMLObjectWindow(serialNo);
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","All","Button","����","���潻����Ϣ","saveRecord('afterSave()')",""},
		{"false","All","Button","����ƻ�����","����ƻ�����","viewConsult()",""},
	};
	if(("2002".equals(transCode) )  && !"1".equals(transStatus)){
		sButtons[1][0] = "true";
	}
	%> 
<%/*~END~*/%>


<%@include file="/Frame/resources/include/ui/include_info.jspf"%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���ݱ���;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(!beforeSave()) return;  //����У�����
		as_save(sPostEvents);
	}
	
	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	
	/*~[Describe=���ÿ�ֵ;InputParam=�����¼�;OutPutParam=��;]~*/
	function setValue(colName,Value)
	{
		var sColName = getItemValue(0,getRow(),colName);
		if(typeof(sColName) == "undefined" || sColName.length == 0)
		{
			setItemValue(0,getRow(),colName,Value);
		}
	}
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<%
	/*ͨ�������ļ���ȡÿ�����׶�Ӧ�Ĳ�ͬ��JS�ļ�--JSFile*/
	String jsfile=TransactionConfig.getTransactionConfig(transCode, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
		String[] s=jsfile.split("@");
		for(String s1:s){
%>
<script type="text/javascript" src="<%=sWebRootPath+s1%>">  </script>
<%		}
	}
	else{
%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/transaction/transaction.js"> </script>
<%		
	}
	%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>

<script language=javascript>	
	var bFreeFormMultiCol = true;
	var bCheckBeforeUnload = false;
	var businessDate = "<%=businessDate%>";
	var curUserID = "<%=CurUser.getUserID()%>";
	var curUserName = "<%=CurUser.getUserName()%>";
	var curOrgID = "<%=CurOrg.getOrgID()%>";
	var curOrgName = "<%=CurOrg.getOrgName()%>";
	var documentType = "<%=documentType%>";
	var documentNo = "<%=documentNo%>";
	var transactionSerialNo = "<%=serialNo%>";
	var relaObjectNo = "<%=relaObjectNo%>";
	var relaObjectType = "<%=relaObjectType%>";
	var objectType = "<%=documentType%>";
	var objectNo = "<%=documentNo%>";
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>