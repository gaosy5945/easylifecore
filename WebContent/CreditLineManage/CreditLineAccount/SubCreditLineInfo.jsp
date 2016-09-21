<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%@
 page import="com.amarsoft.are.jbo.BizObject"%><%@
 page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%><%
	/*
		ҳ��˵��: ��ȷ��������Ϣҳ��
	 */
	String PG_TITLE = "��ȷ��������Ϣ";
	//���ҳ�����	
	String sObjectNo=CurPage.getParameter("ObjectNo"); //���������
	String sObjectType=CurPage.getParameter("ObjectType"); //�����������
	String sSerialNo=CurPage.getParameter("SerialNo");  //�����ȱ��
	if(sSerialNo==null) sSerialNo="";

	ASObjectModel doTemp = new ASObjectModel("ClDivideInfo");
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	BizObject biz = creditObjectAction.creditObject;
	String sBusinessCurrency=biz.getAttribute("BusinessCurrency").getString();		
	String sCycleFlag=biz.getAttribute("CycleFlag").getString();//cjyu �Ƿ�ѭ��
 	if("2".equals(sCycleFlag)){
		doTemp.setReadOnly("CycleFlag",true);
		doTemp.setDefaultValue("CycleFlag","2");

	} 
	doTemp.setDefaultValue("ObjectNo",sObjectNo);
	doTemp.setDefaultValue("ObjectType",creditObjectAction.getRealCreditObjectType());  //modified by yzheng 2013-6-25
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly="1";
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurPage.getParameter("RightType").equals("ReadOnly")?"false":"true"),"","Button","����","���������޸�","saveRecord()",""},
		{"true","","Button","����","���ص���ȷ����б�","goBack()",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		
	    beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack(){
		OpenPage("/CreditLineManage/CreditLineAccount/SubCreditLineList.jsp","_self","");
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"SerialNo",getSerialNo("CL_DIVIDE","SerialNo"));
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~modify by hwang 20090617,�޸�ҵ������ѡ����ͼ �������Ŷ�ȷ��������Ӷ��ʱ��ҵ��Ʒ�ֿ���ѡ�������ʽ���Ʊ�����ʵȡ�����~*/
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectDivideName(){
		var customerType="<%=creditObjectAction.getCustomerType()%>";
		sBusinessTypeInfo = AsControl.PopView("/Common/ToolsA/BusinessTypeSelect.jsp","CustomerType=<%=creditObjectAction.getCustomerType()%>&Status=<%=creditObjectAction.getCustomerType()%>","dialogWidth=600px;dialogHeight=500px;center:yes;status:no;statusbar:no");
		//alert(sBusinessTypeInfo);
		
		if(typeof(sBusinessTypeInfo) != "undefined" && sBusinessTypeInfo != ""){
			sBusinessTypeInfo = sBusinessTypeInfo.split('@');
			sBusinessTypeValue = sBusinessTypeInfo[0];//-- ����
			sBusinessTypeName = sBusinessTypeInfo[1];//--����
			setItemValue(0,getRow(),"DivideCode",sBusinessTypeValue);
			setItemValue(0,getRow(),"DivideName",sBusinessTypeName);				
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}		
    }
	
	initRow();	
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>