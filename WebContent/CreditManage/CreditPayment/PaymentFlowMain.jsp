<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "֧����ˮ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;֧����ˮ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
		
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"֧����ˮ","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ	
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo = 'PaymentFlowMain' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;

		/**
		PaymentStatus ֧��״̬
		000		 ������  	
		010  	������
		020		�����
		030		ʧ��
		PaymentMode ֧����ʽ
		010 	����֧��
		020		����֧��
		*/
		if(getCurTVItem().id == "02010"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=020&PaymentMode=010";
		}else if(getCurTVItem().id == "02020"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=020&PaymentMode=020";
		}else if(getCurTVItem().id == "03010"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=030&PaymentMode=010";
		}else if(getCurTVItem().id == "03020"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=030&PaymentMode=020";
		}else {
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=010";
		}	
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe3=sCurItemDescribe[2];
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"&ComponentName=PaymentFlowMain");
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');	
	//expandNode('010');
	expandNode('020');
	expandNode('030');
	selectItem('010');
</script>
<%@ include file="/IncludeEnd.jsp"%>