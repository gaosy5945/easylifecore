<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SelectProject");
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","新建零星期房项目","新建零星期房项目","newProject()","","","","",""},
			{"true","All","Button","合作项目详情","合作项目详情","viewProject()","","","","",""},
			{"true","All","Button","项下业务明细","项下业务明细","projectBusinessDetail()","","","","",""},
			{"true","All","Button","项目变更历史","项目变更历史","projectAlterHistory()","","","","",""},
			{"true","All","Button","项目附属信息变更","项目附属信息变更","projectOthersAlter()","","","","",""},
			{"true","All","Button","项目合并","项目合并","projectMerge()","","","","",""},
			{"true","All","Button","项目终止","项目终止","projectStop()","","","","",""},
			{"true","","Button","保证金缴纳明细","保证金缴纳明细","MrgDetail()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function newProject(){
		AsControl.PopPage("/ProjectManage/ProjectNewApply/NewZeroStarhouse.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	}
	
	function viewProject(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
		var status =  getItemValue(0,getRow(0),"STATUS");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		var RightType = "ReadOnly";
		if(status == "11" && projectType == "0110"){
			RightType = "All";
		}
	    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&RightType="+RightType+"&CustomerID="+customerID);
	    reloadSelf();
	}
	function projectBusinessDetail(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectQuery/ProjectBusinessDetail.jsp","SerialNo="+serialNo+"&ProjectType="+projectType,"resizable=yes;dialogWidth=880px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}
	function projectAlterHistory(){
		var serialNo =  getItemValue(0,getRow(0),"AGREEMENTNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectAlterNewApply/PrjAlterHistory.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=680px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}

	function projectOthersAlter(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		var status =  getItemValue(0,getRow(0),"STATUS");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		if(projectType == "0110" || projectType == "0108"){
			alert("该项目不允许变更附属信息！");
			return;
		}else{
			if(status == "13"){
				AsCredit.openFunction("ProjectOthersAlterInfo","ProjectSerialNo="+serialNo);
				reloadSelf();
			}else if(status == "14"){
				alert("该项目已复核否决，不允许进行附属信息变更！");
				return;
			}else if(status == "16"){
				alert("该项目已失效，不允许进行附属信息变更！");
				return;			
			}else{
				alert("该项目在申请中，不允许进行附属信息变更！");
				return;
			}
		}
	}
	function projectMerge(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		var status =  getItemValue(0,getRow(0),"STATUS");
		if(status == "13"){
			AsCredit.openFunction("ProjectMergeAlterInfo","ProjectSerialNo="+serialNo);
			reloadSelf();
		}else if(status == "14"){
			alert("该项目已复核否决，不允许进行项目合并！");
			return;
		}else if(status == "16"){
			alert("该项目已失效，不允许进行项目合并！");
			return;			
		}else{
			alert("该项目在申请中，不允许进行项目合并！");
			return;
		}
	}
	function projectStop(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		var projectStatus = getItemValue(0,getRow(0),"STATUS");
			if(projectStatus == "13"){
				var agreementNo = getItemValue(0,getRow(0),"AGREEMENTNO");
				var flag = ProjectManage.judgeIsAlterApply(agreementNo);
					if(flag == "1"){
						alert("该项目在变更申请阶段，不允许终止项目！");
						return;
					}else{
						AsCredit.openFunction("ProjectStopAlterInfo","ProjectSerialNo="+serialNo);
						reloadSelf();
					}
			}else if(projectStatus == "14"){
				alert("该项目已复核否决，不允许终止项目！");
				return;
			}else if(projectStatus == "16"){
				alert("该项目已失效，无需再次操作！");
				return;
			}else{
				alert("该项目处于申请阶段，不允许终止项目！");
				return;
			}
		}
	function MrgDetail(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
		var status =  getItemValue(0,getRow(0),"STATUS");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		if(status == "13"){
			var result = ProjectManage.getAccountNo(serialNo);
			result = result.split("@");
			if(result[0] == "0"){
				alert("该项目无保证金信息，无法缴纳保证金！");
				return;
			}else if(result[0] == "1"){
				alert("该项目无保证金账户账号，无法缴纳保证金!");
				return;
			}else{
				var AccountNo = result[1];
				AsControl.PopComp("/ProjectManage/ProjectNewApply/ProjectMarginDetailList.jsp","SerialNo="+serialNo+"&ProjectType="+projectType+"&AccountNo="+AccountNo+"&CustomerID="+customerID,"resizable=yes;dialogWidth=600px;dialogHeight=400px;center:yes;status:no;statusbar:no");
			}
		}else if(status == "14"){
			alert("该项目已复核否决，不允许进行保证金缴纳！");
			return;
		}else if(status == "16"){
			alert("该项目已失效，不允许进行保证金缴纳！");
			return;			
		}else{
			alert("该项目在申请中，不允许进行保证金缴纳！");
			return;
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
