<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //Ĭ�ϴ򿪽ڵ�
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"֧�з���","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("SortNo","OrgName","SortNo","","","from ORG_INFO where BELONGORGID = '9800' and ORGLEVEL = '3'","Order By SortNo",Sqlca);
	String sButtons[][] = {
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
function startMenu(){
	<%=tviTemp.generateHTMLTreeView()%>
	expandNode('root');
	selectItem('<%=sDefaultNode%>');
}
	
    function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	
	<%/*[Describe=����ڵ��¼�,�鿴���޸�����;]*/%>
	function TreeViewOnClick(){
		var SortNo = getCurTVItem().value;
		if(!SortNo){
			OpenPage("/AppMain/Blank.jsp?TextToShow=��ѡ�������ͼ�ڵ�!", "frameright");
		}else if(SortNo=="root"){
		}else{
	      	OpenPage("/AppConfig/AccumulationOrgManage/AccumulationInfo.jsp?SortNo="+SortNo, "frameright"); 
		}
	}
	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>