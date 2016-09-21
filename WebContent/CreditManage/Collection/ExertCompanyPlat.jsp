<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sStatus = CurPage.getParameter("Status");
	if(StringX.isEmpty(sStatus)||sStatus==null) sStatus = "";
	String sWhereSql = "";
	//获取前端传入的参数
    //String sTemplateNo = DataConvert.toString(CurPage.getParameter("TestCustomerList"));//模板号
	//ASObjectModel doTemp = new ASObjectModel("OutsourcingCollectionList");
    //O.status:0-未任务分配的催收，1-已任务分配未登记任务催收结果的催收，2-已登记任务催收结果的催收
    BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = new ASObjectModel("OutsourcingCollectionList"); 
	//ObjectWindowHelper.createObjectModel("OutsourcingCollectionList",inputParameter,CurPage);

	//doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
   if(StringX.isEmpty(sStatus)||sStatus==null){
    	sWhereSql = " and O.Status is null";
    }else{
    	sWhereSql = " and O.Status='" + sStatus + "'";
    }
    sWhereSql+=" AND O.COLLECTIONMETHOD='5' ";  
    String sRoleInfo []={"PLBS0014"};
	if(CurUser.hasRole(sRoleInfo)){
		sWhereSql+=" and exists (select 1 from v.org_belong where v.belongorgid=AL.OperateOrgID and v.OrgID='"+CurUser.getOrgID()+"') ";
	}else{
		sWhereSql+=" and AL.OperateUserID='"+CurUser.getUserID()+"' ";
	}
    doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	 
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);

	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","数据导出","数据导出","exportExcel()","","","",""},
			{"true","All","Button","催收结果导入","催收结果导入","inExcel()","","","","",""},
			{"true","All","Button","外包催收登记","外包催收登记","exertinsert()","","","","",""},
			{"false","","Button","催收详情","催收详情","CollectionInfo()","","","","",""},
		};
	if("2".equals(sStatus)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "true";
	}
	%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

<script type="text/javascript">
	function exportExcel(){
		/* var sExportUrl = "/CreditManage/Collection/OutsourcingExportList.jsp";
		var sBatchNoList = "";
		var sBDSerialNoList = "";
		var sBatchNoOneFlag = "";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("请输入当前任务批次信息！");
		 }else{
			for(var i=0;i<arr.length;i++){
				var sBDSerialNo = getItemValue(0,arr[i],'SERIALNO');
				if(sBDSerialNo == null) sBDSerialNo = "";
				var sTaskBatchNo = getItemValue(0,arr[i],'TASKBATCHNO');
				if(sTaskBatchNo == null) sTaskBatchNo = "";
				if(i==0 || (i>0 && sBatchNoOneFlag == sTaskBatchNo)){
					sBatchNoOneFlag = sTaskBatchNo;
				}else{
					alert("请只选择一个批次下得催收任务！");
					return;
				}
				sBDSerialNoList += sBDSerialNo + ",";
				sBatchNoList += sTaskBatchNo + ",";
			 }
		 }
		 AsControl.PopComp(sExportUrl,'BatchNoList=' +sBatchNoList+'&BDSerialNoList='+sBDSerialNoList,'');
		 reloadSelf(); */
		 if(confirm("是否导出当前批次当前催收信息！")){
				exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
				 //export2Excel("myiframe0");
				 //amarExport("myiframe0");
		}
	}
	
	function inExcel(){
		//外包催收结果excel导入
		
		var pageURL = "/CreditManage/Collection/CollExcelImport.jsp";
	    var parameter = "clazz=jbo.import.excel.OUT_COLL_IMPORT&InputUserId=<%=CurUser.getUserID()%>";
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	
	function exertinsert(){
		//外包催收结果登记
		var sResUrl = "/CreditManage/Collection/OutCollRegistrateInfo.jsp";
		var sTaskBatchNo = "";
		var sCTSerialNo = "";
		var sOperateUserID="";
		var sOperateUserName="";
		//获取流水号
		sTaskBatchNo=getItemValue(0,getRow(),"TASKBATCHNO");
		sCTSerialNo=getItemValue(0,getRow(),"SERIALNO");
		sOperateUserID=getItemValue(0,getRow(),"OPERATEUSERID");
		sOperateUserName=getItemValue(0,getRow(),"OPERATEUSERNAME");
		if (typeof(sTaskBatchNo)=="undefined" || sTaskBatchNo.length==0 || typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		AsControl.PopComp(sResUrl,"TaskBatchNo="+sTaskBatchNo+"&CTSerialNo="+sCTSerialNo+"&OperateUserID="+sOperateUserID+"&OperateUserName="+sOperateUserName,'');
		reloadSelf();
	}
	
	function exertdetal(){
		//外包催收详情
		var sResListUrl = "/CreditManage/Collection/CollTaskProcessResultList.jsp";
		var sPTISerialNo = "";
		var sCTSerialNo = "";
		//获取流水号
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1 || arr.length>1){
			 alert("请选择一行数据！");
			 return;
		 }else{
			sPTISerialNo=getItemValue(0,arr[0],'TASKBATCHNO');
			sCTSerialNo=getItemValue(0,arr[0],'SERIALNO');
		 }
			//判断流水号是否为空
		if (typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert('请选择一条记录');
			return;
		}
		AsControl.PopComp(sResListUrl,'PTISerialNo=' +sPTISerialNo+'&CTSerialNo=' +sCTSerialNo+'&RightType=ReadOnly','');
		reloadSelf();
	}

	function CollectionInfo(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
	 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
		var contractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
	 	var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
	 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
	 	}
	 	
		AsCredit.openFunction("CollTaskInfo","DoFlag=check&ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType=ReadOnly");
	}
	
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
