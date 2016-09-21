<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content: 
		Input Param:
			ObjectType：五级分类对象("Classify")
			ClassifyType: 修改标志(010:可用进行模型分类测算，020：只可以浏览模型分类结果)
			ResultType: 对象类型(按合同：BUSINESS_CONTRACT；按借据：BUSINESS_DUEBILL)
	 */
	//获得组件参数：对象类型、模型号、类型、五级分类借据或合同
	String sObjectType = CurPage.getParameter("ObjectType");
	String sClassifyType = CurPage.getParameter("ClassifyType");
	String sResultType = CurPage.getParameter("ResultType"); 
	//将空值转化为空字符串	
	if(sObjectType == null) sObjectType = "";
	if(sClassifyType == null) sClassifyType = "";
	if(sResultType == null) sResultType = "";

	String[][] sHeaders1 = {
					{"AccountMonth","风险分类月份"},							
					{"ObjectNo","合同号"}							
			      };
	//通过显示模板产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel("ClassifyDialogInfo");	
	if(sResultType.equals("BusinessContract"))
		doTemp.setHeader(sHeaders1);
	//设置默认值
	doTemp.setDefaultValue("AccountMonth",StringFunction.getToday().substring(0,7));
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {	
		{"true","","Button","确定","新增资产风险分类","doSubmit()","","","",""},
		{"true","","Button","取消","取消资产风险分类","doCancel()","","","",""}		
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("新增资产风险分类");
	<%/*~[Describe=新增资产风险分类;]~*/%>	
	function doSubmit(){
		var sObjectType = "<%=sObjectType%>";
		var sResultType = "<%=sResultType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//会计月份		
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0){
			alert(getMessageText('ALS70671'));//请选择风险分类月份！
			return;
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//对象编号	
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0){
			if(sResultType == "BusinessContract")
				alert(getMessageText('ALS70672'));//请选择需资产风险分类的合同流水号！
			if(sResultType == "BusinessDueBill")
				alert(getMessageText('ALS70673'));//请选择需资产风险分类的借据流水号！
			return;
		}
		//新增资产风险分类信息
	    sReturn = AsControl.RunJsp("/CreditManage/CreditCheck/ConsoleClassifyActionX.jsp","AccountMonth="+sAccountMonth+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelNo=Classify1");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0){
	    	alert(getMessageText('ALS70674'));//该期资产风险分类新增失败！
	    	return;
	    }else if(sReturn == "IsExist"){
	    	alert(getMessageText("ALS70665"));//该期资产风险分类已经存在！
	    	return;
		}else{
			alert(getMessageText('ALS70675'));//该期资产风险分类新增成功！
			top.returnValue = sReturn;
	        sParamString = "ComponentName=风险分类参考模型"+
					       "&OpenType=Tab"+ //jschen@20100412 用来区分打开分类模型界面的方式
	            		   "&Action=_DISPLAY_"+
	            		   "&ClassifyType="+"<%=sClassifyType%>"+
	            		   "&ObjectType="+sObjectType+
	            		   "&ObjectNo="+sReturn+
	            		   "&SerialNo="+sObjectNo+
	            		   "&AccountMonth="+sAccountMonth+
	            		   "&ModelNo=Classify1"+
	            		   "&ResultType="+sResultType;
			AsControl.OpenObjectTab(sParamString);
			top.close();
		}
    }
    
	<%/*~[Describe=取消新增资产风险分类;OutPutParam=取消标志;]~*/%>
	function doCancel(){
		top.returnValue = "_CANCEL_";
		top.close();
	}

	<%/*~[Describe=选择会计月份;]~*/%>
    function getMonth(){
		var sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp","","dialogWidth=250px;dialogHeight=180px;resizable=yes;center:yes;status:no;statusbar:no");
		if (typeof(sMonth) != "undefined" && sMonth.length > 0)
			setItemValue(0,0,"AccountMonth",sMonth);
	}
    
    <%/*~[Describe=弹出对象编号选择框;]~*/%>
	function getObjectNo(){
		var sReturnValue = "";
		var sObjectNo = "";
		var sResultType = "<%=sResultType%>";
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--会计月份		
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0){
			alert(getMessageText('ALS70671'));//请选择风险分类月份！
			return;
		}
		
		if(sResultType == "BusinessContract"){ //如果按照合同进行资产风险分类，那么选择合同流水号
			sParaString = "ObjectType,"+sResultType+",AccountMonth"+","+sAccountMonth+",UserID,"+"<%=CurUser.getUserID()%>";
			sReturnValue = setObjectValue("SelectClassifyContractnew",sParaString,"",0,0,"");			
		} else { //如果按照借据进行资产风险分类，那么选择借据流水号
			sParaString = "ObjectType,"+sResultType+",AccountMonth"+","+sAccountMonth+",UserID,"+"<%=CurUser.getUserID()%>";
			sReturnValue = setObjectValue("SelectClassifyDueBillnew",sParaString,"",0,0,"");
		}
		if(sReturnValue != "_CLEAR_" && typeof(sReturnValue) != "undefined"){
			sReturnValue = sReturnValue.split('@');
			for(var i = 0;i < sReturnValue.length;i++){
				sObjectNo += sReturnValue[i];
			}
			setItemValue(0,getRow(),"ObjectNo",sObjectNo);
		}
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>