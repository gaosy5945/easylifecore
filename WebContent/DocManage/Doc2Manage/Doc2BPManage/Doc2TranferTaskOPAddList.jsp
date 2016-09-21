<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
/**
业务资料移库 关联 业务资料（）信息
*/
	String sPTISerialNo = (String)CurComp.getParameter("PTISerialNo");
	if(null==sPTISerialNo) sPTISerialNo="";
	String sWhereSql = "";	

	ASObjectModel doTemp = new ASObjectModel("Doc2TranferTaskOPAddList");
	
	//sWhereSql = "";
	//doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确定","新增","add()","","","","btn_icon_add",""},
			//{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			//{"true","","Button","取消","取消","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","取消","返回","goBack()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 //var sMultiSelect = getItemValue(0,getRow(0),"MultiSelectionFlag");
		 var sPTISerialNo = "<%=sPTISerialNo%>";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{
			 alert("已经选择了"+arr.length+" 行！");
			 for(var i=0;i<arr.length;i++){
				 //alert("这是第:"+arr[i]+"行！");
				 var sDFPSerialNo =  getItemValue(0,arr[i],'SERIALNO');
	    		 var sObjectType = getItemValue(0,arr[i],'OBJECTTYPE');
	    		 var sObjectNo = getItemValue(0,arr[i],'OBJECTNO');
	    		 var sOperationType = "";//移库操作编号
	    		 //alert("["+sDFPSerialNo +"],["+sObjectType +"]<["+sObjectNo +"]"); 
	    		 var sFlag = checkIsInUse(sPTISerialNo,sObjectType,sObjectNo);
	    		 if(!sFlag){
	    			 var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskObjectAddAjax.jsp?OperationType="+sOperationType+"&PTISerialNo="+sPTISerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
	    			if(typeof(sReturn)!="undefined" && sReturn=="true"){
	    					//self.returnValue = "TRUE@" + sSerialNo + "@" + sObjectType + "@" + sObjectNo + "@";
	    					//self.close();
	    					alert("移库关联成功!");
	    			}else {
	    				alert("移库关联失败！");
	    			}
	    		 }else{
	    			 alert("该业务资料："+sDFPSerialNo+" 已经在其他批次了！");
	    		 }
			 }
		 }
		 
		 //self.close();
		 //var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp";
		 //AsControl.OpenPage(sUrl,'rightdown','');
	}
	
	function checkIsInUse(sPTISerialNo,sObjectType,sObjectNo){
		var sReturn = false;
		var sSql = "select count(serialNo) as cnt from doc_operation  where transactioncode='0080' and status='01' and  ObjectType='"+sObjectType+"' and ObjectNo ='"+sObjectNo+"'";
		var sReturnValue = RunMethod("PublicMethod","RunSql",sSql);
		//var sReturnValue = RunMethod("PublicMethod","SelectTranferObjectSql",sPTISerialNo+","+sObjectType+","+sObjectNo);
		if(sReturnValue > 0 && sReturnValue != null){
			sReturn = true;
		}
		return sReturn;
	}
	
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	function deleteRecord(){
		if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))');
	}
	function goBack(){
		var sPTISerialNo = "<%=sPTISerialNo%>";
		//self.close();
		//sUrl ="/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp";
		//AsControl.OpenPage(sUrl,'_self','');
		AsControl.OpenView("/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp","PTISerialNo="+sPTISerialNo+"","rightdown","");

	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
