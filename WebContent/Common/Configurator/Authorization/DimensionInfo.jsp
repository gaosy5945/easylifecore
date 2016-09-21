<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "授权参数信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数：对象类型、对象编号、担保信息编号、抵押物编号、质物类型
	String sDimensionID = CurPage.getParameter("DimensionID");
	//将空值转化为空字符串
	if(sDimensionID == null) sDimensionID = "";
		
	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("AuthorDimensionInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		
	//设置setEvent
	dwTemp.setEvent("AfterInsert", "!PublicMethod.AuthorObjectManage('update','dimension',#DIMENSIONID)");
	dwTemp.setEvent("AfterUpdate", "!PublicMethod.AuthorObjectManage('update','dimension',#DIMENSIONID)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDimensionID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if(bIsInsert){		
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","parent.reloadSelf();");	
	}
	
	function selectImpl(colId){
		var sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var sReturn = PopPage("/Common/Configurator/Authorization/TreeNodeSelector.jsp?SelName=Impl&ParaString=","",sStyle);
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		if(sReturn=="_CLEAR_"){
			setItemValue(0,0,colId,"");
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
			setItemValue(0,0,colId,selectedValue[0]);
		}
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			bIsInsert = true;			
		}
    }

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "SADRE_DIMENSION";//表名
		var sColumnName = "DIMENSIONID";//字段名
		var sPrefix = "D";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		//var sDimensionID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		var sDimensionID = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),"DIMENSIONID",sDimensionID);				
	}
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>