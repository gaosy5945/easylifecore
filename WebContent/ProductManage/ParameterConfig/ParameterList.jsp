<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>

 <%
	/*
		ҳ��˵��: ��Ʒ�����б�ҳ��
	 */
	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	String PG_TITLE = "��Ʒ�����б�";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("PRD_ParameterList", BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","��������","��������","add()","","","","",""},
			{"true","","Button","�༭����","�༭����","edit()","","","","",""},
			{"true","","Button","ɾ������","ɾ������","if(confirm('ȷʵҪɾ����?'))ALSObjectWindowFunctions.deleteSelectRow(0)","","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*~[Describe=�����¼�;InputParam=��;OutPutParam=��;]~*/%>
	function mySelectRow(){
		var parameterID = getItemValue(0,getRow(),"ParameterID");
		if(typeof(parameterID)=="undefined" || parameterID.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","frameright","");
		}else{
			AsControl.OpenView("/ProductManage/ParameterConfig/ParameterInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ParameterID='"+parameterID+"'&Keys=<%=keys%>&RightType=ReadOnly","frameright","");
		}
	} 
	
	function add(){
		AsControl.OpenView("/ProductManage/ParameterConfig/ParameterInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ParameterID=''&Keys=<%=keys%>&RightType=All","frameright",""); 
	}
	
	function edit(){
		var parameterID = getItemValue(0,getRow(0),"parameterID");
		if(typeof(parameterID)=="undefined" || parameterID.length==0){
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","frameright","");
		}else{
			AsControl.OpenView("/ProductManage/ParameterConfig/ParameterInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ParameterID='"+parameterID+"'&Keys=<%=keys%>&RightType=All","frameright",""); 
		}
	}
</script>	
<%@include file="/Frame/resources/include/include_end.jspf"%>