<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��Ȩ����������
 	*/
	String PG_TITLE = "��Ȩ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ȩ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ȩ����","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����
	/*
	String sFolder = tviTemp.insertFolder("root","��Ȩ��������","",1);
	tviTemp.insertPage(sFolder,"��Ȩ����������","",11);
	tviTemp.insertPage(sFolder,"��Ȩ��������","",12);
	tviTemp.insertPage("01","root","��Ȩ��������","","",1);
	*/
  	tviTemp.insertFolder("01","root","��Ȩ��������","","",1);
	tviTemp.insertPage("0101","01","��Ȩ��������","","",11);
	tviTemp.insertPage("0102","01","��Ȩ��������","","",12); 
	
	tviTemp.insertPage("02","root","��Ȩ��������","","",2); 
	
	tviTemp.insertFolder("03","root","��Ȩģ������","","",3);
	tviTemp.insertPage("0301","03","��������","","",31);
	tviTemp.insertFolder("04","root","��Ȩ��Ա����","","",4);
	tviTemp.insertPage("0401","04","��������","","",41);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=='01'){
			OpenComp("RuleSceneGroupList","/Common/Configurator/Authorization/RuleSceneGroupList.jsp","","right");
			setTitle(sCurItemname);
		}else if(sCurItemID=='02'){
			OpenComp("DimensionList","/Common/Configurator/Authorization/DimensionList.jsp","","right");
			setTitle(sCurItemname);
		}else if(sCurItemID=='0101'){
			OpenComp("DimensionList","/Authorize/RuleInfo.jsp","","right");
		}else if(sCurItemID=='0102'){
			OpenComp("DimensionList","/Authorize/RuleList.jsp","","right");
		}else if(sCurItemID=='0301'){
			AsControl.OpenView("/Common/Configurator/Authorization/RuleSceneList.jsp","GroupID=2014051400000001","right");
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');
	selectItemByName('��Ȩ��������');	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
</script>
<%@ include file="/IncludeEnd.jsp"%>