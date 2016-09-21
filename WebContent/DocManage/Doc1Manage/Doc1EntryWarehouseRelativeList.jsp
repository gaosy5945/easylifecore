<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("Doc1EntryWarehouseRelativeList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	//追加查询条件：只查询显示对象类型为"担保信息"且押品状态为"未抵押"的押品列表
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	
	dwTemp.setPageSize(20);
	dwTemp.setParameter("OrgId", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确定添加押品","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","押品详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","取消并返回","删除","cancelBack()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//新增生效的押品信息
	function add(){
		var sDFIInfoList = "";
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{
			 for(var i=0;i<arr.length;i++){
				 var sObjectNo =  getItemValue(0,arr[i],'SERIALNO');//担保合同关联流水号
				 var sObjectType =  "jbo.guaranty.GUARANTY_RELATIVE";//操作对象类型
				 var sAssetSerialNo =  getItemValue(0,arr[i],'ASSETSERIALNO');//押品编号
				//判断当前押品关联的担保合同是否已完成入库
				 var sSql = "select count(*) from doc_file_package where objectNo ='"+sObjectNo+"'";
				 var sReturnCount =  RunMethod("PublicMethod","RunSql",sSql);
				 if(sReturnCount>0){
					 alert("押品编号 ["+sAssetSerialNo+"] 已完成入库操作！");
					 return;
				 }else{
					 sDFIInfoList = "ObjectType="+sObjectType +",ObjectNo="+sObjectNo;
					 var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "insertDocFilePackage", sDFIInfoList+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
				 }  
			}
			 if(sReturn == "true"){
				alert("添加成功！");
				self.close();
			 }else {
				alert("添加失败!");
				return;
			}
		}
		 //var sUrl = "";
		 //AsControl.OpenPage(sUrl,'_self','');
	}
	
	function edit(){//参照押品
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
			 return;
		 }else if(arr.length > 1){
			 alert("请选择一条数据！");
			 return;
		 }else{
			var serialNo=getItemValue(0,getRow(),"ASSETSERIALNO");		 
			var assetType=getItemValue(0,getRow(),"AssetType");	
			var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
			templateNo = templateNo.split("@");
			if(templateNo[0]=="false"){
				alert("未配置"+returnValue[1]+"的模板！");
				return;
			}
			var assetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
			AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+serialNo+"&TemplateNo="+templateNo[1]+"&Mode=1&DocFlag=DocType");
		}
	}
	function deleteRecord(){
		var sUrl = "/DocManage/Doc1Manage/Doc1EntryWarehouseList.jsp";
	}
	function cancelBack(){
		//if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))');
		self.close();
		//var sUrl = "/DocManage/Doc1Manage/Doc1EntryWarehouseList.jsp";
		//AsControl.OpenPage(sUrl,'' ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
