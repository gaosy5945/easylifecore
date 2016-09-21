<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerName = CurPage.getParameter("CUSTOMERNAME");
	if(sCustomerName == null) sCustomerName = "";
	String sEmployMent= CurPage.getParameter("EmployMent");
    String birthDay = "" ;
    String certType = "" ;
    String smemonopolyFlag = "" ;
 	 ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select birthDay from IND_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",sCustomerID));
 	if(rs.next()){
 		birthDay=rs.getString("birthDay");
			if(birthDay == null) {
				birthDay = "";
			}
		}
	rs.getStatement().close();
	
	 ASResultSet rs1 = Sqlca.getASResultSet(new SqlObject("select certType from CUSTOMER_IDENTITY where CustomerID=:CustomerID ").setParameter("CustomerID",sCustomerID));
	if(rs1.next()){
		certType=rs1.getString("certType");
			if(certType == null) {
				certType = "";
			}
		}
	rs1.getStatement().close();
	
	 ASResultSet rs2 = Sqlca.getASResultSet(new SqlObject("select smemonopolyFlag from CUSTOMER_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",sCustomerID));
	if(rs2.next()){
		smemonopolyFlag=rs2.getString("smemonopolyFlag");
			if(certType == null) {
				certType = "";
			}
		}
	rs2.getStatement().close();
	
	String sCustomerType = "03";
	String sTempletNo = "IndCustomerBasicInfo";//--ģ���--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("CustomerID", sCustomerID);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	if((!"".equals(birthDay) && "1".equals(certType))||(!"".equals(birthDay) && "6".equals(certType))||(!"".equals(birthDay) && "C".equals(certType))){
		doTemp.setReadOnly("BirthDay", true);
	}
	if("1".equals(smemonopolyFlag)){
		doTemp.setReadOnly("smemonopolyFlag", true);
	}
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("ADDRESSINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerAddressList.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("TELINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerTelList.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("CUSTOMERCERTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerCertList.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("EMPLOYMENT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerEmploymentList.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveInfo()","","","","btn_icon_save",""},
		{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	var flag = true;
	function saveInfo(){
       setItemValue(0,getRow(),"UPDATEORGID","<%=CurOrg.getOrgID()%>");
       setItemValue(0,getRow(),"UPDATEUSERID","<%=CurUser.getUserID()%>");
	   setItemValue(0,getRow(),"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");	
	   setItemValue(0,getRow(),"TEMPSAVEFLAG","0"); //�ݴ��־��0������  1���ݴ棩
		var IRsubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"IR");
		var jboYears = getItemValue(IRsubdwname, getRow(IRsubdwname), "BEGINDATE");
		var today = "<%=DateHelper.getBusinessDate()%>";

		if(jboYears == today || jboYears > today){
			alert("��ְʱ�䲻�ܴ��ڻ���ڵ�ǰ���ڣ���ȷ�ϣ�");
			return;
		}else{
			birthdayEvent();
			if(!flag){
				flag = true;
				return;
			}else{
			    as_save("myiframe0");
			}
		}
	}	
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TEMPSAVEFLAG',"1"); //�ݴ��־��0������  1���ݴ棩
		setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		as_saveTmp("myiframe0");
	}	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sCity = getItemValue(0,getRow(),"CITY");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sCity,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CNIDREGCITY","");
			setItemValue(0,getRow(),"CNIDREGCITYName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"CNIDREGCITY",sAreaCodeValue);
					setItemValue(0,getRow(),"CNIDREGCITYName",sAreaCodeName);				
			}
		}
	}
	function changeEvent(){
		var jboYears = getItemValue(0,0,"BEGINDATE");
		var today = "<%=DateHelper.getBusinessDate()%>";
		if(jboYears == today || jboYears > today){
			alert("��ְʱ�䲻�ܴ��ڻ���ڵ�ǰ���ڣ���ȷ�ϣ�");
			return;
		}
	}
	function certIdexpiry(){
		var idexPiry = getItemValue(0,0,"IDEXPIRY");
		var today = "<%=DateHelper.getBusinessDate()%>";
		if(idexPiry == today || idexPiry < today){
			alert("֤�������ձ�����ڵ�ǰ���ڣ���ȷ�ϣ�");
			return;
		}
		var Maxday = "2099/12/31";
		if(idexPiry == Maxday || idexPiry > Maxday){
			alert("֤�������ձ���С�ڡ�2099��12��31�ա�����ȷ�ϣ�");
			return;
		}
	}
	function birthdayEvent(){
		var birthday = getItemValue(0,0,"BIRTHDAY");
		var today = "<%=DateHelper.getBusinessDate()%>";
		if(birthday == today || birthday > today){
			alert("�������ڱ���С�ڵ�ǰ���ڣ���ȷ�ϣ�");
			flag = false;
			return;
		}
	}
	function IsUnKnown(){
		var bdsubdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"IR");
		var IndustryType = getItemValue(bdsubdwname, getRow(bdsubdwname), "INDUSTRYTYPE");
		if(IndustryType == "N98"){
			alert("������λ������ҵ������ѡ��δ֪����");
			setItemValue(bdsubdwname, getRow(bdsubdwname),"INDUSTRYTYPE","");
			return;
		}
	}
	function IsZRPerson(){
		var SMClientType = getItemValue(0, getRow(), "SMCLIENTTYPE");
		if(SMClientType == "4"){
			alert("������Ͳ�����ѡ��������Ȼ�ˡ���");
			setItemValue(0, 0,"SMCLIENTTYPE","");
			return;
		}
	}
	function hideSMType(){
		var smemonopolyFlag = getItemValue(0,getRow(),"SMEMONOPOLYFLAG");
		if(smemonopolyFlag == "0"){
			setItemValue(0,0,"SMCLIENTTYPE","");
			hideItem(0,"SMCLIENTTYPE");
			setItemRequired("myiframe0","SMCLIENTTYPE",false);
		}else
		{
			showItem(0,"SMCLIENTTYPE");
			setItemRequired("myiframe0","SMCLIENTTYPE",true);
		}
	}
	hideSMType();
	
	function hideCustomerName(){
		var MFCustomerID = getItemValue(0,getRow(),"MFCUSTOMERID");
		if(typeof(MFCustomerID) == "undefined" || MFCustomerID.length == 0){
			setItemDisabled(0, getRow(), "CUSTOMERNAME", false);
		}else{
			setItemDisabled(0, getRow(), "CUSTOMERNAME", true);
		}
	}
	hideCustomerName();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
