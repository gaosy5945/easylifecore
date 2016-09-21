<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Content: 授权管理主界面
 	*/
	String PG_TITLE = "授权管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授权管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授权管理","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数
	/*
	String sFolder = tviTemp.insertFolder("root","授权方案配置","",1);
	tviTemp.insertPage(sFolder,"授权方案组配置","",11);
	tviTemp.insertPage(sFolder,"授权方案配置","",12);
	tviTemp.insertPage("01","root","授权方案配置","","",1);
	*/
  	tviTemp.insertFolder("01","root","授权方案配置","","",1);
	tviTemp.insertPage("0101","01","授权方案配置","","",11);
	tviTemp.insertPage("0102","01","授权方案配置","","",12); 
	
	tviTemp.insertPage("02","root","授权参数定义","","",2); 
	
	tviTemp.insertFolder("03","root","授权模型配置","","",3);
	tviTemp.insertPage("0301","03","授信审批","","",31);
	tviTemp.insertFolder("04","root","授权人员配置","","",4);
	tviTemp.insertPage("0401","04","授信审批","","",41);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
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
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');
	selectItemByName('授权方案配置');	//默认打开的(叶子)选项
</script>
<%@ include file="/IncludeEnd.jsp"%>