<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��������״��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������״��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����������	
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
    if(sGroupID == null) sGroupID = "";
    if(sRightType == null) sRightType = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������״��","right");
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	tviTemp.initWithCode("GroupCustomerCreditView",Sqlca);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='����������Ϣ'){
			OpenComp("GroupCreditList","/CustomerManage/GroupManage/GroupCreditList.jsp","","right");
		}else if(sCurItemname=='�����ڵ�����Ϣ'){
			OpenComp("GroupInnerGurantyList","/CustomerManage/GroupManage/GroupInnerGurantyList.jsp","","right");
		}else if(sCurItemname=='���ռ�����ͻ�������Ϣ'){
			OpenComp("GroupOuterGurantyList","/CustomerManage/GroupManage/GroupOuterGurantyList.jsp","","right");
		}else if(sCurItemname=='Ϊ������ͻ�������Ϣ'){
			OpenComp("GroupForOuterGurantyList","/CustomerManage/GroupManage/GroupForOuterGurantyList.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	selectItemByName("����������Ϣ");
</script>
<%@ include file="/IncludeEnd.jsp"%>