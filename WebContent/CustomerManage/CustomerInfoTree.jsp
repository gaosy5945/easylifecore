<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�ͻ�����"; //-- ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //--Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//--Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//--Ĭ�ϵ�treeview����
	//�������
	String sSql = "";	//--���sql���
	String sItemAttribute = "",sItemDescribe = "",sAttribute3 = "";//--�ͻ�����	
	String sCustomerType = "";//--�ͻ�����	
	String sTreeViewTemplet = "";//--���custmerviewҳ����ͼ��CodeNo
	ASResultSet rs = null;//--��Ž����
	int iCount = 0;//��¼��
	String sBelongGroupID = "";//�������ſͻ�ID
	//����������	,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//ÿ���ͻ������鿴���ԵĿͻ�ʱ�������������CUSTOMER_INFO��CUSTOMER_BELONG��CustomerID,�Լ�CUSTOMER_BELONG��UserID�����пͻ�������ɫ����Աֻ���������׶ο��Բ鿴��ǰ�ͻ�����Ϣ��������������ǲ����Բ鿴�ġ�
	//�ǿͻ�������λ����Ա���ӿͻ�������Ϣ���в�ѯ�����������������������е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��		
	sSql =  " select sortno||'%' from ORG_INFO where orgid=:orgid ";
	String sSortNo = Sqlca.getString(new SqlObject(sSql).setParameter("orgid",CurUser.getOrgID()));
	sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
			" where CustomerID = :CustomerID "+
			" and OrgID in (select orgid from ORG_INFO where sortno like :SortNo) "+
			" and (BelongAttribute1 = '1' "+
			" or BelongAttribute2 = '1')";

	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("SortNo",sSortNo));
	if(rs.next())
		iCount = rs.getInt(1);
	//�رս����
	rs.getStatement().close();
	
	//����û�û���������Ȩ�ޣ��������Ӧ����ʾ
	if( iCount  <= 0){
%>
		<script type="text/javascript">
			//�û����߱���ǰ�ͻ��鿴Ȩ
			alert( getHtmlMessage("15"));				
		    self.close();
		</script>
<%
	return;//tabҳ���޷�ʹ��self.close()�رգ�����return��
	}
	
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,BelongGroupID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		//����Ǽ��ų�Ա����ȡ���������ſͻ�ID add by jgao1 2009-11-03
		sBelongGroupID  = rs.getString("BelongGroupID");
	}
	rs.getStatement().close();
	
	if(sCustomerType == null) sCustomerType = "";
	if(sBelongGroupID == null) sBelongGroupID = "";

	//ȡ����ͼģ������	
	sSql = " select ItemDescribe,ItemAttribute,Attribute2,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	if(rs.next()){
		sItemDescribe = DataConvert.toString(rs.getString("ItemDescribe"));		//�ͻ�������ͼ����		
	}
	rs.getStatement().close(); 
	
	sTreeViewTemplet = sItemDescribe;		//��˾�ͻ�������ͼ����
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ͻ���Ϣ����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1' ";
	//����ǷǼ��ų�Ա�ͻ������˵��������Žڵ� add by jgao1 2009-11-3,��Թ�˾�ͻ�����
	if(sCustomerType.substring(0,2).equals("01") && sBelongGroupID.equals("")){
		sSqlTreeView += " and ItemNo <> '010055'";//������ҵ����С��ҵ010055��������������Ϣ
	}
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%>
<html>
<head>
<title>�ͻ�����</title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body style="overflow: hidden;width:100%;height:100%;margin:0;">
		<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
</body>
</html>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"frameright");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		var sCurItemName = getCurTVItem().name;//--�����ͼ�Ľڵ�����
		var sCurItemDescribe = getCurTVItem().value;//--��������¸�ҳ���·������صĲ���

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--��������¸�ҳ���·��
		sCurItemDescribe2=sCurItemDescribe[1];//--����¸�ҳ��ĵ�ҳ������
		sCurItemDescribe3=sCurItemDescribe[2];//--����û��
		sCurItemDescribe4=sCurItemDescribe[3];//--����û��
		sCustomerID = "<%=sCustomerID%>";//--��ÿͻ�����

		var sGroupID="<%=sBelongGroupID%>";
		if(sCurItemDescribe2 == "Back"){
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root" && sCurItemDescribe1 != "")  //modified by yzheng 2013-7-3 ���ڵ㲻��Ӧ�¼�����IE
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ModelType="+sCurItemDescribe4+"&ObjectNo="+sCustomerID+"&ComponentName="+sCurItemName+"&CustomerID="+sCustomerID+"&ObjectType=Customer&NoteType="+sCurItemDescribe3+"&GroupID="+sGroupID);
			//setTitle(getCurTVItem().name);
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	var sCustomerType = "<%=sCustomerType%>";

	//����ͻ�����Ϊ���ſͻ������Զ����"010"��Ŀ��������Ǽ��ſͻ������Զ�չ��"010"�ڵ� add by cbsu 2009-10-21
	var sGroupType = sCustomerType.substring(0,2);
	if (sGroupType != '02') {
		expandNode('010');
	} else {
	    selectItem('010');
	}
	
	if(sCustomerType != '0120'){
		selectItem('010010');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	}else{
		selectItem('010005');//��С��ҵ�� �Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>