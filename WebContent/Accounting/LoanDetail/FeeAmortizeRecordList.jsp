<%@ page contentType="text/html; charset=GBK"%>
<%-- <%@ include file="/IncludeBegin.jsp"%> --%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>


	<%
	String PG_TITLE = "����̯����¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String templetFilter="1=1";
	String templetNo;
	//����������
	
	//���ҳ�����
	String sObjectNo = (String)request.getParameter("sObjectNo");
	String SerialNo =  (String)request.getParameter("SerialNo");//��ݱ��
	if(SerialNo == null)SerialNo = "";
	if(sObjectNo == null)sObjectNo = "";

	String sTemplete = "feeAmortizeRecordList";
    //ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
    ASObjectModel doTemp = new ASObjectModel(sTemplete,"");
	
	//ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);

	dwTemp.Style="1";      //����ΪFreeform���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	/* Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i)); */
	dwTemp.genHTMLObjectWindow(sObjectNo);
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
