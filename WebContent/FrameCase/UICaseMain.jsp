<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:UI组件导航主页面
	 */
	String PG_TITLE = "UI组件导航"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;UI组件导航&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	CurPage.setAttribute("HideMinButton", "true");
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"UI组件导航","right");
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sFolder10=tviTemp.insertFolder("root","基本组件","",1);
	String sFolder12=tviTemp.insertFolder(sFolder10,"Button","",2);
	tviTemp.insertPage(sFolder12,"数组定义按钮", "/FrameCase/widget/button/ExampleButtonArray.jsp","",1);
	tviTemp.insertPage(sFolder12,"硬编码按钮", "/FrameCase/widget/button/ExampleButtonHardCoding.jsp","",2);
	String sFolder13=tviTemp.insertFolder(sFolder10,"TreeView","",3);
	tviTemp.insertPage(sFolder13,"SQL生成树图", "/FrameCase/widget/treeview/ExampleView.jsp@ViewId=001","",1);
	tviTemp.insertPage(sFolder13,"代码生成树图", "/FrameCase/widget/treeview/ExampleView01.jsp@ViewId=001","",2);
	tviTemp.insertPage(sFolder13,"手工生成树图", "/FrameCase/widget/treeview/ExampleView02.jsp@ViewId=001","",3);
	tviTemp.insertPage(sFolder13,"多选树图", "/FrameCase/widget/treeview/ExampleView04.jsp","",4);
	tviTemp.insertPage(sFolder13,"复杂树图", "/FrameCase/widget/treeview/ExampleMutilView.jsp","",5);
	String sFolder15=tviTemp.insertFolder(sFolder10,"Selector","",5);
	tviTemp.insertPage(sFolder15,"树图/列表弹出选择框", "/FrameCase/widget/selector/ExampleSelect.jsp","",1);
	tviTemp.insertPage(sFolder15,"日历选择", "/FrameCase/widget/selector/ExampleCalendar.jsp","",3);
	
	String sFolder4=tviTemp.insertFolder("root","视图面板","",2);
	String sFolder7=tviTemp.insertFolder(sFolder4,"Main视图","",4);
	tviTemp.insertPage(sFolder7,"一般Main", "/FrameCase/Layout/ExampleMain01.jsp@ComponentName=一般Main&ComponentType=MainWindow","",1);
	tviTemp.insertPage(sFolder7,"隐藏左侧区域的Main", "/FrameCase/Layout/ExampleMain02.jsp@ComponentName=隐藏左侧区域的Main&ComponentType=MainWindow","",2);
	tviTemp.insertPage(sFolder4,"上下区域", "/FrameCase/Layout/ExampleFrame01.jsp","",1);
	tviTemp.insertPage(sFolder4,"左右区域", "/FrameCase/Layout/ExampleFrame02.jsp","",2);
	tviTemp.insertPage(sFolder4,"上下、左右切换", "/FrameCase/Layout/ExampleFrame01_02.jsp","",3);
	tviTemp.insertPage(sFolder4,"上下联动", "/FrameCase/Layout/ExampleFrame.jsp","",4);
	tviTemp.insertPage(sFolder4,"左右联动", "/FrameCase/Layout/ExampleFrame03.jsp","",5);
	tviTemp.insertPage(sFolder4,"Tab", "/FrameCase/Layout/ExampleTab.jsp","",6);
	tviTemp.insertPage(sFolder4,"Strip", "/FrameCase/Layout/ExampleStrip.jsp","",7);
	tviTemp.insertPage(sFolder4,"组合页面配置生成Tab/Strip", "/FrameCase/Layout/ExampleTabStrip.jsp","",8);
	
	String sFolder1=tviTemp.insertFolder("root","数据窗口(DataWindow)","",3);
	String sFolder2=tviTemp.insertFolder(sFolder1,"List示例","",1);
	tviTemp.insertPage(sFolder2,"典型List", "/FrameCase/widget/dw/ExampleList.jsp","",1);
	tviTemp.insertPage(sFolder2,"多选List", "/FrameCase/widget/dw/ExampleList02.jsp","",2);
	tviTemp.insertPage(sFolder2,"汇总List", "/FrameCase/widget/dw/ExampleList03.jsp","",3);
	tviTemp.insertPage(sFolder2,"可编辑List", "/FrameCase/widget/dw/ExampleList05.jsp","",4);
	tviTemp.insertPage(sFolder2,"DW数据过滤器", "/FrameCase/widget/dw/ExampleList08.jsp","",5);
	tviTemp.insertPage(sFolder2,"DW单击事件", "/FrameCase/widget/dw/ExampleList04.jsp","",6);
	String sFolder3=tviTemp.insertFolder(sFolder1,"Info示例","",2);
	tviTemp.insertPage(sFolder3,"典型Info", "/FrameCase/widget/dw/ExampleInfo.jsp@ExampleId=2013012300000001","",1);
	tviTemp.insertPage(sFolder3,"分组双列Info", "/FrameCase/widget/dw/ExampleInfo01.jsp@ExampleId=2013012300000001","",2);
	tviTemp.insertPage(sFolder3,"Info校验", "/FrameCase/widget/dw/ExampleInfoWithValid.jsp","",3);
	tviTemp.insertPage(sFolder3,"js脚本", "/FrameCase/widget/dw/ExampleSpecJS.jsp","",4);
	tviTemp.insertPage(sFolder3,"DW数据校验", "/FrameCase/widget/dw/ExampleInfo03.jsp@ExampleId=2013012300000001","",5);
	tviTemp.insertPage(sFolder3,"DW自定义单元格事件", "/FrameCase/widget/dw/ExampleInfo05.jsp@ExampleId=2013012300000001","",6);
	tviTemp.insertPage(sFolder3,"DW前置/后续事件(事务)", "/FrameCase/widget/dw/ExampleInfo04.jsp@ExampleId=2013012300000001","",7);
	
	String sFolder5 = tviTemp.insertFolder("root","对象窗口(ObjectWindow)","",4);
	String sFolder51=tviTemp.insertFolder(sFolder5,"List演示","",1);
	tviTemp.insertPage(sFolder51,"简单列表[不锁定表头和列]", "/FrameCase/widget/ow/DemoListSimple.jsp","",1);
	tviTemp.insertPage(sFolder51,"多选列表", "/FrameCase/widget/ow/DemoListMulty.jsp","",2);
	tviTemp.insertPage(sFolder51,"编辑列表", "/FrameCase/widget/ow/DemoListEdit.jsp","",3);
	tviTemp.insertPage(sFolder51,"数据导出", "/FrameCase/widget/ow/DemoListExport.jsp","",4);
	tviTemp.insertPage(sFolder51,"根据jbo manager生成数据", "/FrameCase/widget/ow/DemoListSimpleJBO.jsp","",5);
	tviTemp.insertPage(sFolder51,"根据jbo query生成数据", "/FrameCase/widget/ow/DemoListSimpleJBO2.jsp","",5);
	tviTemp.insertPage(sFolder51,"视图结合jbo生成数据", "/FrameCase/widget/ow/DemoListSimpleJBO3.jsp","",6);
	tviTemp.insertPage(sFolder51,"列表汇总 小计、合计", "/FrameCase/widget/ow/DemoListCount.jsp","",7);
	tviTemp.insertPage(sFolder51,"自定义列表样式", "/FrameCase/widget/ow/DemoListRegular.jsp","",8);
	tviTemp.insertPage(sFolder51,"自定义HTML事件", "/FrameCase/widget/ow/DemoListEvent2.jsp","",9);
	tviTemp.insertPage(sFolder51,"根据数组生成数据", "/FrameCase/widget/ow/DemoListSimpleArray.jsp","",10);
	tviTemp.insertPage(sFolder51,"自定义数据来源", "/FrameCase/widget/ow/DemoListCustomDataSource2.jsp","",11);
	tviTemp.insertPage(sFolder51,"自定义联动菜单", "/FrameCase/widget/ow/DemoListDMenu.jsp","",12);
	tviTemp.insertPage(sFolder51,"每行放自定义按钮", "/FrameCase/widget/ow/DemoListWithAction.jsp","",13);
	tviTemp.insertPage(sFolder51,"列表自定义过滤条件", "/FrameCase/widget/ow/DemoCustomListFilter.jsp","",14);
	tviTemp.insertPage(sFolder51,"列表自定义向导", "/FrameCase/widget/ow/DemoWizard.jsp","",15);
	tviTemp.insertPage(sFolder51,"json自定义格式及数据(List)", "/FrameCase/widget/ow/DemoListJSONDataSource.jsp","",15);
	tviTemp.insertPage(sFolder51,"新参数格式", "/FrameCase/widget/ow/DemoList4Params.jsp","",16);
	tviTemp.insertPage(sFolder51,"字段名相同_list", "/FrameCase/widget/ow/DemoDupColumnList.jsp","",17);
	String sFolder52=tviTemp.insertFolder(sFolder5,"Info演示","",2);
	tviTemp.insertPage(sFolder52,"简单Info", "/FrameCase/widget/ow/DemoInfoSimple.jsp","",1);
	tviTemp.insertPage(sFolder52,"自定义HTML事件(Info)", "/FrameCase/widget/ow/DemoInfoEvent2.jsp","",2);
	tviTemp.insertPage(sFolder52,"界面分组", "/FrameCase/widget/ow/DemoInfoGroup.jsp","",3);
	tviTemp.insertPage(sFolder52,"日期控件区间自定义", "/FrameCase/widget/ow/DemoInfoCalendarWidget.jsp","",4);
	tviTemp.insertPage(sFolder52,"特殊js脚本", "/FrameCase/widget/ow/DemoInfoSpecJS.jsp","",5);
	tviTemp.insertPage(sFolder52,"前后统一自定义校验", "/FrameCase/widget/ow/DemoInfoCValid.jsp","",6);
	tviTemp.insertPage(sFolder52,"自定义联动菜单(Info)", "/FrameCase/widget/ow/DemoInfoDMenu.jsp","",7);
	tviTemp.insertPage(sFolder52,"复合页面", "/FrameCase/widget/ow/DemoMultiPage.jsp","",8);
	tviTemp.insertPage(sFolder52,"五星控件", "/FrameCase/widget/ow/FiveStarMark.jsp","",9);
	tviTemp.insertPage(sFolder52,"自定义格式及数据(Info)", "/FrameCase/widget/ow/DemoInfoCustomDataSource.jsp","",10);
	tviTemp.insertPage(sFolder52,"json自定义格式及数据(Info)", "/FrameCase/widget/ow/DemoInfoJSONDataSource.jsp","",11);
	tviTemp.insertPage(sFolder52,"jbo数据来源(info)", "/FrameCase/widget/ow/DemoInfoJBODataSource.jsp","",12);
	tviTemp.insertPage(sFolder52,"12列模式Info", "/FrameCase/widget/ow/DemoInfoMulticols.jsp","",13);
	tviTemp.insertPage(sFolder52,"字段名相同_info", "/FrameCase/widget/ow/DemoDupColumnInfo.jsp","",14);
	
	String sFolder6 = tviTemp.insertFolder("root","SWF图形","",5);
	tviTemp.insertPage(sFolder6,"bar", "/FrameCase/Chart/ChartData.jsp@GraphType=bar","",1);
	tviTemp.insertPage(sFolder6,"bar_stack", "/FrameCase/Chart/ChartData.jsp@GraphType=bar_stack","",2);
	tviTemp.insertPage(sFolder6,"hbar", "/FrameCase/Chart/ChartData.jsp@GraphType=hbar","",3);
	tviTemp.insertPage(sFolder6,"line", "/FrameCase/Chart/ChartData.jsp@GraphType=line","",4);
	tviTemp.insertPage(sFolder6,"area_hollow", "/FrameCase/Chart/ChartData.jsp@GraphType=area_hollow","",5);
	tviTemp.insertPage(sFolder6,"pie", "/FrameCase/Chart/ChartData.jsp@GraphType=pie","",6);
	tviTemp.insertPage(sFolder6,"Chart其他写法", "/FrameCase/Chart/ChartDataFile.jsp@GraphType=bar","",7);
	tviTemp.insertPage(sFolder6,"仪表盘", "/FrameCase/Chart/CharDial.jsp@GraphType=bar","",8);
	tviTemp.insertPage(sFolder6,"DragNode", "/FrameCase/Chart/DragNodeData.jsp","",9);

	String sFolder8 = tviTemp.insertFolder("root", "对象组件(ObjectWidget)", "", 6);
	String sFolder81 = tviTemp.insertFolder(sFolder8, "ObjectTree", "", 1);
	tviTemp.insertPage(sFolder81, "ExampleObjectTree", "/FrameCase/widget/ExampleObjectTree.jsp", "", 1);
	tviTemp.insertPage(sFolder81, "ExampleAreaCode", "/FrameCase/widget/ExampleAreaCode.jsp@ClikItemNo=360821&SelectItemNo=120200,120115,360881", "", 2);
	
	tviTemp.insertPage("root", "向导", "/FrameCase/Wizard/ApplyList.jsp", "", 7);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	<%/*treeview单击选中事件;如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数*/%>
	function TreeViewOnClick(){
		var node = getCurTVItem();
		var sValue = node.value;
		if(!sValue) return;
		var navigation = sValue.split("@");
		var target = "right";
		var sCurItemname = node.name;
		
		if(sCurItemname=="复杂树图"){
			AsControl.PopView(navigation[0], navigation[1]?navigation[1]:"");
			return;
		}
		
		if(sCurItemname.indexOf("Main") > -1){
			target = "_self";
		}
		AsControl.OpenView(navigation[0], navigation[1], target);
		setTitle(sCurItemname);
	}
	
	<%/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/%>
	function initTreeVeiw(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode(getNodeIDByName("数据窗口(DataWindow)"));
		expandNode(getNodeIDByName("List示例"));
		expandNode(getNodeIDByName("Info示例"));
		//默认打开的(叶子)选项
		selectItemByName("典型List");
		myleft.width = 250;
	}

	initTreeVeiw();
</script>
<%@ include file="/IncludeEnd.jsp"%>