<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@include file="/Frame/resources/include/include_begin_list.jspf"%>
 <script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%
	String xmlFile = CurPage.getParameter("XMLFile");
	String xmlTags = CurPage.getParameter("XMLTags");
	String keys = CurPage.getParameter("Keys");
	String PG_TITLE = "��������б�";

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("PRD_ComponentTypeList", BusinessObject.createBusinessObject(), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly="1";
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))ALSObjectWindowFunctions.deleteSelectRow(0)","","","","btn_icon_delete",""},
		};
	
%> 
<script type="text/javascript">
	function add()
	{
		AsControl.OpenView("/ProductManage/ComponentConfig/ComponentTypeInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ID=''&Keys=<%=keys%>","_self","");
	}
	
	function edit()
	{
		var id = getItemValue(0,getRow(),"ID");	//���������
	    if(typeof(id)=="undefined" || id.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    AsControl.OpenView("/ProductManage/ComponentConfig/ComponentTypeInfo.jsp","XMLFile=<%=xmlFile%>&XMLTags=<%=xmlTags%>||ID='"+id+"'&Keys=<%=keys%>","_self","");   
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>