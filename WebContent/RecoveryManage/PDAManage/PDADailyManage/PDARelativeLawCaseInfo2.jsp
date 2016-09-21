<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	//����������
	String sAssetStatus = (String)CurComp.getParameter("AssetStatus");
	String sDASerialNo = (String)CurComp.getParameter("DASerialNo");//��ծ�ʲ���ˮ��
	String sSerialNo = (String)CurComp.getParameter("SerialNo");//��ծ�ʲ���ծ��Ϣ��ˮ��
	String sLawCaseSerialNo = (String)CurComp.getParameter("LawCaseSerialNo");//Ҫ�����ĺ�ͬ�� 
	if(sDASerialNo == null ) sDASerialNo = "";		
	if(sSerialNo == null ) sSerialNo = "";
	if(sLawCaseSerialNo == null ) sLawCaseSerialNo = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

/* 	
	//�������
	String sSql = "";		
	String sLawCaseName = "";//��������
	String sLawCaseType = "";//��������
	String sCurrency = "";//����
	String sAimSum = "";//���ϱ���ܽ��
	String sLawSuitStatus = "";//���е����ϵ�λ
	String sCaseBrief = "";//����
	ASResultSet rs = null;
	
	//��ú�ͬ�����Ϣ	
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
		
	String sTempletNo ="PDAAssetLawCaseInfo"; //--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","","Button","����","���ص�����ҳ��","goBack()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		as_save(0);		
	}
	
	function goBack()
	{
		self.close();
	}
	/*~[Describe=�����ͬ���������ϼƻ��;InputParam=��;OutPutParam=��;]~*/
	function getSum()
	{
		 fAimsum = getItemValue(0,getRow(),"AIMSUM");//���ϱ���ܽ��
		 fPrincipal = getItemValue(0,getRow(),"PRINCIPALAMOUNT");//����
		 fIndebtInterest = getItemValue(0,getRow(),"INTERESTAMOUNT");//��Ϣ
		 fOutdebtInterest = getItemValue(0,getRow(),"OTHERAMOUNT");//����
		 
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
