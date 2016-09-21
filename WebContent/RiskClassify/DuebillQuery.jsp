<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>

<%	

    String orgId = CurUser.getOrgID();
    String orgName = CurUser.getOrgName(); 
    
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_RISK_APPLY");
    doTemp.setLockCount(1);
	//doTemp.setJboWhereWhenNoFilter("1=2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.MultiSelect = true;//允许多选
	dwTemp.ReadOnly = "1";//编辑模式
	 
	String sButtons[][] = {
		{"true","","Button","确定","确定","confirm()","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
 <script>
 
 function confirm(){
    var serialNo=getItemValue(0,getRow(),"SerialNo"); 
	var recordArray = getCheckedRows(0);
	 if(recordArray.length < 1){
		 alert("请选择贷款信息！");
		 
	 }else if(recordArray.length == 1){
		 AsCredit.openFunction("FlowApply05","SerialNo="+serialNo);
			reloadSelf(); 
		 }else{
		 		var relaSerialNos = '';
				if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {	
						for(var i = 0;i < recordArray.length;i++){
							var serialNo = getItemValue(0,recordArray[i],"SERIALNO");
							relaSerialNos += "@'"+serialNo+"'";
					}
						}
			
		var sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.riskclassify.RiskTypeSame","execute","serialNo="+relaSerialNos );
	    if(sReturn=='1'){
	    	 var sUrl = "/RiskClassify/DoubleAdjust.jsp";
			 OpenPage(sUrl+'?SerialNo=' + relaSerialNos,'_self','');
	    }else{
	    	alert('当前分类方式不同，不能批量调整');
	    }
		 }
	 }
			
 </script>
 <%@include file="/Frame/resources/include/include_end.jspf"%>
