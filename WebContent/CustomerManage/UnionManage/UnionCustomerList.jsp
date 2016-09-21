<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerType = CurPage.getParameter("CustomerType");
	ASObjectModel doTemp = new ASObjectModel("UnionCustomerList");
	doTemp.setHtmlEvent("", "ondblclick", "viewAndEditByTab");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	//dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID()+","+customerType);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增客户群","newRecord()","","","","",""},
			{"true","","Button","详情","客户群详情","viewAndEditByTab()","","","","",""},
			{"true","","Button","删除","删除客户群","deleteRecord()","","","","",""},
			{"true","","Button","生效","客户群生效","setGroupFlag('10')","","","","",""},
			{"true","","Button","失效","客户群失效","setGroupFlag('20')","","","","",""}
		};
%> 
<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var groupID = AsControl.PopComp("/CustomerManage/UnionManage/UnionRegisterTempInfo.jsp", "CustomerType=<%=customerType%>", "resizable=yes;dialogWidth=770px;dialogHeight=700px;center:yes;status:no;statusbar:no","");
		if(typeof(groupID) != "undefined" && groupID.length != 0){
	    	AsCredit.openFunction("CustomerDetail","CustomerID="+groupID,"");
			//openObject("Customer",groupID,"001");
			reloadSelf();
		}
	}
	
	/*~[Describe=客户群详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditByTab(){
		var groupID = getItemValue(0,getRow(),"GroupId");//客户群编号
		if (typeof(groupID)=="undefined" || groupID.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsCredit.openFunction("CustomerDetail","CustomerID="+groupID+"&PG_CONTENT_TITLE=show","");
		//openObject("Customer",groupID,"001");
		reloadSelf();	
	}
	
	/*~[Describe=删除信息;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var groupID = getItemValue(0,getRow(),"GroupID");//客户群编号
		if (typeof(groupID)=="undefined" || groupID.length==0){
			alert("请选择一条记录！");
			return;
		}
		var managerUser = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "getManageUser", "unionID="+groupID);
		if(managerUser != "<%=CurUser.getUserID()%>"){
			alert("非管户人无法删除客户群!");
			return;
		}
		//检查客户是否存在未结清的在途业务申请
		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApply","customerID="+groupID);
		if(sReturn == "true"){
			alert("该客户存在在途的业务申请，无法无法删除！");
			return;
		}
     	//检查客户是否存未审批完成的批复
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApprove","customerID="+groupID);
		if(sReturn == "true"){
			alert("该客户存在未审批完成的批复，无法删除！");
			return;
		}
     	//检查客户是否存在未“登记完成”的合同
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessContract","customerID="+groupID);
		if(sReturn == "true"){
			alert("该客户存在未“登记完成”的合同！");
			return;
		}
		if(confirm("确定要将所选客户群信息删除吗？")){
				var sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","deleteUnion","unionID="+groupID);
				if(sReturnValue == "true"){
				 	alert("客户群删除成功!");
				 	reloadSelf();
				}else{
					alert("删除失败！");
				}
	 	}
	}
	
	/*~[Describe=客户群失效/生效;InputParam=无;OutPutParam=无;]~*/
	function setGroupFlag(flag){
		var status = getItemValue(0,getRow(),"STATUS");//客户群状态
		var groupID = getItemValue(0,getRow(),"GroupID");//客户群编号
		
		if (typeof(groupID)=="undefined" || groupID.length==0){
			alert("请选择一条记录！");
			return;
		}
		var managerUser = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "getManageUser", "unionID="+groupID);
		if(managerUser != "<%=CurUser.getUserID()%>"){
			alert("非管户人无法更改客户群状态!");
			return;
		}
		if(flag == '10'){//生效
			if(status != '30'){//30为待生效状态
				alert("只有[待生效]状态的客户群才能发起生效！");
				return;
			}
			//判断该客户群下的成员是否存在其他的有效的客户群中，如果存在，则不能把该客户群置为“有效”
			var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMember","unionID="+groupID);
			if(sReturn == 'true'){//存在
				alert("该客户群下的成员存在于其他有效的客户群中，不能进行生效操作！");
				return;
			}else{//不存在
				var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "setUnionStatus", "unionID="+groupID+",status=10");
				if(result == "true"){
					alert("该客户群已成功生效！");
					reloadSelf();
				}
			}
		}else if(flag == '20'){//失效
			if(status != "10"){//10为生效状态
				alert("只有[生效]状态的客户群才能发起失效！");
				return;
			}
			//检查是否存在在途授信业务申请
			var result = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "checkUnionApply", "unionID="+groupID);
			if(result == "true"){
				alert("该客户群下存在在途授信业务申请，不能进行失效操作！");
				return;
			}
			
			if(confirm("是否确认失效该客户群？")){
				result = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction", "setUnionStatus", "unionID="+groupID+",status=20");
				if(result == "true"){
					alert("该客户群已成功失效！");
					reloadSelf();
				}
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>