<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		Tester:
		Content: --�ͻ��ſ�
		Input Param:
			  CustomerID:--�ͻ���
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         �°汾�ĸ�д
		   2005.9.10 zywei         �ؼ���� 
		   2005.12.15 jbai
		   2006.10.16 fhuang       �ؼ����
		   2009.10.12 pwang        �� �ı�ҳ����漰�ͻ������жϵ����ݡ�
		   2009.10.27 sjchuan	        ҳ����Ĭ����ʾ��ҵ��ģ
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ſ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCustomerInfoTemplet = "";//--ģ������
    String sSql = "";//--���sql���
    String sCustomerType = "";//--��ſͻ�����   
    String sCustomerOrgType = "";//--��Ż�������
    String sScope = "";//add by sjchuan 2009-10-27 �����ҵ��ģ
    String sItemAttribute = "" ;
    String sTempSaveFlag = "" ;//�ݴ��־
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- ��Ž����
	
	//����������,�ͻ�����
    String sCustomerID =  CurComp.getParameter("CustomerID");
    String sTypes =CurComp.getParameter("Types");//����Ŵ�ҵ�񲹵�ʱ�Ŀͻ������types
	if(sCustomerID == null) sCustomerID = "";
	if(sTypes == null) sTypes = "";
	//���ҳ�����	
	 String sRightType =  CurComp.getParameter("RightType");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	CustomerInfo ci=new CustomerInfo(null,sCustomerID);
 
	sCustomerType = ci.getString("CustomerType");
	sCertType = ci.getString("CertType");
	sCertID = ci.getString("CertID");   
	sCustomerOrgType = ci.getString("OrgNature");
	sScope = ci.getString("Scope");	//add sjchuan 2009-10-27 ȡ����ҵ��ģ
	sCustomerInfoTemplet=ci.getCustomerInfoTemplet();
	if(sCustomerType.equals("0120")){
		if(sTypes.equals("Reinforce")){ //��Ϊ���ǿͻ�ʱ����С��˾�ͻ���������ʾģ��EnterpriseInfoInput11
			sCustomerInfoTemplet="EnterpriseInfoInput11";
		} 
	} 
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	 
	sTempSaveFlag =ci.getString("TempSaveFlag");
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	if(sCertType.equals("Ind01") || sCertType.equals("Ind08")){
		doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//add by jgao1 ���֤��������Ӫҵִ�գ�������֤�������ֶ� 2009-11-2
	if(sCertType.equals("Ent02")){
		doTemp.setVisible("CorpID",false);
		doTemp.setReadOnly("LicenseNo",true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	
	dwTemp.genHTMLObjectWindow(sCustomerID);
	//֤����Ϣҳ��
	dwTemp.replaceColumn("CUSTOMERCERTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerCertList.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType+"&CompClientID="+sCompClientID+"&RightType="+sRightType+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("ADDRESSINFO", "<iframe type='iframe' name=\"frame_list_addressinfo\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerAddressList.jsp?CustomerID="+sCustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("TELINFO", "<iframe type='iframe' name=\"frame_list_addressinfo\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/CustomerTelList.jsp?CustomerID="+sCustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"ReadOnly".equals(sRightType)?"false":"true","","Button","����","���������޸�","saveRecord()","","","","btn_icon_save",""},
		{"0".equals(sTempSaveFlag)?"false":"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""},
	};
	//ֻҪ�ͻ�����û������Ȩ,�Ͳ����޸ı�ҳ�档
	String sRight = Sqlca.getString(new SqlObject(" select BelongAttribute2 from CUSTOMER_BELONG where CustomerID = :CustomerID and UserID = :UserID ").setParameter("CustomerID",sCustomerID).setParameter("UserID",CurUser.getUserID()));
	if(sRight != null && !sRight.equals("1")){
	 	sButtons[0][0] = "false";
	 	sButtons[1][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
<%@page import="com.amarsoft.app.als.customer.model.CustomerInfo"%><script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if(ValidityCheck()){
			setItemValue(0,getRow(),"TempSaveFlag","0"); //�ݴ��־��1���ǣ�0����	
			as_save("myiframe0"); 
		}		
	}
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�0����
		as_saveTmp("myiframe0");   //�ݴ�
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(sCustomerType == '01'){ //��˾�ͻ�
			
			//8��У�������
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//������	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				//���������Ψһ��
				sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}					
			}
			
			//9:У�鵱�Ƿ����ű�׼���ſͻ�Ϊ��ʱ�����������ϼ���˾���ơ��ϼ���˾��֯����������ϼ���˾������
			sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//�ϼ���˾��֯��������
	    	sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//�Ƿ����ű�׼���ſͻ�
	    	
			if(sECGroupFlag == '1'){ //�Ƿ����ű�׼���ſͻ���1���ǣ�2����
				
				//���¼�����ϼ���˾��֯�������룬����ҪУ���ϼ���˾��֯��������ĺϷ��ԣ�ͬʱ���ϼ���˾֤����������Ϊ��֯��������֤
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" ){
				}	
			}			
		}
		
		if(sCustomerType == '03'){ //���˿ͻ�
			//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
			sCertType = getItemValue(0,getRow(),"CertType");//֤������
			sCertID = getItemValue(0,getRow(),"CertID");//֤�����
			sBirthday = getItemValue(0,getRow(),"Birthday");//��������
			if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
				if(sCertType == 'Ind01' || sCertType == 'Ind08'){
					//У���֤����ʱ���֤�ĳ���
					if(sCertID.length != 15 && sCertID.length !=18){
						alert(getBusinessMessage('250')); //֤�����볤������ValidityCheck��							
						return false;
					}
					//�����֤�е������Զ�������������,�����֤�е��Ա𸳸��Ա�
					if(sCertID.length == 15){
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18){
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sBirthday != sCertID){
						alert(getBusinessMessage('200'));//�������ں����֤�еĳ������ڲ�һ�£�	
						return false;
					}
				}
				
				if(sBirthday < '1900/01/01'){
					alert(getBusinessMessage('201'));//�������ڱ�������1900/01/01��	
					return false;
				}
			}
				
			//4��У���ֻ�����
			sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//�ֻ�����
			if(typeof(sMobileTelephone) == "undefined" || sMobileTelephone == "" ){
				
				setItemValue(0,0,"MobileTelephone","00000000000");//���ֻ�����Ϊ��ʱ��������棬ϵͳ�Զ�������"00000000000"
			}
		}
		return true;		
	}

    /*~[Describe=������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/   
    function selectOrgType(){
        sParaString = "CodeNo"+",OrgType";      
        //'0110'������ҵ�ͻ��������С����徭Ӫ��ѡ��     Add by zhuang 2010-03-17
        var sCustomerType = "<%=sCustomerType%>";
        if(sCustomerType =='0110'){
            setObjectValue("SelectBigOrgType",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }else{
            setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }
    }
	
	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_")
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- ���ڹ���(����)����
			if(sCountryCodeValue != 'CHN') //�����ڹ���(����)��Ϊ�л����񹲺͹�ʱ�������ʡ�ݡ�ֱϽ�С�������������
			{
				setItemValue(0,getRow(),"RegionCode","");
				setItemValue(0,getRow(),"RegionCodeName","");
			}
		}
	}
	/*~[Describe=��������/����ѡ�񴰿�(�칫��ַ)�����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOfficeCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sOfficeCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@OfficeCountryCode@0@OfficeCountryCodeName@1",0,0,"");
		if (typeof(sOfficeCountryCodeInfo) != "undefined" && sOfficeCountryCodeInfo != ""  && sOfficeCountryCodeInfo != "_NONE_" 
		&& sOfficeCountryCodeInfo != "_CLEAR_" && sOfficeCountryCodeInfo != "_CANCEL_")
		{
			sOfficeCountryCodeInfo = sOfficeCountryCodeInfo.split('@');
			sOfficeCountryCodeInfo = sOfficeCountryCodeInfo[0];//-- ���ڹ���(����)����
			if(sOfficeCountryCodeInfo != 'CHN') //�����ڹ���(����)��Ϊ�л����񹲺͹�ʱ�������ʡ�ݡ�ֱϽ�С�������������
			{
				setItemValue(0,getRow(),"OfficeRegionCode","");
				setItemValue(0,getRow(),"OfficeRegionCodeName","");
			}
		}
	}
	/*~[Describe=�������õȼ�����ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditTempletType()
	{		
		sParaString = "CodeNo"+",CreditTempletType";			
		setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	
	/*~[Describe=������Ӧ���ֿ�ģ��ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAnalyseType(sModelType)
	{		
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode(flag)
	{		
		if (flag != "ent") { //������ҵ�ͻ�����������͸��˵ļ���
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}

	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		//�жϹ�����û��ѡ�й�
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		//���������滮�����м�ǧ���������ʾ�����滮
		if("<%=sCustomerType.substring(0,2)%>" == "01" || "<%=sCustomerType.substring(0,2)%>" == "02"){//��˾�ͻ�Ҫ����ѡ���ڹ��һ��������ѡ�����ʡ��
			//�жϹ����Ƿ��Ѿ�ѡ��
			if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" ){
				if(sCountryTypeValue == "CHN"){
					sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");

				}else{
					alert(getBusinessMessage('122'));//��ѡ���Ҳ����й�������ѡ�����
					return;
				}
			}else{
				alert(getBusinessMessage('123'));//��δѡ����ң��޷�ѡ�����
				return;
			}
		}else{
			sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		}
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionCodeName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"RegionCode",sAreaCodeValue);
					setItemValue(0,getRow(),"RegionCodeName",sAreaCodeName);				
			}
		}
	}	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOfficeRegionCode()
	{
		//�жϹ�����û��ѡ�й�
		var sCountryTypeValue = getItemValue(0,getRow(),"OfficeCountryCode");
		var sAreaCode = getItemValue(0,getRow(),"OfficeRegionCode");
		//���������滮�����м�ǧ���������ʾ�����滮
		if("<%=sCustomerType.substring(0,2)%>" == "01" || "<%=sCustomerType.substring(0,2)%>" == "02"){//��˾�ͻ�Ҫ����ѡ���ڹ��һ��������ѡ�����ʡ��
			//�жϹ����Ƿ��Ѿ�ѡ��
			if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" ){
				if(sCountryTypeValue == "CHN"){
					sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

				}else{
					alert(getBusinessMessage('122'));//��ѡ���Ҳ����й�������ѡ�����
					return;
				}
			}else{
				alert(getBusinessMessage('123'));//��δѡ����ң��޷�ѡ�����
				return;
			}
		}else{
			sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		}
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"OfficeRegionCode","");
			setItemValue(0,getRow(),"OfficeRegionCodeName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"OfficeRegionCode",sAreaCodeValue);
					setItemValue(0,getRow(),"OfficeRegionCodeName",sAreaCodeName);				
			}
		}
	}
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//������չ��ܵ��ж�
		if(sIndustryTypeInfo == "NO" ||sIndustryTypeInfo == '_CLEAR_' )
		{	
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrg()
	{		
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getUser()
	{		
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 )
		{		
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else
		{
			alert(getBusinessMessage('132'));//����ѡ��ܻ�������
		}
	}
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp)
    {
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//���� ��ҵ���͡�Ա�����������۶�ʲ��ܶ�ȷ����С��ҵ��ģ
	function EntScope() {
		/*
		����˵����
		�μ��ĵ���ͳ���ϴ���С����ҵ���ְ취�����У�������ͳ�ƾ����˾
		����������ָ���������ҵ���͡�Ա�����������۶�ʲ��ܶ�
		*/
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");//��С��ҵ��ҵ
		var sLastYearSale = getItemValue(0,getRow(),"SellSum");//�����۶�
		var sCapitalAmount = getItemValue(0,getRow(),"TOTALASSETS");//�ʲ��ܶ�
		var sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");//Ա������
		if(typeof(sIndustryType)=="undefined" || sIndustryType.length==0)
			return;
		if(typeof(sLastYearSale)=="undefined" || sLastYearSale.length==0)
			return;
		if(typeof(sCapitalAmount)=="undefined" || sCapitalAmount.length==0)
			return;
		if(typeof(sEmployeeNumber)=="undefined" || sEmployeeNumber.length==0)
			return;
		if(sIndustryType.substring(0,1)=="B" || sIndustryType.substring(0,1)=="C"||sIndustryType.substring(0,1)=="D"){ //��ҵ����ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<300||sLastYearSale<3000||sCapitalAmount<4000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="E"){ //����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<3000||sCapitalAmount<4000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H63"){ //����ҵ��ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H65"){ //����ҵ��ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="F" && sIndustryType.substring(0,3)!="F59"&& sIndustryType.substring(0,3)!="F58"){ //��ͨ����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F59"){ //����ҵ��ҵ
			if(sEmployeeNumber>=1000&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="I"){ //ס�޺Ͳ���ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="A"){ //ũ��������ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F58"){ //�ִ���ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="K"){ //���ز���ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="J"){ //������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=50000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<5000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="M78" ||sIndustryType.substring(0,1)=="N"){ //���ʿ����ˮ������������ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=20000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<2000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="R"){ //���塢������ҵ
			if(sEmployeeNumber>=600&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="M"&&sIndustryType.substring(0,3)!="M78"){ //��Ϣ������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="G"){ //��������������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L73"){ //������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L74"){ //���񼰿Ƽ�������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="O"){ //���������ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000) { //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else{ //������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		 
		var sCountryCode = getItemValue(0,getRow(),"OfficeCountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		var sHasIERight = getItemValue(0,getRow(),"HasIERight");
		var SECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");
		var sLoanFlag = getItemValue(0,getRow(),"LoanFlag");
		var sNationality = getItemValue(0,getRow(),"Nationality");
		
		var sListingCorpType = getItemValue(0,getRow(),"ListingCorpOrNot");// add by zhuang 2010-03-17
		
        //�������й�˾����Ĭ��ֵΪ�������С�  add by zhuang 2010-03-17        
        if(sListingCorpType=="")
        {   
            //"2"���ֶ�"ListingCorpOrNot"��ģ���ж�Ӧ���ô���ListingCorpType��ItemNoֵ����ʾ������
            if("<%=sCustomerInfoTemplet%>"== "EnterpriseInfo01"||"<%=sCustomerInfoTemplet%>"== "EnterpriseInfo02"||"<%=sCustomerInfoTemplet%>"== "EnterpriseInfo11"){
          		  setItemValue(0,getRow(),"ListingCorpOrNot","2");
            }
        }
		 
		//���ô�����ҵ����ҵ��ģĬ��ֵ add by cbsu 2009-11-02
        if("<%=sCustomerType%>" == '0110')
        {
            setItemValue(0,getRow(),"Scope","2");
        }    
		if (sInputUserID=="") 
		{
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == "")
		{
		    setItemValue(0,getRow(),"CreditBelong","010");			
			setItemValue(0,getRow(),"CreditBelongName","��ҵ���������ҵ��λ���õȼ�������");
		}
		if("<%=sCustomerInfoTemplet%>" == "IndEntInfo")
		{
		    setItemValue(0,getRow(),"FinanceBelong","050");			
		}
		
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
		ssCustomerType = "<%=sCustomerOrgType%>";
		sScope = "<%=sScope%>";	
		if(ssCustomerType == '0101' || ssCustomerType == '0102' || ssCustomerType == '0107')
		{
			sRCCurrency = getItemValue(0,0,"RCCurrency");
			sPCCurrency = getItemValue(0,0,"PCCurrency");
			if(sRCCurrency == '')
				setItemValue(0,getRow(),"RCCurrency","01");		
			if(sPCCurrency == '')
				setItemValue(0,getRow(),"PCCurrency","01");
		}
		if(sCustomerType == '01')//��˾�ͻ�
		{
			if(sLoanFlag == "")
			setItemValue(0,getRow(),"LoanFlag","1");
			if("<%=sCustomerInfoTemplet%>"== "EnterpriseInfo01"||"<%=sCustomerInfoTemplet%>"== "EnterpriseInfo02"){
				if(sHasIERight == "")
				setItemValue(0,getRow(),"HasIERight","2");
				if(SECGroupFlag == "")
				setItemValue(0,getRow(),"ECGroupFlag","2");
			}
		}
		if(sCustomerType == '03') //���˿ͻ�
		{	
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				//�����֤�е������Զ�������������
				if(sCertID.length == 15)
				{
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18)
				{
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
		}
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
   initRow(); 
</script>	
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
