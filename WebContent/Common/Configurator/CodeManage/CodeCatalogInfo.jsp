<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content: 代码目录详情
	 */
	//获得组件参数	
	String sCodeNo =  CurPage.getParameter("CodeNo"); //代码编号
	String sCodeTypeOne =  CurPage.getParameter("CodeTypeOne");   //大类
	String sCodeTypeTwo =  CurPage.getParameter("CodeTypeTwo");   //小类
	if(sCodeNo==null) sCodeNo="";

	ASObjectModel doTemp = new ASObjectModel("CodeCatalogInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sCodeNo);
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("代码目录详情");
	setItemValue(0,0,"CodeTypeOne","<%=sCodeTypeOne%>");
	setItemValue(0,0,"CodeTypeTwo","<%=sCodeTypeTwo%>");
	var sOldCodeNo = getItemValue(0, 0, "CodeNo");
	
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(){
		if(bIsInsert){
			if(!validate()) return;
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","doReturn('Y');");
	}
    
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CodeNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    function validate(){
    	var sCodeNo = getItemValue(0, getRow(0), "CodeNo");
    	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.sys.bizlet.CodeCreditAction", "checkCodeCatalog", "CodeNo="+sCodeNo);
    	//var sResult = AsControl.RunJavaMethodSqlca("com.amarsoft.app.configurator.bizlets.CodeCatalogAction", "validate", "CodeNo="+sCodeNo+",OldCodeNo="+sOldCodeNo);
    	if(result != "true"){
    		alert(result.split("@")[1]);
    		return false;
    	}
    	return true;
    }
    
    <%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
    
    function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		initRow();
	});
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>