<%@page import="com.amarsoft.app.als.image.service.ImageSevice"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.product.PRDTreeViewNodeGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   jytian  2004-12-10
			Tester:
			Content: ҵ������������
			Input Param:
		 	SerialNo��ҵ��������ˮ��
			Output param:
		      
			History Log: 
			2005.08.09 ��ҵ� ������룬ȥ��window.open�򿪷���,ɾ�����ô��룬�����߼�
			2009.06.30 hwang �޸Ķ������ҵ����ͼ��ȡ��ʽ
			2011.06.03 qfang ���������ʽ��������������ģ��
			2013.05.25 yzheng �޸���ͼ�ڵ����ɷ�ʽ, ���CreditView
			2013.06.14 yzheng �ϲ�CreditLineView
			2013.06.27 yzheng �ϲ�InputCreditView
		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ҵ������"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/
%>
	<%
		// 	//�������
	// 	String sBusinessType = "";
		String sCustomerID = "";
	 	String sOccurType = "";  //�������͡�����Զ������/����
	// 	String sApplyType="";  //�������� ������Զ������/����
	// 	String sTable="";
	 	String sCreditLineID = "";  //���ۺ����ű�š�������Ŷ������
	 	int schemeType = 0;  //���ŷ�������  0:���Ŷ������ 1: �������/������������
		
		//����������
		String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		//��ȡ������һ��ҵ��������Ƿ���Ҫ������������ͬ�׶Ρ���Զ������/��������
		String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
// 	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
// 	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
// 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
// 	if(rs.next()){ 
// 		sTable=DataConvert.toString(rs.getString("ObjectTable"));
// 	}
// 	rs.getStatement().close(); 
	
// 	sSql="select CustomerID,OccurType,ApplyType,BusinessType from "+sTable+" where SerialNo=:SerialNo";
// 	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
// 	if(rs.next()){
// 		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
// 		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
// 		sOccurType=DataConvert.toString(rs.getString("OccurType"));  //��Զ������/����
// 		sApplyType=DataConvert.toString(rs.getString("ApplyType"));  //��Զ������/����
// 	}
// 	rs.getStatement().close(); 
	
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sCustomerID = creditObjectAction.getCreditObjectBO().getAttribute("CustomerID").toString();
	sOccurType = creditObjectAction.getCreditObjectBO().getAttribute("OccurType").toString();
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	//add by qfang 2011-06-03
	//String sSqlTreeView = "";
	//BizSort bs = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	
	/**added and modified by yzheng  2013/06/19**/
	PRDTreeViewNodeGenerator nodeGen = new PRDTreeViewNodeGenerator(sApproveNeed);
	String sSqlTreeView = nodeGen.generateSQLClause(Sqlca, sObjectType, sObjectNo);
	schemeType = nodeGen.getSchemeType();
	sCreditLineID = nodeGen.getCreditLineID();

	//����������������Ϊ: ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("PRD_NODEINFO.NodeID as NodeID","PRD_NODECONFIG.NodeName as NodeName","ItemDescribe||'$'||(case when FAC5 is null then '' else FAC5 end) as ItemDescribe","","",sSqlTreeView,"Order By PRD_NODEINFO.SortNo",Sqlca);
	
	ArrayList<TreeViewItem> lst=tviTemp.Items;
	String defaultClickItemId="";
	for(TreeViewItem treeItem:lst){
		if(treeItem.getType().equalsIgnoreCase("page") && defaultClickItemId.equals("")){
			defaultClickItemId=treeItem.getId();
		}
		
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		//alert(sParameterString);
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType","<%=sObjectType%>");
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo","<%=sObjectNo%>");
		sParaStringTmp=sParaStringTmp.replace("#CustomerID","<%=sCustomerID%>");
		
		if (<%=schemeType%> == 0){  //���Ŷ������
			sParaStringTmp=sParaStringTmp.replace("#ParentLineID","<%=sCreditLineID%>");
			//sParaStringTmp=sParaStringTmp.replace("#ModelType","030");
		}
		else if(<%=schemeType%> == 1){  //�������/������������
			sParaStringTmp=sParaStringTmp.replace("#OccurType", "<%=sOccurType%>");
		}
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root" || !hasChild(sSerialNo))	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value.split("$")[0];
		var sortNo = trim(getCurTVItem().value.split("$")[1]);
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=trim(sCurItemDescribe[2]);
		
		AsCredit.imageLocate(sortNo);
		
		if(sCurItemDescribe1 == "GuarantyList"){
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1 == "LiquidForcast"){
			openChildComp("EvaluateList","/Common/Evaluate/EvaluateList.jsp","ModelType=070&ObjectType=Customer&ObjectNo=<%=sCustomerID%>&CustomerID=<%=sCustomerID%>");
		}else if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"AccountType=ALL&"+sCurItemDescribe2+"&CustomerID=<%=sCustomerID%>");
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('01');
	<%if(sObjectType.equals("CreditApply")){%>
	selectItem('011');
	<% }else if(sObjectType.equals("ApproveApply")){%>
	selectItem('012');
	<%}else{%>
	selectItem('013');
	<%}%>
	expandNode('040');
	expandNode('041');	
//	setTitle("������Ϣ");
	selectItem('<%=defaultClickItemId%>');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>