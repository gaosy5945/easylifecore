<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "ҵ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ����Ϣ����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//���ɱ���������Sql���
	String sSql = "select SortNo,ItemName,ItemNo from CODE_LIBRARY where CodeNo= 'BusinessAlert' Order By SortNo";
	ASResultSet rs=Sqlca.getASResultSet(sSql);
	String sSortNo="";
	String sItemName="";
	String sItemNo="";
	while(rs.next()){
		sSortNo = rs.getString("SortNo");
		sItemName = rs.getString("ItemName");
		sItemNo = rs.getString("ItemNo");
		sSql = "select count(*) from WORK_REMIND  where RemindType=:RemindType and InputUserID=:InputUserID";
		ASResultSet rs1=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RemindType",sSortNo).setParameter("InputUserID",CurUser.getUserID()));
		rs1.next();
		sItemName += "("+rs1.getInt(1)+")��"; 
		rs1.getStatement().close();
		tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
	}
	rs.getStatement().close();
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemNo = getCurTVItem().value;
		if(sCurItemNo != "root"){
			OpenComp("BusinessAlertList","/DeskTop/BusinessAlertList.jsp","RemindType="+sCurItemNo,"right");
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>