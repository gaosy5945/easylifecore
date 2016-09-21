<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("BuildingRepairedList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "0";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
	
	String sButtons[][] = {
			{"true","","Button","新增楼盘","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","楼盘详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","清理楼盘","删除","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","停用","停用","stop()","","","","btn_icon_delete",""},
			{"true","","Button","启用","启用","start()","","","","btn_icon_delete",""},
			
		};
%> 
<script type="text/javascript">
	/*~[Describe=新增楼盘;InputParam=无;OutPutParam=无;]~*/
	function add(){
		var size ="resizable=yes;dialogWidth=30;dialogHeight=11;center:yes;status:no;statusbar:no";
		var serialNo = AsControl.PopView("/CustomerManage/PartnerManage/InitBuildIngInfo.jsp", "", size );
    	if(typeof(serialNo) == "undefined" || serialNo.length == 0 || serialNo == '_CANCEL_'){
			return;
		}
    	popComp("","/CustomerManage/PartnerManage/BuildingInfo.jsp","SerialNo="+serialNo,"");
    	reloadSelf();
	}
	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("","/CustomerManage/PartnerManage/BuildingInfo.jsp","SerialNo="+serialNo,"");
    	reloadSelf();
	}
	/*~[Describe=清理楼盘;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var status = getItemValue(0,getRow(0),"status");
		if(status=="1"){
			alert("正常状态的项目不能清理");
			return;
		}
		
		if(confirm('楼盘与关联的楼号信息都会被清理,确实要清理吗?')){
			var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.BuildingAction","remove","serialNo=" + serialNo);
			if(returnValue == "1"){
				//alert("清理成功");
				reloadSelf();
			}else if(returnValue == "3"){
				alert("此楼盘已被项目引用不能清理");
			}else{
				alert("清理失败");
				return;
			}
			
		}
	}
	
	/*~[Describe=修改状态;InputParam=无;OutPutParam=无;]~*/
	function stop()
	{
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var status = getItemValue(0,getRow(0),"status");
		if(status=="2"){
			alert("项目已经是停用状态");
			return;
		}
		var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.BuildingAction","updateStatus","serialNo=" + serialNo +",status=2");
		if(returnValue == "1"){
			//alert("停用成功");
			reloadSelf();
		}else if(returnValue == "3"){
			alert("此楼盘已被项目引用不能停用");
		}else if(returnValue == "2"){
			alert("停用失败");
		}
	}
	
	function start()
	{
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var status = getItemValue(0,getRow(0),"status");
		if(status=="1"){
			alert("项目已经是启用状态");
			return;
		}
		var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.BuildingAction","updateStatus","serialNo=" + serialNo +",status=1");
		if(returnValue == "1"){
			alert("启用成功");
			reloadSelf();
		}else{
			alert("启用失败");
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
