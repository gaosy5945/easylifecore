<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDASerialNo = CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";
	String sBookType = CurPage.getParameter("BookType");
	if(sBookType == null) sBookType = "";

	String CREDITEDAMOUNT = "0.00";
	//EXPIATEAMOUNT DA的抵债金额
	ASResultSet rs = null;
	SqlObject so = null;
	String sSql =  " select CREDITEDAMOUNT  from NPA_DEBTASSET   where SerialNo =:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sDASerialNo);
   	rs = Sqlca.getASResultSet(so);   	
   	if(rs.next()){
   		CREDITEDAMOUNT = rs.getString("CREDITEDAMOUNT");
	}
	//将空值转化为空字符串
	if(CREDITEDAMOUNT == null) CREDITEDAMOUNT = "0.00";
 	rs.getStatement().close(); 
	
	String sTempletNo = "AccountBalanceChangesInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
		//OpenPage("/RecoveryManage/PDAManage/PDADailyManage/AccountBalanceChangesList.jsp", "_self");
	}
	//  获取：抵债资产科目余额（元）= 入账价值-（累计处置收入+累计处置费用）-处置损失+处置增值+其他增减
	function getJudgePaysum(){
		var APPLYSUM = getItemValue(0,getRow(0),'APPLYSUM');//入账价值（元）
		var JUDGESUM = getItemValue(0,getRow(0),'JUDGESUM');//累计处置收入
		var CONFIRMPI = getItemValue(0,getRow(0),'CONFIRMPI');//累计处置费用
		var CONFIRMFEE = getItemValue(0,getRow(0),'CONFIRMFEE');//累计处置损失
		var LAWYERFEE = getItemValue(0,getRow(0),'LAWYERFEE');//累计处置增值
		var OTHERFEE = getItemValue(0,getRow(0),'OTHERFEE');//其他增减
		if(typeof(APPLYSUM) == "undefine" || APPLYSUM == null || APPLYSUM == "" || APPLYSUM.length == 0) APPLYSUM = "0.00";
		if(typeof(JUDGESUM) == "undefine" || JUDGESUM == null || JUDGESUM == "" || JUDGESUM.length == 0) JUDGESUM = "0.00";
		if(typeof(CONFIRMPI) == "undefine" || CONFIRMPI == null || CONFIRMPI == "" || CONFIRMPI.length == 0) CONFIRMPI = "0.00";
		if(typeof(CONFIRMFEE) == "undefine" || CONFIRMFEE == null || CONFIRMFEE == "" || CONFIRMFEE.length == 0) CONFIRMFEE = "0.00";
		if(typeof(LAWYERFEE) == "undefine" || LAWYERFEE == null || LAWYERFEE == "" || LAWYERFEE.length == 0) LAWYERFEE = "0.00";
		if(typeof(OTHERFEE) == "undefine" || OTHERFEE == null || OTHERFEE == "" || OTHERFEE.length == 0) OTHERFEE = "0.00";

		var JUDGEPAYSUM = parseFloat(APPLYSUM) - parseFloat(JUDGESUM) + parseFloat(CONFIRMPI) - parseFloat(CONFIRMFEE) + parseFloat(LAWYERFEE) + parseFloat(OTHERFEE);
		if(typeof(JUDGEPAYSUM) == "undefine" || JUDGEPAYSUM == null || JUDGEPAYSUM == "" || JUDGEPAYSUM.length == 0) JUDGEPAYSUM = "0.00";
		setItemValue(0,getRow(),"JUDGEPAYSUM",JUDGEPAYSUM);//
		 
	}
	
	function setApplySum(){
		//if(getRow() == 0){
			var CREDITEDAMOUNT = "<%=CREDITEDAMOUNT%>";
			setItemValue(0,getRow(),"APPLYSUM",CREDITEDAMOUNT);
		//}
			getJudgePaysum();
	}
	
	function initRow() {
		setItemValue(0,0,"LAWCASESERIALNO","<%=sDASerialNo%>");
		setItemValue(0,0,"BOOKTYPE","<%=sBookType%>");
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");		
		setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");	
		setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	initRow();
	setApplySum();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
