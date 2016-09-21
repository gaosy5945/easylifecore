<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ContractArtificialNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null){
		objectType = "jbo.app.BUSINESS_CONTRACT";
	}
    String sStatus = CurPage.getParameter("Status");
    String sTransActionCode = CurPage.getParameter("TransActionCode");
	String sFlag = CurPage.getParameter("flag"); 
	String sRightType = CurPage.getParameter("RightType"); 
	String sApplyType = CurPage.getParameter("ApplyType");
	ASObjectModel doTemp = new ASObjectModel("DocFileInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	if("approve".equals(sFlag)||"03".equals(sApplyType)){
		dwTemp.MultiSelect = true;
	} 
	if("ReadOnly".equals(sRightType) || "ReadOnly" == sRightType){
		dwTemp.MultiSelect = false;
	}else{
		dwTemp.MultiSelect = true; //允许多选
	}
	/* if("01".equals(sStatus)||"01".equals(sStatus)){
		dwTemp.MultiSelect = true;//新增阶段
	}else{
		dwTemp.MultiSelect = false;//
	} */
	dwTemp.setPageSize(100);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","All","Button","删除","删除","del()","","","","",""},
			{"false","All","Button","出库","出库","update()","","","","",""},
		};
	//已入库和审批中的业务资料不可以新增业务资料
	if("approve".equals(sFlag)||"03".equals(sApplyType)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "true";
	}
	if("03".equals(sStatus)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}
	sButtons[2][0] = "false";//屏蔽出库按钮，modify by liuzq 20150320
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var objectNo = "<%=objectNo%>";
		var objectType = "<%=objectType%>";
		var returnValue = "";
		var inputParameters={"ObjectNo":objectNo};
		if(objectType == "jbo.app.BUSINESS_CONTRACT" || objectType == "jbo.app.BUSINESS_APPLY"){
			returnValue = AsCredit.selectJavaMethodTree("com.amarsoft.app.als.prd.web.ui.SelectDocFileConfig",inputParameters,"","Y");
		}else{
			returnValue = AsCredit.selectMultipleTree("SelectDocFileConfig", "ObjectNo,"+objectNo, ",", "");
		}
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == null) return;
		
		if(returnValue["ID"] == null || returnValue["ID"].length == 0 || returnValue["ID"] == "_NONE_" || returnValue["ID"] == "_CANCEL_") return;
		var fileID = returnValue["ID"];
		fileID = fileID.split(",");
		for(var i in fileID){
			if(typeof fileID[i] ==  "string" && fileID.length > 0 ){
				var ID = fileID[i];
        	AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "insertDFI", "ID="+ID+",ObjectNo="+objectNo);
			}
		}
		reloadSelf();
	}
	
	function del(){
		var objectNo = "<%=objectNo%>";
		var fileIDs = "";
		var recordArray = getCheckedRows(0);//获取勾选的行
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1){
			if(!confirm('确实要删除吗?')) return;
			for(var i = 1;i <= recordArray.length;i++){
				var ID = getItemValue(0,recordArray[i-1],"FileID");
				var status = getItemValue(0,recordArray[i-1],"STATUS");
				if(status=="03")
				{
					alert("该资料不能删除！");
					continue;
				}
				var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "ifCanDelete", "FileID="+ID+",ContractNo="+objectNo);
				if(returnValue.split("@")[0] == "false"){
					alert("【"+returnValue.split("@")[1]+"】为必选项，不能删除!");
					continue;
				}else{
					fileIDs += (ID+"@");
				}
			}
		}else{
			alert("请选择要删除的资料！");
		}
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "delFiles", "ObjectNo="+objectNo+",FileIDs="+fileIDs);
		reloadSelf();
	}
	
	//资料出库时变更业务资料状态
	function update(){
		var sTransActionCode = "<%=sTransActionCode%>";
		var sContractSerialNo = "<%=objectNo%>";
		var sStatus  = "";//业务资料状态
		if("0020"==sTransActionCode){//出库时
			sStatus = "08";//归还客户
		}else if("0030"==sTransActionCode){//出借时
			sStatus = "04";//借出
		}
		var arr = new Array();//声明数组：用来存放选择的要出库的业务资料编号
		arr = getCheckedRows(0);//将选中的行存到数组中
		if(arr.length < 1){
			 alert("您没有勾选任何行！");
		}else{
			 for(var i=0;i<arr.length;i++){
				 var sFileID =  getItemValue(0,arr[i],'FILEID');//业务资料编号 
				 //参数列表
				 sDFIInfoList = "Status="+sStatus +",ContractSerialNo="+sContractSerialNo+",FileID="+sFileID;
				 //执行变更状态的方法
				 AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.DocFileInfo", "updateFileInfoStatus", sDFIInfoList);
			}
		}
	}
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
