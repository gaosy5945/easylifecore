<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//ASObjectModel doTemp = new ASObjectModel("CLSRApplyingList");
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	String status = CurPage.getAttribute("Status");
	if(status==null)status="";
	
	String dowhere = "";
	if(status.indexOf("@")>0){
		String [] statsList = status.split("@");
		for(int i=0;i<statsList.length;i++){
			dowhere += " O.FLOWTODOSTATUS='"+statsList[i]+"' or ";
		}
		dowhere = dowhere.substring(0, dowhere.lastIndexOf("or"));
	}else{
		dowhere += " O.FLOWTODOSTATUS='"+status+"'";
	}
	dowhere = " and ("+dowhere+")";
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("OrgID", CurUser.getOrgID());
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CLSRApplyingList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	doTemp.setJboWhere(doTemp.getJboWhere() + dowhere);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{("1".equals(status)?"true":"false"),"All","Button","额度暂停","额度暂停","add()","","","","",""},
			{("1".equals(status)?"true":"false"),"All","Button","额度恢复","额度恢复","recoverApply()","","","","",""},
			{("1".equals(status)||"2".equals(status)?"true":"false"),"All","Button","处理","处理","deal()","","","","",""},
			{"true","All","Button","额度详情","额度详情","view()","","","","",""},
			{("1".equals(status)?"true":"false"),"All","Button","删除","删除","deleteRecord()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function add(){
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		var returnValue = AsDialog.SelectGridValue("SelectCLNSList", "20,"+inputOrgID, "SerialNo@Status","", "","","","1");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		returnValue = returnValue.split("@");
		var CLSerialNo = returnValue[0];
		var preStatus = returnValue[1];
		
		var checkresult = CreditLineManage.checkCL(CLSerialNo);
		if("true"!=checkresult){
			alert("当前额度有在途的未生效的额度调整交易，不可进行额度暂停操作！");
			return;
		}
		
		CreditLineManage.importCLStopApply(CLSerialNo, preStatus, inputOrgID , inputUserID,  inputDate);
		reloadSelf();
	}
	
	function deal(){
		
		var COSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		var BCSerialNo = getItemValue(0,getRow(0),"BCSERIALNO");
		
		if(typeof(COSerialNo)=="undifined"||COSerialNo.length==0){
			alert(getHtmlMessage(1));
			return;
		}
		
		AsCredit.openFunction("CLStopApplyTab","BCSerialNo="+BCSerialNo+"&COSerialNo="+COSerialNo+"&doStatus=<%=status%>");
		reloadSelf();
	}
	function recoverApply(){
		
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>";
		var returnValue = AsDialog.SelectGridValue("SelectCLNSList", "30,"+inputOrgID, "SerialNo@Status","", "","","","1");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		
		returnValue = returnValue.split("@");
		var CLSerialNo = returnValue[0];
		var preStatus = returnValue[1];
		
		var checkresult = CreditLineManage.checkCL(CLSerialNo);
		if("true"!=checkresult){
			alert("当前额度有在途的未生效的额度调整交易，不可进行额度恢复操作！");
			return;
		}
		
		CreditLineManage.importCLStopApply(CLSerialNo, preStatus, inputOrgID, inputUserID, inputDate);
		reloadSelf();
	}
	
	function view(){
		var SerialNo = getItemValue(0,getRow(0),"BCSERIALNO");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("请选择一笔申请！");
			return;
		}
		AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&RightType=ReadOnly");
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_delete("myiframe0");
		}
		reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
