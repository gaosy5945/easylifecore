<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String partnerType = CurPage.getParameter("PartnerType");
	
	String sTempletNo = "PartnerProjectInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	doTemp.setDefaultValue("partnerType", partnerType);
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","�ݴ�","�ݴ�","saveTemp()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	/**��������	 */
	function saveRecord(){
		setItemValue(0,0,"TempSaveFlag","0");
		as_save(0);
	}
	/*�ݴ�*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*ѡ���Ʒ��ѡ*/
	function selectProduct(){
		var returnValue = setObjectValue("SelectAllBusinessTypeMulti","","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "_CLEAR_"){
			return;
		}
		returnValue = returnValue.split("~");
		var productNo= "",productName="";
		for(var i = 0 ; i < returnValue.length -1 ; i++){
			var productValue = returnValue[i].split("@");
			productNo += productValue[0] +",";
			productName += productValue[1] +",";
		}
		setItemValue(0,0,"ProductList",productNo);
		setItemValue(0,0,"ProductListName",productName);
	}
	/*ѡ�������ѡ*/
	function selectOrg(){
		var returnValue = setObjectValue("SelectAllOrgMulti","","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "_CLEAR_"){
			return;
		}
		returnValue = returnValue.split("~");
		var orgNo= "",orgName="";
		for(var i = 0 ; i < returnValue.length -1 ; i++){
			var orgValue = returnValue[i].split("@");
			orgNo += orgValue[0] +",";
			orgName += orgValue[1] +",";
		}
		//alert(orgNo+","+orgName);
		setItemValue(0,0,"OrgList",orgNo);
		setItemValue(0,0,"OrgListName",orgName);
	}
	
	function initRow(){
		var projectType = getItemValue(0,0,"ProjectType");
		if(projectType == "07" || projectType == "08" || projectType == "09"){
			hideItem(0,"LineFlag1");
			hideItem(0,"LineFlag2");
		}
	}
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>