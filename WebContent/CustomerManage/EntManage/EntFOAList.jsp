<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 企业应收应付帐款信息
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			SerialNo:流水号
			EditRight:--权限代码（01：查看权；02：维护权）
		HistoryLog:
			qfang 2011-06-13 增加传递参数"报表日期"：ReportDate
	 */
	String PG_TITLE = "企业应收应付帐款信息";
	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sRecordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
	if(sCustomerID == null) sCustomerID = "";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportDate == null) sReportDate = "";

	//定义表头				
	String sTempletNo="EntFOAList";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRecordNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增应收应付账款信息","newRecord()","","","",""},
		{"true","","Button","详情","查看应收应付账款信息详情","viewAndEdit()","","","",""},
		{"true","","Button","删除","删除应收应付账款信息","deleteRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?EditRight=02&ReportDate=<%=sReportDate%>","_self","");
	}

	function deleteRecord(){
	  	var sUserID=getItemValue(0,getRow(),"InputUserId");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>'){
    		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));	
	}

	function viewAndEdit(){
       var sUserID=getItemValue(0,getRow(),"InputUserId");//--用户代码
		if(sUserID=='<%=CurUser.getUserID()%>')
			sEditRight='02';
		else
			sEditRight='01';
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
        	alert(getHtmlMessage('1'));//请选择一条信息！
        	return;
       }else{
        	OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
        }
    }

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>