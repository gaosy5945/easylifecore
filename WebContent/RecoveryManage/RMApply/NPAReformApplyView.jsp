<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "���鷽������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���鷽��������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����������(��ˮ�š���ͼID����������)	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	String sObjectType = "NPAReformApply";
	
	//��÷�������
	String sSql = " select ApplyType from BUSINESS_APPLY where SerialNo = :SerialNo ";
   	String sApplyType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
   	//���������������ͼչ������
	String sSqlTreeView = "";
			
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"���鷽�������б�","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ	
	sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'NPAReformView' and IsInUse = '1' ";	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sObjectNo = "<%=sObjectNo%>";
		sApplyType = "<%=sApplyType%>";
		sObjectType = "<%=sObjectType%>";
		
		if(sCurItemDescribe2 == "Back"){
			self.close();
			opener.location.reload();
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ApplyType="+sApplyType+"",OpenStyle);
			setTitle(sCurItemName);
		}
	}
		
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');		
	selectItem('01');	 
</script>
<%@ include file="/IncludeEnd.jsp"%>