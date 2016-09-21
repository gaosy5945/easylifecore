<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Describe: 相关支付清单信息
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
		Output Param:
		HistoryLog:gftang 将DW改为OW,参数本页面获取
	 */
	String PG_TITLE = "相关支付清单信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String sPutoutSerialNo    = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sSerialNo    = CurPage.getParameter("SerialNo");
// 	变量定义
	String sPurpose ="",sBusinessSum="",sPaymentMode="",sBusinessCurrency="",customerID="",customerName="";
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_PUTOUT" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", sPutoutSerialNo).getSingleResult(false);
	if(bo!=null){
		sPurpose =bo.getAttribute("Purpose").getString();
		double dBusinessSum = bo.getAttribute("BusinessSum").getDouble();
		sBusinessSum=String.valueOf(dBusinessSum);
		sPaymentMode=bo.getAttribute("PaymentMode").getString();
		sBusinessCurrency=bo.getAttribute("BusinessCurrency").getString();
		customerID=bo.getAttribute("CustomerID").getString();
		customerName=bo.getAttribute("CustomerName").getString();
	}
	if(sSerialNo == null ) sSerialNo = ""; 
	if(sObjectType == null) sObjectType = "";
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sPaymentMode == null) sPaymentMode = ""; 
    if(sPurpose == null) sPurpose = ""; 
    
    if(customerID == null) customerID = "";
    if(customerName == null) customerName = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "PaymentBillInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
  	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		if (!ValidityCheck()){
			return;
		}else{
			if(bIsInsert){
				beforeInsert();
			}else
				beforeUpdate();		
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/PaymentBillList.jsp","_self","");
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//当前支付流水号
		var sPICurrency = getItemValue(0,getRow(),"Currency");//当前支付页面的币种
		var sBPCurrency = "<%=sBusinessCurrency%>";//当前放贷页面的币种

		var currentPaymentSum = getItemValue(0,getRow(),"PaymentSum");//获取当前页面的支付金额
		var sReturn = RunMethod("BusinessManage","ChangeToRMB",currentPaymentSum+","+sPICurrency);
		currentPaymentSum = parseFloat(sReturn);
		
		paymentSum1 = RunMethod("BusinessManage","GetCurrentPaymentSum",sSerialNo);//获取当前支付流水号对应的支付金额
		if(paymentSum1>0){
			paymentSum1 = paymentSum1;//详情页面
		}else{
			paymentSum1 = 0;//新增页面
		}
				
		sParaString = "<%=sPutoutSerialNo%>"+","+"<%=sObjectType%>";		
		sReturn = RunMethod("BusinessManage","GetPaymentAmount",sParaString);//获取已经申请的支付金额
		var paymentSum = parseFloat(sReturn);//
		
		sReturn = RunMethod("BusinessManage","ChangeToRMB","<%=sBusinessSum%>"+","+sBPCurrency);
		var putoutSum = parseFloat(sReturn);//获取放贷金额
		if((paymentSum+currentPaymentSum-paymentSum1)<= putoutSum){
			return true;
		}else{
			alert("支付总金额大于放款金额!");
			return false;
		}
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			setItemValue(0,0,"PutoutSerialNo","<%=sPutoutSerialNo%>");
			setItemValue(0,0,"PaymentMode","<%=sPaymentMode%>");
			setItemValue(0,0,"CapitalUse","<%=sPurpose%>");
			setItemValue(0,0,"CustomerID","<%=customerID%>");
			setItemValue(0,0,"CustomerName","<%=customerName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			initSerialNo();
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Payment_Info";//表名
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