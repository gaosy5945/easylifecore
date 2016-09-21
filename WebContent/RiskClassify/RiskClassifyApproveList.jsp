<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_RISK_APPROVE");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.MultiSelect = true;//允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","单笔认定","单笔认定","ensure()","","","","",""},
			{"true","","Button","批量认定","批量认定","doubleensure()","","","","",""},
			{"true","","Button","申请详情","申请详情","viewAndEdit()","","","","",""},
			{"true","","Button","提交","提交","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function ensure(){
	
	var recordArray = getCheckedRows(0);
	 if(recordArray.length > 1){
		 alert("发起单笔认定时只能选择一笔信息！");}else{
		 
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	AsControl.PopComp("/RiskClassify/SingleConfirm.jsp", "SerialNo="+serialNo);
	reloadSelf();
	}
	}
	
function doubleensure(){
	var recordArray = getCheckedRows(0);
	 if(recordArray.length < 1){
		 alert("请选择贷款信息！");	 
	 }else{
		 		var relaSerialNos = '';
				if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {	
						for(var i = 1;i <= recordArray.length;i++){
							var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
							relaSerialNos += "@'"+serialNo+"'";
	
					}
						}		
	 var sUrl = "/RiskClassify/DoubleConfirm.jsp";
	 OpenPage(sUrl+'?SerialNo=' + relaSerialNos,'_self','');
	//AsControl.PopComp(sUrl, "SerialNo="+relaSerialNos);
}
}

function viewAndEdit(){
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) 
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}
	AsControl.PopComp("/RiskClassify/SingleAdjust.jsp", "SerialNo="+serialNo);
	reloadSelf();
}



	 
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
