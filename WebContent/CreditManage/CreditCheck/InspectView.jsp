<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �����鱨��
	 */
	String PG_TITLE = "�����鱨��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����鱨��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����������	
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sCustomerID = sObjectNo;

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����鱨��","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'InspectView' and IsInUse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		if (getCurTVItem().id == "010030") {
			OpenComp("MemorabiliaList","/CustomerManage/EntManage/MemorabiliaList.jsp","CustomerID=<%=sCustomerID%>","right");
		}else if (getCurTVItem().id == "010040") {
			OpenComp("AutoRiskSignalInfo","/CreditManage/CreditPutOut/AutoRiskSignalInfo.jsp","CustomerID=<%=sCustomerID%>","right");
		}else if (getCurTVItem().id == "020") { //�����鱨��ժҪ			
			OpenPage("/CreditManage/CreditCheck/PrintInspectResume.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}else if (getCurTVItem().id == "030") { //�����鱨������			
			OpenPage("/CreditManage/CreditCheck/InspectFrame.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}else if (getCurTVItem().id == "040") { //�����鱨����˱�
			OpenPage("/CreditManage/CreditCheck/PrintInspectSheet.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}else if (getCurTVItem().id == "050") {
			OpenComp("SumInspectInfo","/CreditManage/CreditCheck/SumInspectInfo.jsp","SerialNo=<%=sSerialNo%>","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');		
</script>
<%@ include file="/IncludeEnd.jsp"%>