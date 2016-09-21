<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe: 票据信息出账申请时的票据信息
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
	 */
	String PG_TITLE = "相关票据信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	ASResultSet rs =null ;
	String contractSerialNo="";
	
	//获得组件参数
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	contractSerialNo = CurPage.getParameter("ContractSerialNo");
	String sBusinessType = CurPage.getParameter("BusinessType");
	String sSerialNo    = CurPage.getParameter("SerialNo");

	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(contractSerialNo==null) contractSerialNo="";
	if(sBusinessType==null) sBusinessType="";
	if(sSerialNo == null ) sSerialNo = "";
	
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";

	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("BillInfo1X","");	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);   
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo+","+sSerialNo);

	String sButtons[][] = {
		//{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		//{"true","","Button","返回","返回列表页面","goBack()","","","",""}
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
	    //获得业务品种
		sBusinessType = "<%=sBusinessType%>";
        if (bIsInsert) {
	        //对输入的票据号进行唯一性检查。
			if (!validateCheck()) {
			    return;
			} 
        }
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/BillList.jsp","_self","");
	}

	/*~[Describe=用与检查输入的票据号是否已经存在;InputParam=无;OutPutParam=无;]~*/
    function validateCheck() {
        var sBillNo = getItemValue(0,getRow(),"BillNo");
        var sContractSerialNo = "<%=sObjectNo%>";
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
            var sParaString = sObjectType + "," + sContractSerialNo + "," + sBillNo;
            sReturn = RunMethod("BusinessManage","CheckApplyDupilicateBill",sParaString);
            //如果输入的票据号已经存在，则不允许进行新增操作。
            if (sReturn != 0) {
                 alert("票据号:" + sBillNo + "已存在！请重新检查输入的票据号是否正确。");
                 return false;
            } else {
                return true;
            }
        }else{
        	alert("请输入票据编号！")
        	return false;
        }
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

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			//as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "BILL_INFO";//表名
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