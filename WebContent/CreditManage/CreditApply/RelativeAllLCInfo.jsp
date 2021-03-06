<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe: 相关信用证信息,相关议付单据信息,相关贸易单据信息共用页面
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
			SerialNo:	流水号
	 */
	String PG_TITLE = "相关信用证信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String sObjectType = CurComp.getParameter("ObjectType");
	String sObjectNo = CurComp.getParameter("ObjectNo");
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	//获得页面参数	
	String sSerialNo    = CurPage.getParameter("SerialNo");
	String sTemplet    = CurPage.getParameter("Templet");
	if(sSerialNo == null ) sSerialNo = "";
	if(sTemplet == null ) sTemplet = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = sTemplet;
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		if("<%=sTemplet%>" == "CKLCInfo"){
		    OpenPage("/CreditManage/CreditApply/RelativeLC2List.jsp","_self","");
		}
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		//判断远期是否输入
	    var slcterm = getItemValue(0,getRow(),"lcterm");
	    var sFlag1 = getItemValue(0,getRow(),"Flag1");
	    var sLCType = getItemValue(0,getRow(),"LCType");
	    if(sLCType != "01" && sLCType != "" && typeof(sLCType) != "undefined"){
		    if(typeof(slcterm) == "undefined" || slcterm == ""){
		       	alert(getBusinessMessage('492'));//选择远期信用证类型时，需输入远期信用证付款期限(月)！
		        return false;
		    }
		    if(typeof(sFlag1) == "undefined" || sFlag1 == ""){
		        alert(getBusinessMessage('493'));//选择远期信用证类型时，需输入远期信用证是否已承兑！
		        return false;
		    }
	    }
		return true;
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=弹出国家/地区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		setObjectValue("SelectCode",sParaString,"@IssueState@0@IssueStateName@1",0,0,"");
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "LC_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	initRow();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>