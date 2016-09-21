<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "NewApplyInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setVisible("CustomerType",true);
	doTemp.setUnit("CustomerID","<input class='inputdate' value='快速新增客户' type='button' onClick=newCustomer()>");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord(0)","","","",""},
		{"true","All","Button","返回","返回列表","top.close()","","","",""}
	};
	sButtonPosition = "south";
	String today=StringFunction.getToday();
	String curOrgName=CurUser.getOrgName();
	String curUserName=CurUser.getUserName();

	
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var mapValue = {};
	function test(){
	 	
	}

	function saveRecord(){
		if(!iV_all("0")) return ;
/* 		var barCode = getItemValue(0,getRow(),"BarCode");
	    var isExist = RunJavaMethodTrans("com.amarsoft.app.als.image.BarCodeSevice", "isExistBarCode", "BarCode=" + barCode);
	    if (isExist == "true"){
	    	alert("条形码已存在！");
	    	return;
	    } */

		sReturn=AsCredit.doAction("0010");
		var sParamString = "ObjectType=CreditApply&ObjectNo="+sReturn;
		AsControl.OpenObjectTab(sParamString);
		top.close();
	}
	/*~[Describe=清空信息;InputParam=无;OutPutParam=无;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		setItemValue(0,0,"BusinessType","");
		setItemValue(0,0,"BusinessTypeName","");
		setItemValue(0,0,"RelativeAgreement","");
		setItemValue(0,0,"RelativeObjectType","");
		setItemValue(0,0,"OperateType","");
		setItemValue(0,0,"isHostBank","");
	}

	/*~[Describe=获取客户编号和名称;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
	function subSelectCustomer(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"CustomerID","");
				setItemValue(0,0,"CustomerName","");
				return;
			}
			setItemValue(0,0,"CustomerID",oArray[0]);
			setItemValue(0,0,"CustomerName",oArray[1]);
			//改变客户类型时清空业务品种、关联借据和关联重组方案
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
			setItemValue(0,0,"RelativeObjectType","");
		}catch(e){
			return;
		}
	}	



	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		var sCustomerType= getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert(getBusinessMessage('225'));//请先选择客户类型！
			return;
		}
		//具有业务申办权的客户信息
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType.substring(0,2) == "01")//公司客户和中小企业
			subSelectCustomer("SelectApplyCustomerM",sParaString);
		if(sCustomerType.substring(0,2) == "02")//关联集团
			subSelectCustomer("SelectApplyCustomer2",sParaString);
		if(sCustomerType.substring(0,2) == "03")//个人客户
			subSelectCustomer("SelectApplyCustomer1",sParaString);
	}
	/*~[Describe=弹出联保体客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUGCustomer(){
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";
		subSelectCustomer("SelectUGCustomer",sParaString);
	}
 
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType){
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert(getBusinessMessage('225'));//请先选择客户类型！
			return;
		}
		
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert(getBusinessMessage('226'));//请先选择授信客户！
			return;
		}
		if(sType == "ALL"){
			//如果为个人客户
			if(sCustomerType.substring(0,2) == "03"){
				subSelectBusinessType("SelectIndivBusinessType");
			}	
			//如果为公司客户		
			else if(sCustomerType.substring(0,2) == "01"){
				subSelectBusinessType("SelectEntBusinessType");
			}
		}else if(sType == "CL"){ //授信额度的业务品种
			//“01”代表公司客户，“02”代表集团客户，如果选择的是公司客户，则弹出授信额度业务品种，如果选择的是集团客户，则默认为集团授信额度
			if(sCustomerType.substring(0,2) =="01")
				setObjectValue("SelectCLBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			if(sCustomerType.substring(0,2) =="02"){
				//新增弹出框提示语句，防止出现异议！
				alert("集团客户只能申请集团授信额度！");
				return;
			}		
		}
	}

	/*~[Describe=获取业务品种;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
	function subSelectBusinessType(selectName){
		try{
			o = setObjectValue(selectName,"","",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"BusinessType","");
				setItemValue(0,0,"BusinessTypeName","");
				return;
			}
			setItemValue(0,0,"BusinessType",oArray[0]);
			setItemValue(0,0,"BusinessTypeName",oArray[1]);
		}catch(e){
			return;
		}
	}
	/*~[Describe=弹出资产重组选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectNPARefrom(){
		try{				
			o = setObjectValue("SelectNPARefrom","","",0,0,"");	
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"RelativeAgreement","");
				return;
			}
			setItemValue(0,0,"RelativeAgreement",oArray[0]);
		}catch(e){
			return;
		}
	}
	/*~[Describe=弹出待展期的合同/借据选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectExtendContract(){
		var sCustomerID =  getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//按照合同展期
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.getUserID()%>";
		//按照借据展期
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.getUserID()%>";
		subSelectExtContract("SelectExtendDueBill",sParaString);
	}
	/*~[Describe=获取展期借据;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
	function subSelectExtContract(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"RelativeObjectType","");
				return;
			}
			setItemValue(0,0,"RelativeObjectType",oArray[0]);
			setItemValue(0,0,"BusinessTypeName",oArray[1]);
		}catch(e){
			return;
		}
	}
	function initRow(){
		setItemValue(0,0,"OccurType","010");
		setItemValue(0,0,"OccurDate","<%=today%>");
		setItemValue(0,0,"InputOrgName","<%=curOrgName%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=curUserName%>");
		setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputDate","<%=today%>");
		setItemValue(0,0,"OperateDate","<%=today%>");
		setItemValue(0,0,"CustomerType","01");
		setItemValue(0,0,"OperateType","01");
		setItemValue(0,0,"isHostBank","2");
		setItemValue(0,0,"Flag5","010");
		hideItem(0,'IsHostBank');
		hideItem(0,'RelativeAgreement');
		hideItem(0,'RelativeObjectType');
		setItemRequired(0,"RelativeAgreement",false);
		setItemRequired(0,"RelativeObjectType",false);
		occurTypeChange();
	}
	function occurTypeChange(){
		var currentType=getItemValue(0,getRow(),"OccurType");
		if(currentType=="010"){
			setItemRequired(0,"BusinessTypeName",true);
			showItem(0,'BusinessTypeName');
			hideItem(0,'RelativeAgreement');
			hideItem(0,'RelativeObjectType');
			setItemRequired(0,"RelativeAgreement",false);
			setItemRequired(0,"RelativeObjectType",false);
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}else if(currentType=="015"){
			setItemRequired(0,"BusinessTypeName",false);
			setItemRequired(0,"RelativeAgreement",false);
			setItemRequired(0,"RelativeObjectType",true);
			hideItem(0,'BusinessTypeName');
			hideItem(0,'RelativeAgreement');
			showItem(0,'RelativeObjectType');
			hideItem(0,'OperateType');
			hideItem(0,'isHostBank');
		}else if(currentType=="020"){
			showItem(0,'BusinessTypeName');
			setItemRequired(0,"BusinessTypeName",true);
			setItemRequired(0,"RelativeAgreement",false);
			setItemRequired(0,"RelativeObjectType",true);
			hideItem(0,'RelativeAgreement');
			showItem(0,'RelativeObjectType');
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}else if(currentType=="030"){
			showItem(0,'BusinessTypeName');
			showItem(0,'RelativeAgreement');
			setItemRequired(0,"BusinessTypeName",true);
			setItemRequired(0,"RelativeObjectType",false);
			setItemRequired(0,"RelativeAgreement",true);
			hideItem(0,'RelativeObjectType');
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}
	}
	function customTypeChange(){
		clearData();
		var sCurrentCustomType=getItemValue(0,getRow(),"CustomerType");
		if(sCurrentCustomType.substring(0,2)=="03"){
			setItemValue(0,0,"OperateType","");
			setItemValue(0,0,"isHostBank","");
			hideItem(0,'OperateType');
			hideItem(0,'isHostBank');
		}else{
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}
	}
	function operateTypeChange(){
		var sCurrentOperateType=getItemValue(0,getRow(),"OperateType");
		if(sCurrentOperateType=="02" || sCurrentOperateType=="03"){//授信组织方式为：银团贷款
			showItem(0,'isHostBank');//银团贷款我行是否主办行
		}else{
			setItemValue(0,0,"isHostBank","2");
			hideItem(0,'isHostBank');
		}
	}
	
	function printBarCode(){
		var barCode = getItemValue(0,getRow(),"BarCode");
		if(typeof(barCode) == "undefined" || barCode == ""){
			alert("请输入条形码值！");
			return;
		}
		
		AsCredit.printBarCode(barCode);
	    	
	}
	
	function newCustomer(){
	    var customerType=getItemValue(0,getRow(),"CustomerType"); //--客户类型
	    if(!customerType){
		   alert(getBusinessMessage('225'));//请先选择客户类型！
		   return;
	    }
        var returnValue = AsControl.PopComp("/CustomerManage/NewCustomerDialog.jsp","CustomerType="+customerType+"&SourceType=APPLY","resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
        if(!returnValue) return;
        if(returnValue.indexOf("@")>0){
        	setItemValue(0,getRow(),"CustomerID",returnValue.split("@")[0]);
        	setItemValue(0,getRow(),"CustomerName",returnValue.split("@")[1]);
        }   
	}
	initRow();

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
