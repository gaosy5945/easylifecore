<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "账户监控详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数:账号
	String sAccount =  CurComp.getParameter("Account");
	String sCustomerID =  CurComp.getParameter("CustomerID");
	String sSerialNo    = CurPage.getParameter("SerialNo");
	if(sAccount==null ) sAccount = "";
	if(sCustomerID == null ) sCustomerID = "";
	if(sSerialNo == null ) sSerialNo = "";

	String sCustomerName =  Sqlca.getString(new SqlObject("select CustomerName from ACCOUNT_INFO where CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID));
	if(sCustomerName == null ) sCustomerName = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountScoutInfo"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,sTempletFilter);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
    };
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		
	    as_save("myiframe0");
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function goBack(){
        self.close();
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"Account","<%=sAccount%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"DataLeadMode","010");		
			bIsInsert = true;
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "ACCOUNT_WASTEBOOK";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>