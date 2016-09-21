<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "履约保险保证信息"; 
	//String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null) serialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("InsuranceInfo");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	//dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),"InputDate","<%=DateHelper.getToday()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		}
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getToday()%>");
		
		as_save("0",'');
	}
	
	function init(){
		if (getRowCount(0)!=0){
			setItemDisabled(0,getRow(),"InsuranceNo",true);
		}
	}
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
