<%@page import="com.amarsoft.app.lending.bizlets.CheckBankRoleHandler"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo==null) sObjectNo = "";
	if(sObjectType==null) sObjectType = "";
	
	ASObjectModel doTemp = new ASObjectModel("OperateTypeInfo","");
	String isExistFlag = CheckBankRoleHandler.isExistLeadRole(sObjectNo,sObjectType);
	if("TRUE".equals(isExistFlag) && "".equals(sSerialNo)){
		//doTemp.setDDDWCodeTable("ProviderRole","02,������,03,������");
		doTemp.setColumnAttribute("ProviderRole","ColEditSourceType","JBO");
		doTemp.setColumnAttribute("ProviderRole","ColEditSource","jbo.sys.CODE_LIBRARY,itemno,itemname,codeno='BankRole' and itemno <>'01'");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	/* if(sObjectType!="CreditApply")
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д */
    
	dwTemp.genHTMLObjectWindow(sSerialNo);
    String sButtons[][] = {
		{"true","All","Button","����","����","saveRecord()","","","",""},
		{"true","All","Button","����","","top.close()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%> 
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrgID(){
		sParaString = "OrgID,<%=CurUser.getRelativeOrgID()%>,ObjectNo,<%=sObjectNo%>,ObjectType,<%=sObjectType%>";
		//Ŀǰȫ��ѡ��Ϊ�����л���
		setObjectValue("SelectOperateOrg",sParaString,"@ProviderNo@0@ProviderName@1",0,0,"");
	}	
	
	function initRow(){		
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),'ObjectType',"<%=sObjectType%>");
			setItemValue(0,getRow(),'ObjectNo',"<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	initRow();	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>