<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:UI组件导航主页面
	 */
	String PG_TITLE = "UI组件导航"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;UI组件导航&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"UI组件导航","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数
 
	String sFolder9 = tviTemp.insertFolder("root","应用案例","",1);
	tviTemp.insertPage(sFolder9,"简易向导","",1);
	tviTemp.insertPage(sFolder9,"通过模板产生INFO","",2);
	tviTemp.insertPage(sFolder9,"消息推送","",4);
	tviTemp.insertPage(sFolder9,"TreeTable","",5);
	tviTemp.insertPage(sFolder9,"额度分项树图","",6);
	tviTemp.insertPage(sFolder9,"多方案分配树","",7);
	tviTemp.insertPage(sFolder9,"DWTable","",8);
	tviTemp.insertPage(sFolder9,"在线用户","",8);
	tviTemp.insertPage(sFolder9,"代码功能视图","",9);
	
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	<%/*treeview单击选中事件;如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数*/%>
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		 if(sCurItemname=='简易向导'){
			AsControl.OpenView("/FrameCase/AppCase/WizCase.jsp","","right");
		}else  if(sCurItemname=='通过模板产生INFO'){
			AsControl.OpenView("/FrameCase/AppCase/JsonInfo.jsp","","right");
		}else  if(sCurItemname=='组件'){
			AsControl.OpenView("/FrameCase/AppCase/JsonInfo.jsp","","right");
		}else  if(sCurItemname=='消息推送'){
			AsControl.OpenView("/FrameCase/AppCase/PushMessage.jsp","","right");
		}else  if(sCurItemname=='TreeTable'){
			AsControl.OpenView("/FrameCase/AppCase/TreeTableDemo.jsp","","right");
		}else  if(sCurItemname=='额度分项树图'){
			AsControl.OpenView("/FrameCase/AppCase/TreeTableDemo2.jsp","","right");
		}else  if(sCurItemname=='多方案分配树'){
			AsControl.OpenView("/FrameCase/AppCase/TreeTableDemo3.jsp","","right");
		}else  if(sCurItemname=='DWTable'){
			AsControl.OpenView("/FrameCase/AppCase/DWTable.jsp","","right");
		}else  if(sCurItemname=='在线用户'){
			AsControl.OpenView("/Frame/page/sys/UserOnLineList.jsp","","right");
		}else  if(sCurItemname=='代码功能视图'){
			AsControl.OpenView("/AppMain/resources/widget/TreeTab.jsp","CodeNo=TreeTab","right");
		}else  if(sCurItemname=='功能点视图'){
			AsControl.OpenView("/AppMain/resources/widget/FunctionView.jsp","FunctionID=CustomerDetail&CustomerID=2014041800000001","right");
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/%>
	function initTreeVeiw(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		//selectItemByName("Border");
		//selectItemByName("典型List");
		selectItemByName("典型Info");	//默认打开的(叶子)选项
		myleft.width = 250;
	}

	initTreeVeiw();
</script>
<%@ include file="/IncludeEnd.jsp"%>