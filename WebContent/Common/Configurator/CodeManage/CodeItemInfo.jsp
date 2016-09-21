<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content: 代码表详情
	 */
	//定义变量
	String sDiaLogTitle = "";
	String sCodeNo =  CurPage.getParameter("CodeNo"); //代码编号
	String sItemNo =  CurPage.getParameter("ItemNo"); //项目编号
	String sCodeName =  CurPage.getParameter("CodeName");
	//将空值转化为空字符串
	if(sCodeNo == null) sCodeNo = "";
	if(sItemNo == null) sItemNo = "";
	if(sCodeName == null) sCodeName = "";
	
	if(sCodeNo.equals("")){
		sDiaLogTitle = "【 代码库新增配置 】";
	}else{
		if(sItemNo==null || sItemNo.equals("")){
			sItemNo="";
			sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』新增配置";
		}else{
			sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』查看修改配置";
		}
	}

	ASObjectModel doTemp = new ASObjectModel("CodeItemInfo");
	if(!sCodeNo.equals("")){
		doTemp.setVisible("CodeNo",false); 
	}else{
		doTemp.setRequired("CodeNo",true);
	} 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sCodeNo+","+sItemNo);
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()","","","",""},
		{"true","","Button","保存并新增","保存后新增","saveAndNew()","","","",""}			
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
		if(bIsInsert){
			if(!validate()) return;
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndNew(){
		saveRecord("newRecord()");
	}
   
	function newRecord(){
        OpenComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","_self");
	}
	setDialogTitle("<%=sDiaLogTitle%>");
	
	function validate(){
    	var sCodeNo = getItemValue(0, getRow(0), "CodeNo");
    	var sItemNo = getItemValue(0, getRow(0), "ItemNo");
    	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.sys.bizlet.CodeCreditAction", "checkCodeLibrary", "CodeNo="+sCodeNo+",ItemNo="+sItemNo);
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