<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<style>
	.modify_div{
		position: absolute;
		top:10px;
		right:15px;
	}
</style>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   ������  2014/11/12
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	//String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//���������SQL���
	String sSql = "";
	//�����������ʾģ�����ơ��������͡��ݴ��־
	String sDisplayTemplet = "",sOccurType = "",sTempSaveFlag = "";
	
	//���ҳ�����	
	String sObjectType = CurPage.getParameter("ObjectType");//jbo.app.BUSINESS_APPLY
	String sObjectNo = CurPage.getParameter("ObjectNo");
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	String productID = Sqlca.getString(new SqlObject("select case when ProductID is null or ProductID = ' ' then BusinessType else ProductID end from BUSINESS_APPLY where SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo));
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ProductType2 as ProductType2,ProductType3 as ProductType3 from PRD_PRODUCT_LIBRARY WHERE Status in('1','0') and ProductID=:ProductID").setParameter("ProductID", productID));
	String productType2 = "",productType3="";
	if(rs.next())
	{
		productType2 = rs.getString("ProductType2");
		productType3 = rs.getString("ProductType3");
	}
	rs.close();
	
	
	if("01".equals(productType3))
	{
		if("2".equals(productType2))
		{
			sDisplayTemplet = "ApplyCLInfo0010Report";
		}
		else
		{
			sDisplayTemplet = "ApplyInfo0020Report";
		}
	}else{
		sDisplayTemplet = "ApplyInfo0030Report";
	}
	if("500".equals(productID))
	{
		sDisplayTemplet = "ApplyRZInfo0010Report";
	}
	if("502".equals(productID))
	{
		sDisplayTemplet = "ApplyRZInfo0020Report";
	}
	if("666".equals(productID))
	{
		sDisplayTemplet = "ApplyCLInfo0020Report";
	}

	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sDisplayTemplet,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();


	dwTemp.Style="2";   

	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	%>

<%
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"false","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""}, 
		{"false","","Button","��ӡ������","��ӡ������","print()","","","",""},
	};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("0"))
		sButtons[1][0] = "false";
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<script type="text/javascript">
	function print(){
		var ContractArtificialNo = getItemValue(0, getRow(), "ContractArtificialNo");
		AsControl.PopPage("/CreditManage/CreditApply/PrintSerialNo.jsp","ObjectNo="+ContractArtificialNo,"dialogWidth:400px;dialogHeight:80px;");
	}
	//ȫ�ֱ�����JS����Ҫ
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//¼��������Ч�Լ��
		if ( !ValidityCheck() ){
			return;	
		}
		beforeUpdate();
		setItemValue(0,getRow(),"TempSaveFlag","0"); //�ݴ��־��1���ǣ�0����
		as_save();
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�0����
		as_saveTmp("myiframe0");   //�ݴ�
	}		
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateDate","<%=DateHelper.getToday()%>");					
	}
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		return true;
	}
	
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		calcExceptReason();
		calcBillMail();
		initRPT();
		initRate();
		initATT();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
