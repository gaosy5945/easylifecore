<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
//"SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&DASerialNo="+sDebtAssetSerialNo+"&AssetType="+sAssetType+"&AssetSerialNo="+sAssetSerialNo
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDAOSerialNo = CurPage.getParameter("SerialNo");
	if(sDAOSerialNo == null) sDAOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String sDASerialNo = CurPage.getParameter("DASerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sTransactionType = CurPage.getParameter("TransactionType");
	if(sTransactionType == null) sTransactionType = "";//���÷�ʽ
	String sAssetType = CurPage.getParameter("AssetType");
	if(sAssetType == null) sAssetType = "";
	String sAssetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	String sTransCode = CurPage.getParameter("TransCode");
	if(sTransCode == null) sTransCode = "";
	String sTempletNo = "PDADisposalBookInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	// 
	String sDispoalUrl = "";//����������Ϣ��ַ
	String sColumnName = "";//����

	//��������DAO��ˮ��
	if(sTransactionType!="" || !"".equals(sTransactionType)){
		sDAOSerialNo = DBKeyHelp.getSerialNo("npa_debtasset_object","SerialNo"); 
	}else{
		sTransactionType = sTransCode;
	}
	
	sDispoalUrl = "/RecoveryManage/PDAManage/PDADailyManage/PDADispoal01Info.jsp";
	sColumnName = "DISPOSAL"+sTransactionType.toString();
	if("01".equals(sTransactionType) || "01"==sTransactionType){
		sColumnName = "DISPOSAL01";
	}else if("02".equals(sTransactionType) || "02"==sTransactionType){
		sColumnName = "DISPOSAL02";
	}else if("03".equals(sTransactionType) || "03"==sTransactionType){
		sColumnName = "DISPOSAL03";
	}else  if("04".equals(sTransactionType) || "04"==sTransactionType){
		sColumnName = "DISPOSAL04";
	}else  if("05".equals(sTransactionType) || "05"==sTransactionType){
		sColumnName = "DISPOSAL05";
	}else  if("06".equals(sTransactionType) || "06"==sTransactionType){
		sColumnName = "DISPOSAL06";
	}
	//������Ϣ 
	doTemp.setVisible(sColumnName, true);
	dwTemp.genHTMLObjectWindow(sDAOSerialNo+","+sObjectType+","+sDASerialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveAs()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
	dwTemp.replaceColumn(sColumnName, "<iframe type='iframe' name=\"frame_list_DISPOSAL\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+sDispoalUrl+"?DAOSerialNo="+sDAOSerialNo+"&TransactionCode="+sTransactionType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//��ط�����Ϣ
	String sOtherFeeUrl = "/RecoveryManage/PDAManage/PDADailyManage/DAOtherFeeList.jsp";
	dwTemp.replaceColumn("OTHERFEE", "<iframe type='iframe' name=\"frame_list_DISPOSAL\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+sOtherFeeUrl+"?DAOSerialNo="+sDAOSerialNo+"&TransactionCode="+sTransactionType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());


	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sDAStatus = "";
	sSql = " select status from npa_debtasset where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sDASerialNo));
	if(rs.next()){
		sDAStatus = DataConvert.toString(rs.getString("status"));	   	
		if((sDAStatus == null) || (sDAStatus.equals(""))) sDAStatus = ""; 
	}
	rs.getStatement().close(); 

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	initRow();
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//������¼
			bIsInsert = true;	
			//initSerialNo();//��ʼ����ˮ���ֶ�
			setItemValue(0,0,"SERIALNO","<%=sDAOSerialNo%>");
			setItemValue(0,0,"DEBTASSETSERIALNO","<%=sDASerialNo%>");
			setItemValue(0,0,"OBJECTTYPE","<%=sObjectType%>");
			<%-- setItemValue(0,0,"OBJECTNO","<%=sObjectNo%>"); --%>
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");	
		}
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "NPA_DEBTASSET_OBJECT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=���þ�����;InputParam=��;OutPutParam=��;]~*/
	function _getInterstAmount(){
		var sExpiateAmout = getItemValue(0,getRow(),"EXPIATEAMOUNT");
		var sPrincipalAmout = getItemValue(0,getRow(),"PRINCIPALAMOUNT");
		var sInterstAmout = sExpiateAmout-sPrincipalAmout;
		if(sInterstAmout ==null||sInterstAmout ==""||sInterstAmout =="0")sInterstAmout = "0.00";
		setItemValue(0,getRow(),"INTERESTAMOUNT",sInterstAmout);
		
	}

	function saveAs(){
		as_save(0,"aftersave()");	
	}
	
	function aftersave(){
		var sDAStatus = "<%=sDAStatus%>";
		if("03"==sDAStatus){//�����ս��״̬���ı�
			
		}else{
			var sDASerialNo = "<%=sDASerialNo%>";
			var sSql = "update NPA_DEBTASSET set status='02' where serialno='"+sDASerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue!=-1){
				alert("����ɹ���");
			}else{
				alert("����ʧ�ܣ�");
			}
		}
	}
	
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
