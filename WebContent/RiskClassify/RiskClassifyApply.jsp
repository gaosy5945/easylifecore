<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�ֹ�������ͼʾ��ҳ��
	 */
	String PG_TITLE = "�����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sExampleId = CurPage.getParameter("ObjectNo");

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����������","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	//ͨ��insertFolder��insertPage������ͼ                         
   tviTemp.insertPage("root","�����������","",1);
   tviTemp.insertPage("root","�϶��е�����","",2);
   tviTemp.insertPage("root","�϶�ͨ��������","",3);
   tviTemp.insertPage("root","�϶����������","",4);
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * ToInheritObj:�Ƿ񽫶����Ȩ��״̬��ر��������������
		 */
		sParaStringTmp += "ToInheritObj=y";
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="�����������"){
			openChildComp("/RiskClassify/RiskClassifyApplyList.jsp","Itemno=0010");
		}else if(sCurItemname=="�϶��е�����"){
			openChildComp("/RiskClassify/RiskClassifyApplyList1.jsp","Itemno=0020");
			return;
		}else if(sCurItemname=="�϶�ͨ��������"){
			openChildComp("/RiskClassify/RiskClassifyApplyList1.jsp","Itemno=0030");
			return;
		}else if(sCurItemname=="�϶����������"){
			openChildComp("/RiskClassify/RiskClassifyApplyList1.jsp","Itemno=0040");
			return;
		}else{}
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("������Ϣ");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>