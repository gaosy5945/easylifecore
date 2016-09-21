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
	//EXPIATEAMOUNT DA�ĵ�ծ���
	ASResultSet rs = null;
	SqlObject so = null;
	String sSql =  " select CREDITEDAMOUNT  from NPA_DEBTASSET   where SerialNo =:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sDASerialNo);
   	rs = Sqlca.getASResultSet(so);   	
   	if(rs.next()){
   		CREDITEDAMOUNT = rs.getString("CREDITEDAMOUNT");
	}
	//����ֵת��Ϊ���ַ���
	if(CREDITEDAMOUNT == null) CREDITEDAMOUNT = "0.00";
 	rs.getStatement().close(); 
	
	String sTempletNo = "AccountBalanceChangesInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
		//OpenPage("/RecoveryManage/PDAManage/PDADailyManage/AccountBalanceChangesList.jsp", "_self");
	}
	//  ��ȡ����ծ�ʲ���Ŀ��Ԫ��= ���˼�ֵ-���ۼƴ�������+�ۼƴ��÷��ã�-������ʧ+������ֵ+��������
	function getJudgePaysum(){
		var APPLYSUM = getItemValue(0,getRow(0),'APPLYSUM');//���˼�ֵ��Ԫ��
		var JUDGESUM = getItemValue(0,getRow(0),'JUDGESUM');//�ۼƴ�������
		var CONFIRMPI = getItemValue(0,getRow(0),'CONFIRMPI');//�ۼƴ��÷���
		var CONFIRMFEE = getItemValue(0,getRow(0),'CONFIRMFEE');//�ۼƴ�����ʧ
		var LAWYERFEE = getItemValue(0,getRow(0),'LAWYERFEE');//�ۼƴ�����ֵ
		var OTHERFEE = getItemValue(0,getRow(0),'OTHERFEE');//��������
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
