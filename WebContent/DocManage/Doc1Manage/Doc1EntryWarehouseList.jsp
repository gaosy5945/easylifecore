<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<!-- 
	该页面用于一类业务资料管理中的 入库管理模块的相关操作
	    1.该页面显示两个TAB页：待入库 和 已入库
	    2.在待入库Tab页的列表显示资料状态为"待入库"的业务信息
	    	> 单击页面新增按钮时，将放款成功的一类业务资料的信息新增到状态变更为 "待入库"
	       
	    3.在已入库Tab页的列表中显示2中已入库的业务资料信息

 -->
<%	
	String sEntryType = CurComp.getParameter("EntryType");
	if(sEntryType==null) sEntryType ="";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc1EntryWarehouseList");
 	//业务资料状态 ：STATUS 01：待封包   02：已封包待入库  03：已入库   yjhou  2015.02.26
	if("0010".equals(sEntryType)){//待封包
		 sWhereSql =  " and O.STATUS='02'"+
		              " and exists (select OB.belongorgid from jbo.sys.ORG_BELONG OB where OB.orgid = '"+CurOrg.getOrgID()+"' and OB.belongorgid = O.manageorgid)"+
				 	  " and O.INPUTUSERID='"+CurUser.getUserID()+"'";
		 doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}else if("0030".equals(sEntryType)){//已入库
		sWhereSql =  " and O.STATUS='03' and O.INPUTUSERID='"+CurUser.getUserID()+"'";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
 	//modify by liuzq 20150320
	else if("0040".equals(sEntryType)){//已出库
		sWhereSql =  " and O.STATUS='04' and O.INPUTUSERID='"+CurUser.getUserID()+"'";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	if(sEntryType=="0030" || "0030".equals(sEntryType)){//已入库
		dwTemp.MultiSelect = false; //允许多选
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","取消","删除","deleteRecord()","","","","btn_icon_delete",""},
			{"false","","Button","清单打印","清单打印","printList()","","","","btn_icon_detail",""},
			{"false","All","Button","提交","入库","entryWarehouse()","","","","btn_icon_detail",""},
			{"false","All","Button","出库","出库","OutOfWarehouse()","","","","btn_icon_detail",""},//modify by liuzq 20150320
			{"false","All","Button","影像扫描","影像扫描","imageScanning()","","","","btn_icon_detail",""},
		};
	
	if(sEntryType=="0010" || "0010".equals(sEntryType)){//待封包
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
		//sButtons[6][0] = "true";
	}else	if(sEntryType=="0030" || "0030".equals(sEntryType)){//已入库
		sButtons[5][0] = "true";//modify by liuzq 20150320
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//新增已抵押待封包的押品信息
	function add(){
		 var sUrl = "/DocManage/Doc1Manage/Doc1EntryWarehouseRelativeList.jsp";
		 var dialogStyle = "dialogWidth=700px;dialogHeight=800px;";
		 AsControl.PopComp(sUrl,' ',''); 
		  reloadSelf();
	}
	//查看押品详情
	function edit(){//参照押品详情
		/*  var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
			 return;
		 }else if(arr.length > 1){
			 alert("请选择一条数据！");
			 return;
		 }else{ */
			var serialNo=getItemValue(0,getRow(),"OBJECTNO");	
			var assetType=getItemValue(0,getRow(),"AssetType");	
			var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
			templateNo = templateNo.split("@");
			if(templateNo[0]=="false"){
				alert("未配置"+returnValue[1]+"的模板！");
				return;
			}
			var assetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
			<%-- AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&VouchType=<%=vouchType%>&TemplateNo="+templateNo[1], ""); --%>
			AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&TemplateNo="+templateNo[1]+"&Mode=1&DocFlag=DocType");
		 //}
	}
	//取消新增的已抵押待封包的押品信息
	function deleteRecord(){
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{ 
			if(confirm('确实要删除吗?')){
						//执行删除操作：删除doc_file_package表中对应的数据信息
						 for(var i=0;i<arr.length;i++){
							 //获取要删除的对象编号：即doc_file_package表中的ObjectNo
							 var sDFPSerialNo = getItemValue(0,arr[i],'OBJECTNO');
							 if(sDFPSerialNo == null) sDFPSerialNo = "";
								var sSql = "delete doc_file_package dfp where dfp.objectno='"+sDFPSerialNo+"'";
								var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
						 }
						as_delete(0);
						if(sReturnValue > -1){ 
							sMsg = "删除成功！";
						}else {
							sMsg = "删除失败！";
						}
			}
		}
		 reloadSelf();//执行完成后重新加载当前页面
	}
	
	//清单打印
	function printList(){
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
			 return;
		 }else if(arr.length > 1){
			 alert("请选择一条数据！");
			 return;
		 }else{
			 var sAissetSerialNo = getItemValue(0,getRow(),"ASSETSERIALNO");
			 var sContractSerialNo = getItemValue(0,getRow(),"CONTRACTSERIALNO");
			 if(typeof(sAissetSerialNo)=="undefined" || sAissetSerialNo.length==0 ){
					alert("请选择一条数据！");
					return ;
			 }
			 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc1MaterialList.jsp";
			 AsControl.PopComp(sUrl,"SerialNo="+sAissetSerialNo+"&ContractSerialNo="+sContractSerialNo,"");
	     }
	} 
	
	//入库操作
	function entryWarehouse(){
		 var sAISerialNoList = "";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{
			if(confirm('是否确定入库 ?')){ 
				 for(var i=0;i<arr.length;i++){
					 var sAISerialNo =  getItemValue(0,arr[i],'ASSETSERIALNO') ;
					 var sObjectNo =  getItemValue(0,arr[i],'OBJECTNO');//获取对象编号：担保合同关联流水号
					 var sObjectType =  "jbo.guaranty.GUARANTY_RELATIVE"; 
					 //sAISerialNoList += sAISerialNo + "@";
					 var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "EntryWarehouseAdd", "AISerialNo="+sAISerialNo+",ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,DataDate=<%=StringFunction.getToday()%>");
				 }
				 
					 <%-- var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "EntryWarehouseAdd",  "AISerialNoList="+sAISerialNoList+",ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,DataDate=<%=StringFunction.getToday()%>"); --%>
				 if(sReturn == "true"){
						 alert("入库成功！");
				 }else {
						 alert("入库失败!");
					     return;
			    }  
			 }
		}
		 reloadSelf();
	}
	
	//modify by liuzq 20150320 
	function OutOfWarehouse(){
		var sDfpSerialNo = getItemValue(0, getRow(), "SERIALNO");
		var sAISerialNo = getItemValue(0,getRow(0),"ASSETSERIALNO");
		if(typeof(sDfpSerialNo)=="undefined" || sDfpSerialNo.length==0 ){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return ;
		}
		<%-- var sPara = "DFPSerialNo="+sDfpSerialNo+",DOSerialNo="+sDOSerialNo+",OutType=01,TransCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			sDOSerialNo = returnValue;
		 	AsControl.PopComp("/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp","DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType=0010&RightType=All","");
			reloadSelf();
		} --%>
		//modify by lzq 20150331 一类业务资料出库
		var sNextDOSerialNo =  getItemValue(0, getRow(), "PACKAGEID");//下一步DOSerialNo
		//var sDOSerialNo =  getSerialNo("DOC_OPeration","SerialNo","");
		var sPara = "RightType=All";
		sPara = "&DOSerialNo="+sNextDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType=0010&DFPSerialNo="+sDfpSerialNo;
	 	AsControl.PopComp("/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp",sPara,"");
		reloadSelf();
	}
	//影响扫描
	function imageScanning(){
		var CONTRACTSERIALNO = getItemValue(0,getRow(),"CONTRACTSERIALNO");
		if(typeof(CONTRACTSERIALNO)=="undefined" || CONTRACTSERIALNO.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		AsCredit.openFunction("ImageDoc1Info","ContractSerialNo="+CONTRACTSERIALNO);
		reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
