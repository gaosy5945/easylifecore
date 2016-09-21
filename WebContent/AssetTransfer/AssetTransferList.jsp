<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//接收参数
	String projectStatus = DataConvert.toString(CurPage.getParameter("ProjectStatus"));//项目状态
 	String isPack = DataConvert.toString(CurPage.getParameter("isPack"));//是否已封包
	String isPool = DataConvert.toString(CurPage.getParameter("isPool"));//是否已入池 
    
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("ProjectTransferList");
	doTemp.setJboWhere("O.ProjectType like '02%' and O.status = :projectStatus");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	
	if("true".equals(isPack)||"true".equals(isPool)){
		dwTemp.MultiSelect = true;
	}else{
		dwTemp.MultiSelect = false;
	}
	
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(projectStatus);
	
	String sButtons[][] = {
		{"true".equals(isPack)&&"03".equals(projectStatus)?"true":"false","","Button","封包","封包","pack()","","","","",""},
		{"true".equals(isPool)?"true":"false","","Button","入池","入池","pool()","","","","",""},
		{"true".equals(isPack)&&"06".equals(projectStatus)?"true":"false","","Button","重新封包","重新封包","rePack()","","","","",""},
		{"true","","Button","项目详情","项目详情","check()","","","","btn_icon_detail",""},
	};
%> 
<script type="text/javascript">

	//项目详情
	function check(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sProjectType=getItemValue(0,getRow(),"ProjectType");
		var sProjectStatus=getItemValue(0,getRow(),"Status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		AsCredit.openFunction("ProjectAssetDetail","SerialNo="+sSerialNo+"&RightType=ReadOnly&ProjectStatus="+sProjectStatus+"&ProjectType="+sProjectType);
	}

	//封包
	function pack(){
		var recordArray = getCheckedRows(0);//获取勾选的行
 		var relaSerialNos = '';
 		var status = '06';//封包
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('确实要封包吗?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					relaSerialNos += serialNo+"@";
				}
				var sResult = RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","serialNos="+relaSerialNos+",status="+status);
				if('true' == sResult){
					alert("封包成功");
					reloadSelf();
				}else{
					alert("封包失败");
				}
			}
		}else{
			alert("请先选择一条记录");
		} 
	}
	
	//重新封包
	function rePack(){
		var recordArray = getCheckedRows(0);//获取勾选的行
 		var relaSerialNos = '';
 		var status = '06';//重新封包
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('确实要重新封包吗?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					relaSerialNos += serialNo+"@";
				}
				var sResult = RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","serialNos="+relaSerialNos+",status="+status);
				if('true' == sResult){
					alert("重新封包成功");
					reloadSelf();
				}else{
					alert("重新封包失败");
				}
			}
		}else{
			alert("请先选择一条记录");
		} 
	}
	
	// 资产入池
	function pool(){
		var recordArray = getCheckedRows(0);//获取勾选的行
 		var relaSerialNos = '';
 		var status = '0605';//入池
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('确实要入池吗?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
					relaSerialNos += serialNo+"@";
				}
				var sResult = RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","serialNos="+relaSerialNos+",status="+status);
				if('true' == sResult){
					alert("入池成功");
					reloadSelf();
				}else{
					alert("入池失败");
				}
			}
		}else{
			alert("请先选择一条记录");
		} 
	}
   	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
