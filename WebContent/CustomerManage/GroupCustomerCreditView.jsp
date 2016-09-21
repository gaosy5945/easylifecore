<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "集团授信状况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;集团授信状况&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得组件参数	
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
    if(sGroupID == null) sGroupID = "";
    if(sRightType == null) sRightType = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"集团授信状况","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	tviTemp.initWithCode("GroupCustomerCreditView",Sqlca);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='集团授信信息'){
			OpenComp("GroupCreditList","/CustomerManage/GroupManage/GroupCreditList.jsp","","right");
		}else if(sCurItemname=='集团内担保信息'){
			OpenComp("GroupInnerGurantyList","/CustomerManage/GroupManage/GroupInnerGurantyList.jsp","","right");
		}else if(sCurItemname=='接收集团外客户担保信息'){
			OpenComp("GroupOuterGurantyList","/CustomerManage/GroupManage/GroupOuterGurantyList.jsp","","right");
		}else if(sCurItemname=='为集团外客户担保信息'){
			OpenComp("GroupForOuterGurantyList","/CustomerManage/GroupManage/GroupForOuterGurantyList.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	selectItemByName("集团授信信息");
</script>
<%@ include file="/IncludeEnd.jsp"%>