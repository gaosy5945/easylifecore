<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
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

	String sTempletNo = "PDAAssetLawCaseInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sLawCaseSerialNo+","+sSerialNo);
	String sButtons[][] = {
		{sAssetStatus.equals("03")?"false":"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","","Button","����","���ص�����ҳ��","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		self.close();
	}
	/*~[Describe=�����ͬ���������ϼƻ��;InputParam=��;OutPutParam=��;]~*/
	function getSum()
	{
		 fAimsum = getItemValue(0,getRow(),"AIMSUM");//���ϱ���ܽ��
		 fPrincipal = getItemValue(0,getRow(),"PRINCIPALAMOUNT");//����
		 fIndebtInterest = getItemValue(0,getRow(),"INTERESTAMOUNT");//��Ϣ
		 fOutdebtInterest = getItemValue(0,getRow(),"OTHERAMOUNT");//����
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
	getSum();//��ʼ��ʱ������δ��ծ��������ֶε�ֵ��
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
