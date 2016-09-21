<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "额度关联信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数	：申请流水号、对象类型、对象编号、业务类型、客户类型、客户ID
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo =  CurPage.getParameter("ObjectNo");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sObjectNo == null) sObjectNo = "";

	ASObjectModel doTemp = new ASObjectModel("RelativeCreditInfo");	
	CreditObjectAction  creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sObjectType = creditObjectAction.getRealCreditObjectType();
	String customerID = creditObjectAction.creditObject.getAttribute("CustomerID").getString();
	if(creditObjectAction.getCustomerType().startsWith("01")){ //公司客户
		doTemp.setDDDWCodeTable("LmtCatalog","3005,公司综合授信额度,3040,担保公司担保额度");
	}else if (creditObjectAction.getCustomerType().startsWith("03")){ //个人客户
		//doTemp.setDDDWCodeTable("LmtCatalog","3008,个人综合授信额度,3040,第三方授信额度");
		doTemp.setDDDWCodeTable("LmtCatalog","3030,第三方授信额度");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()","","","",""},		
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}	
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		if(checkLineRelative()){
			initSerialNo();
			as_save("myiframe0");
			goBack();
		}			
	}
    
    /*~[Describe=取消新增额度关联记录;InputParam=无;OutPutParam=取消标志;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/CreditLineRelaList.jsp","_self","");
	}

    /*~[Describe=额度关联校验;InputParam=无;OutPutParam=无;]~*/
	function checkLineRelative(){
		lmtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CheckCreditLineType","checkCLType","CreditObjectType=<%=sObjectType%>,ApplySerialNo=<%=sObjectNo%>,LmtCatalog="+lmtCatalog);
		if(sReturnValue == "SUCCESS"){
			return true;
		}else{
			alert(sReturnValue);
			return false;
		}
	}
	
	/*~[Describe=根据额度类型，找到对应的额度协议号选择树图;InputParam=无;OutPutParam=无;]~*/
	function selectLineNo(){
		lmtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		if(typeof(lmtCatalog) == "undefined" || lmtCatalog.length == 0){
			alert("请先选择额度类型！");
			return;
		}
		selectCreditLine(lmtCatalog);
	}
	
	/*~[Describe=弹出授信额度选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditLine(businessType){
		var sCustomerID = "<%=customerID%>";
		var sObjectType = "<%=sObjectType%>";
		var imtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		var sParaString = "ObjectNo"+","+"<%=sObjectNo%>"+","+"ObjectType"+","+sObjectType+","+"CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>"+",BusinessType,"+businessType;
		if(imtCatalog == "3005"){  //公司
			sReturn = setObjectValue("SelectCLContract",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");			
		}else if(imtCatalog == "3040"){  //担保
			sReturn = setObjectValue("SelectCLContract2",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");
		}
		else if(imtCatalog == "3030"){ //第三方
			//返回合同流水号,余额,业务品种,客户名称,合同金额,币种
			sReturn = setObjectValue("SelectCLContract1",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "CL_OCCUPY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增一条空记录			
			//对象类型
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			//对象编号
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");	
		}
    }
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>