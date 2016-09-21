<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="java.util.Date"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  ljzhong 2014/09/25
		Tester:
		Describe:放款确认列表页面
		Input Param:
				
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "放款确认"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	//获得组件参数：对象类型、对象编号

	//将空值转化为空字符串
	String sStartWithId = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StartWithId",2)));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//用sSql生成数据窗体对象
	String sTempletNo = "ImageFileTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.UpdateTable = "ECM_IMAGE_TYPE";
	doTemp.setKey("TypeNo",true);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为只读
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sStartWithId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","打印条形码","打印条形码","printBarCode()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		as_add( "myiframe0" );
		var param = "<%=sStartWithId%>";
		var sNewExampleTypeNo = RunMethod("CBBusinessManage","ImageUtil",param);
		setItemValue( 0, getRow(), "TypeNo", sNewExampleTypeNo );
	}
	
	/*~[Describe=保存记录;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValue(0,getRow(),"TypeName");
		if( (typeof sTypeNo !="undefined") && (sTypeNo == "" || sTypeName == "") ){
			alert( "类型编号、类型名称不可以为空" );
			return;
		}else{
			as_save("myiframe0");
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	/*~[Describe=删除所选中的记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod( "CBBusinessManage", "delRelationByImageTypeNo", sTypeNo );
			parent.frames["frameleft"].reloadSelf();
		}
	}
	
	/*~[Describe=打印条形码;InputParam=无;OutPutParam=无;]~*/
	function printBarCode(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValueArray(0,getRow(),"TypeName");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请选择一条记录！");
			return;
		}

		//alert(sTypeNo);
		//alert(sTypeName);

		var typeNoString = sTypeNo.toString();
		var typeNameString = sTypeName.toString();
		var re =/,/g; 
		typeNoString = typeNoString.replace(re,"@");	
		typeNameString = typeNameString.replace(re,"@");	
		var param = "TypeNo="+typeNoString+"&TypeName="+typeNameString;
		OpenComp("PrintBarCode","/ImageManage/PrintBarCode.jsp",param,"");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;
	my_load(2,0,'myiframe0');
	<%if(!doTemp.haveReceivedFilterCriteria())
	{
	%>
		showFilterArea();
	<%
	}
	%>
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>