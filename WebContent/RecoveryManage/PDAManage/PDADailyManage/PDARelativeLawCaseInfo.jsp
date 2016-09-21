<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
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

	String sTempletNo = "PDAAssetLawCaseInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sLawCaseSerialNo+","+sSerialNo);
	String sButtons[][] = {
		{sAssetStatus.equals("03")?"false":"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","","Button","返回","返回到调用页面","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}
	/*~[Describe=抵入合同金额由四项合计获得;InputParam=无;OutPutParam=无;]~*/
	function getSum()
	{
		 fAimsum = getItemValue(0,getRow(),"AIMSUM");//诉讼标的总金额
		 fPrincipal = getItemValue(0,getRow(),"PRINCIPALAMOUNT");//本金
		 fIndebtInterest = getItemValue(0,getRow(),"INTERESTAMOUNT");//利息
		 fOutdebtInterest = getItemValue(0,getRow(),"OTHERAMOUNT");//其他
		if(typeof(fPrincipal)=="undefined" || fPrincipal.length==0 || fPrincipal==null || fPrincipal=="") fPrincipal=0.00; 
		if(typeof(fIndebtInterest)=="undefined" || fIndebtInterest.length==0 || fIndebtInterest==null || fIndebtInterest=="") fIndebtInterest=0.00; 
		if(typeof(fOutdebtInterest)=="undefined" || fOutdebtInterest.length==0 || fOutdebtInterest==null || fOutdebtInterest=="") fOutdebtInterest=0.00; 
		if(typeof(fAimsum)=="undefined" || fAimsum.length==0  || fAimsum==null || fAimsum=="") fAimsum=0.00; 

		fSum = parseFloat(fPrincipal) + parseFloat(fIndebtInterest) + parseFloat(fOutdebtInterest);
		//fSum = fPrincipal + fIndebtInterest + fOutdebtInterest;
		sUnSum = parseFloat(fAimsum)-parseFloat(fSum);
		//sUnSum = fAimsum - fSum;
	    setItemValue(0,getRow(),"EXPIATEAMOUNT",fSum);//
	    setItemValue(0,getRow(),"UNEXPIATEAMOUNT",sUnSum);//
	}
	getSum();//初始化时，出现未抵债本金余额字段的值。
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
