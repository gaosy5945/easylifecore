<%@ page contentType="text/html; charset=GBK"%>
<%-- <%@ include file="/IncludeBegin.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>


	<%
	String PG_TITLE = "���û����¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String templetFilter="1=1";
	String templetNo;
	//����������
	
	//���ҳ�����
	String objectNo = (String)CurPage.getParameter("ObjectNo");
	String objectType =  (String)CurPage.getParameter("ObjectType");//��ݱ��
	if(objectType==null) objectType="";
	if(objectNo == null) objectNo="";

	String sTemplete = "FeeRecordList";
    //ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
    ASObjectModel doTemp = new ASObjectModel(sTemplete,"");
	
	//ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪFreeform���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//��ģ��Ӧ����Datawindow
	/* Vector vTemp = dwTemp.genHTMLDataWindow(objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i)); */
    dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	String sButtons[][] = {
	};
	%> 

<%-- <%@include file="/Resources/CodeParts/List05.jsp"%> --%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>


<script language=javascript>
	
/* 	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0'); */
</script>	

<%-- <%@ include file="/IncludeEnd.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
