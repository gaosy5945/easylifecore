<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>

 <%
 
 	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	String PG_TITLE = "��Ʒ�ͺŲ���";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("XMLMerchandiseList", BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","����Ʒ��","����Ʒ��","ALSObjectWindowFunctions.addRow(0)","","","","",""},
			{"true","","Button","����Ʒ��","����Ʒ��","as_save()","","","","",""},
			{"true","","Button","ɾ��Ʒ��","ɾ��Ʒ��","if(confirm('ȷʵҪɾ����?'))ALSObjectWindowFunctions.deleteSelectRow(0)","","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var parameterID = getItemValue(0,getRow(),"ID");
		if(typeof(parameterID)=="undefined" || parameterID.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","frameright","");
		}else{
			AsControl.OpenView("/MerchandiseManage/XMLMerchandiseModelList.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ID='"+parameterID+"'//merchandise&Keys=<%=keys%>&RightType=All","frameright","");
		}
	} 
</script>	
<%@include file="/Frame/resources/include/include_end.jspf"%>