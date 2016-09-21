<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = "交易记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String objectNo = CurPage.getParameter("ObjectNo");//对象编号
	String objectType =  CurPage.getParameter("ObjectType");//对象类型
	if(objectNo == null)objectNo = "";
	if(objectType == null)objectType = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "Acct_Transaction";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);
	
	//生成HTMLDataWindow
	
	String sButtons[][] = {
			{"true", "", "Button", "交易详情", "交易详情","viewLoanRecord()",""},
			{"true", "", "Button", "分录详情", "分录详情","viewSubjectRecord()",""},
	};
	%> 

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=查看及修改交易详情;InputParam=无;OutPutParam=无;]~*/
	function viewLoanRecord()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var documentType = getItemValue(0,getRow(),"DocumentType");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		if(typeof(documentType)=="undefined" || documentType.length==0) {
			alert("此类交易没有详情信息！")
		}else{
		   	OpenComp("TransactionInfo","/Accounting/Transaction/TransactionInfo.jsp","SerialNo="+serialNo+"&RightType=ReadOnly","_blank","");	
		}
	}
	
	/*~[Describe=查看及修改分录详情;InputParam=无;OutPutParam=无;]~*/
	function viewSubjectRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
		    OpenComp("LoanDetailList","/Accounting/LoanDetail/LoanDetailList.jsp","TransSerialNo="+sSerialNo,"_blank","");	
		}
	}
</script>


<script type="text/javascript">	



// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/Frame/resources/include/include_end.jspf"%>
