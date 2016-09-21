<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	//获得组件参数
	String sAssetStatus = (String)CurComp.getParameter("AssetStatus");
	String sDASerialNo = (String)CurComp.getParameter("DASerialNo");//抵债资产流水号
	String sSerialNo = (String)CurComp.getParameter("SerialNo");//抵债资产抵债信息流水号
	String sLawCaseSerialNo = (String)CurComp.getParameter("LawCaseSerialNo");//要关联的合同号 
	if(sDASerialNo == null ) sDASerialNo = "";		
	if(sSerialNo == null ) sSerialNo = "";
	if(sLawCaseSerialNo == null ) sLawCaseSerialNo = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

/* 	
	//定义变量
	String sSql = "";		
	String sLawCaseName = "";//案件名称
	String sLawCaseType = "";//案件类型
	String sCurrency = "";//币种
	String sAimSum = "";//诉讼标的总金额
	String sLawSuitStatus = "";//我行的诉讼地位
	String sCaseBrief = "";//案由
	ASResultSet rs = null;
	
	//获得合同相关信息	
	sSql = 	"select  LI.LAWCASENAME as LawCaseName, getItemName('LawCaseType',  LI.LAWCASETYPE) as LawCaseTypeName," +
				" getItemName('LawSuitStatus',LI.LAWSUITSTATUS) as LawCaseStatus, LI.Casebrief as CaseBrief," +
				" LI.Currency as Currency, LI.Aimsum as Aimsum from LAWCASE_INFO LI where LI.Serialno=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sLawCaseSerialNo));
	if (rs.next()){
			sLawCaseName = rs.getString("LawCaseName");	
			sLawCaseType = rs.getString("LawCaseTypeName");	
			sLawSuitStatus=rs.getString("LawCaseStatus");		
			sCaseBrief=rs.getString("CaseBrief");	
			sCurrency = rs.getString("Currency");			
			sAimSum = rs.getString("Aimsum");			
		  	if (sLawCaseName == null)  sLawCaseName = "";		
		  	if (sLawCaseType == null)  sLawCaseType = "";	
			if ((sLawSuitStatus == null) || (sLawSuitStatus.equals(""))) sLawSuitStatus="";
			if ((sCaseBrief == null) || (sCaseBrief.equals(""))) sCaseBrief="";
		  	if (sCurrency == null)  sCurrency = "";	
		  	if ((sAimSum == null) || (sAimSum.equals(""))) sAimSum="0.00";	
	}
	rs.getStatement().close();  */
		
	String sTempletNo ="PDAAssetLawCaseInfo"; //--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","","Button","返回","返回到调用页面","goBack()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		as_save(0);		
	}
	
	function goBack()
	{
		self.close();
	}
	/*~[Describe=抵入合同金额由四项合计获得;InputParam=无;OutPutParam=无;]~*/
	function getSum()
	{
		 fAimsum = getItemValue(0,getRow(),"AIMSUM");//诉讼标的总金额
		 fPrincipal = getItemValue(0,getRow(),"PRINCIPALAMOUNT");//本金
		 fIndebtInterest = getItemValue(0,getRow(),"INTERESTAMOUNT");//利息
		 fOutdebtInterest = getItemValue(0,getRow(),"OTHERAMOUNT");//其他
		 
 		//alert(fAimsum+","+fPrincipal+","+fIndebtInterest+","+fOutdebtInterest);
		 
		if(typeof(fPrincipal)=="undefined" || fPrincipal.length==0 || fPrincipal==null || fPrincipal=="") fPrincipal=0.00; 
		if(typeof(fIndebtInterest)=="undefined" || fIndebtInterest.length==0 || fIndebtInterest==null || fIndebtInterest=="") fIndebtInterest=0.00; 
		if(typeof(fOutdebtInterest)=="undefined" || fOutdebtInterest.length==0 || fOutdebtInterest==null || fOutdebtInterest=="") fOutdebtInterest=0.00; 
		if(typeof(fAimsum)=="undefined" || fAimsum.length==0  || fAimsum==null || fAimsum=="") fAimsum=0.00; 

		//fSum = ParseFloat(fPrincipal) + ParseFloat(fIndebtInterest) + ParseFloat(fOutdebtInterest);
		fSum = fPrincipal + fIndebtInterest + fOutdebtInterest;
		alert(fSum);
		//sUnSum = ParseFloat(fAimsum)-ParseFloat(fSum);
		sUnSum = fAimsum - fSum;
		alert(sUnSum);
	    setItemValue(0,getRow(),"EXPIATEAMOUNT",fSum);//
	    setItemValue(0,getRow(),"UNEXPIATEAMOUNT",sUnSum);//
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
