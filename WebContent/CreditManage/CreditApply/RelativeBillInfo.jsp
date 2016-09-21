<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
 <script>
 var cityArray = new Array();
 var areaArray = new Array();
 </script>
<%
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
	ASObjectModel doTemp = new ASObjectModel("BillInfo","");
	
	if("1020020".equals(sBusinessType)) //商业承兑汇票贴现 - 电子商业承兑汇票贴现
	{
		doTemp.setVisible("IsLocalBill",false);
		doTemp.setRequired("IsLocalBill",false);
		doTemp.setDefaultValue("IsLocalBill","2");
		doTemp.setVisible("IsSafeGuard,SafeGuardProtocol,Acceptor",true);
		doTemp.setRequired("IsSafeGuard,Acceptor",true);
		doTemp.setHeader("AcceptorID", "承兑人开户行行号");
		doTemp.setHeader("AcceptorBankID", "承兑人开户银行名称");
	}
	
	if(!sBusinessType.equals("1020020")) //银行承兑汇票/协议付息票据贴现
	{
		//计算实付金额、实收利息
		doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate,EndorseTimes,Rate"," onChange=\"javascript:parent.getSum()\" ");
		doTemp.setReadOnly("actualSum,actualint",true);
	}else{
	    doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate"," onChange=\"javascript:parent.getSum()\" ");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);   
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo+","+sSerialNo);

	String sButtons[][] = {
		{"PutOutApply".equals(sObjectType)?"false":"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
	    //获得业务品种
		sBusinessType = "<%=sBusinessType%>";
        //当新增业务品种为承兑汇票贴现的票据信息时，对输入的票据号进行唯一性检查。add by cbsu 2009-11-10
        //1020010：银行承兑汇票贴现 1020020：商业承兑汇票贴现 1020030：协议付息票据贴现 1020040：商业承兑汇票保贴
        if (bIsInsert) {
			if (sBusinessType == "1020010" || sBusinessType == "1020020" || sBusinessType == "1020030" || sBusinessType == "1020040") {
				if (!validateCheck()) {
				    return;
				} 
			}
        }
		getSum();
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	function setCity(provValue,cityValue){
		var aCode = [];
		if(cityArray[provValue]){
			aCode = cityArray[provValue];
		}
		else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.CityFetcher","getCities","prov="+provValue);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		var oCity = document.getElementById("ACCEPTORCITY");
		var options = oCity.options;
		options.length = 1;
		options[0] = new Option("请选择城市","");
		options[0].selected = true;
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==cityValue)curOption.selected = true;
			options[options.length] = curOption;
		}
	}
	
	setCity(getItemValue(0,0,'AcceptorRegion'),getItemValue(0,0,'AcceptorCity'));
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/RelativeBillList.jsp","_self","");
	}
	//计算实付金额和实收利息
	function roundOff(number,digit){
		var sNumstr = 1;
    	for (i=0;i<digit;i++){
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	function getSum(){
		//票据金额、票据到期日、票据贴现日期
		sBillSum = getItemValue(0,getRow(),"BillSum");
		sMaturity = getItemValue(0,getRow(),"Maturity");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
				
		//调整天数、月利率
		sEndorseTimes = getItemValue(0,getRow(),"EndorseTimes");
		sRate = getItemValue(0,getRow(),"Rate");
				
		//初始化实付金额、实收利息
		setItemValue(0,0,"actualSum",sBillSum);
		setItemValue(0,0,"actualint",0.00);
		
		if(typeof(sRate)=="undefined" || sRate.length==0) sRate=0; 
		if(typeof(sEndorseTimes)=="undefined" || sEndorseTimes.length==0) sEndorseTimes=0;
		if(typeof(sMaturity)=="undefined" || sMaturity.length==0) return;
		if(typeof(sFinishDate)=="undefined" || sFinishDate.length==0) return;
		
		sTerms = PopPageAjax("/CreditManage/CreditApply/getDayActionAjax.jsp?Maturity="+sMaturity+"&FinishDate="+sFinishDate,"","");
				
		if(typeof(sTerms)=="undefined" || sTerms.length==0) sTerms=0; 
				
		//计算实收利息=(到期日 - 贴现日期+调整天数)*月利率/30*票据金额
		sActualint = sTerms*sRate*sBillSum/30000+sEndorseTimes*sRate*sBillSum/30000;
				
		//计算实付金额=票据金额 - 实收利息
		sActualSum =  sBillSum - sActualint;
		//更新实付金额、实收利息
		if(roundOff(sActualSum,2)<0){
			setItemValue(0,0,"actualSum","0");
			setItemValue(0,0,"actualint",roundOff(sActualint,2));
		}else{
			setItemValue(0,0,"actualSum",roundOff(sActualSum,2));
			setItemValue(0,0,"actualint",roundOff(sActualint,2));
		}
	}

	/*~[Describe=用与检查输入的票据号是否已经存在;InputParam=无;OutPutParam=无;]~*/
	//add by cbsu 2009-11-10
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