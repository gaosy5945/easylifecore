<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: ���Ʊ����Ϣ
		Input Param:
			ObjectType: �׶α��
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
			2013-05-09 jqcao �޸�Ϊģ������DataWindow
			2013-11-28 gftang �޸�ģ��ΪObjectWindow
			2014-01-23 lyin ���˽׶�����BUSINESS_PUTOUT��BILL_INFO�Ĺ���
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String contractSerialNo=CurPage.getParameter("ContractSerialNo");
	String sBusinessType = CurPage.getParameter("BusinessType");

	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(contractSerialNo==null) contractSerialNo="";
	if(sBusinessType==null) sBusinessType="";
	
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";
	String sBillType = "2";//2 ���У������ӣ��жһ�Ʊ���� 3 ��ҵ�������ӣ��жһ�Ʊ����
	if("1020020".equals(sBusinessType)) sBillType="3";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASObjectModel doTemp = new ASObjectModel("RelativeBillList","");
	//����datawindow
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.genHTMLObjectWindow( sObjectNo + "," + sObjectType);

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","����","����Ʊ����Ϣ","newRecord()","","","",""},
			{"true","","Button","����","�鿴Ʊ������","viewAndEdit()","","","",""},
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","ɾ��","ɾ��Ʊ����Ϣ","deleteRecord()","","","",""},
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","����Ʊ��","����Ʊ����Ϣ","importBill()","","","",""},//���гжһ�Ʊû�е���Ʊ�ݵĹ���
			{sObjectType.equals("PutOutApply")?"false":"true","All","Button","����Ʊ��","����Ʊ����Ϣ","copyBill()","","","",""},//���гжһ�Ʊû�е���Ʊ�ݵĹ���
			};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/RelativeBillInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_delete('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			OpenPage("/CreditManage/CreditApply/RelativeBillInfo.jsp?SerialNo="+sSerialNo, "_self","");	
		}
	}
	
	function importBill()
	{
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "BillType=<%=sBillType%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&clazz=jbo.import.excel.BILL_IMPORT"; //2 ���У������ӣ��жһ�Ʊ���� 3 ��ҵ�������ӣ��жһ�Ʊ����
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    if(typeof(sReturn) != "undefined" && sReturn != "")
	    {
	    	reloadSelf();
	    }
	}
	
	function importContractBill()
	{
		var sContarctSerialNo = "<%=contractSerialNo%>";
		var sPutOutNo = "<%=sObjectNo%>";
		var sParaString = "ObjectNo" + "," + sContarctSerialNo + ",PutOutNo" + "," + sPutOutNo;
		sReturn = setObjectValue("selectContractBillInfo",sParaString,"",0,0,"");
		if (typeof(sReturn) == "undefined" || sReturn.length == 0) {
		    return false;
		} else {
			var sSerialNo = sReturn.split("@")[0];
			sParaString = sPutOutNo + "," + sSerialNo + "," + 
			              "<%=StringFunction.getToday()%>" + "," + "<%=CurUser.getUserID()%>" + "," + "<%=sBusinessType%>";
		    RunMethod("BusinessManage","InsertPutoutRelative",sParaString);
		    reloadSelf();
		}
	}
	
	/*~[Describe=����Ʊ��;InputParam=��;OutPutParam=��;]~*/
	function copyBill(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		RunJavaMethod("com.amarsoft.app.als.credit.common.action.BillSingleCopy","copy","SerialNo="+sSerialNo+",ObjectNo=<%=sObjectNo%>,ObjectType=<%=sObjectType%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		UpdateBusinessSum();
		reloadSelf();
	}
	
	/*~[Describe=����������ͻ�Ʊ����;InputParam=��;OutPutParam=��;]~*/
	function UpdateBusinessSum(){
		RunJavaMethod("com.amarsoft.app.als.credit.common.action.BillAction","UpdateBusinessSum","ObjectNo=<%=sObjectNo%>,ObjectType=<%=sObjectType%>");
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
