<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		ҳ��˵��: �û���Ϣ����
	 */
	String PG_TITLE = "�û���Ϣ����";
	
	//���ҳ�����	
	String sUserID =  CurPage.getParameter("UserID");
	if(sUserID==null) sUserID="";
	//���ó�ʼ����000000als
	String sInitPwd = "000000als";
	String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", sInitPwd);
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "UserInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.appendHTMLStyle("UserID"," onkeyup=\"value=value.replace(/[^0-z]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;)\" ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sUserID);

	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸�","saveRecord()","","","",""},
		{"true","","Button","����","���ص��б����","doReturn('Y')","","","",""}		
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
    var sCurUserID=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false;
	
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("USER_INFO","UserID")){
			alert("�ñ���Ѵ��ڣ��������룡");
			return;
		}
		if (!ValidityCheck()) return;
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y')");
	}
    
    function doReturn(sIsRefresh){
        OpenPage("/AppConfig/OrgUserManage/UserList.jsp","_self","");
	}

    <%/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;]~*/%>
	function selectOrg(){
		sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
            setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"Password","<%=sPassword%>"); //����������û������ó�ʼ����
            bIsInsert = true;
		}
	}
	
	<%/*~[Describe=��Ч�Լ��;ͨ��true,����false;]~*/%>
	function ValidityCheck(){
		//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
		sCertType = getItemValue(0,getRow(),"CertType");//֤������
		sCertID = getItemValue(0,getRow(),"CertID");//֤�����
		sBirthday = getItemValue(0,getRow(),"Birthday");//��������
		if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
			if(sCertType == 'Ind01' || sCertType == 'Ind08'){
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
		
		//2��У��סլ�绰
		sCompanyTel = getItemValue(0,getRow(),"CompanyTel");//��λ�绰	
		if(typeof(sCompanyTel) != "undefined" && sCompanyTel != "" ){
			if(!CheckPhoneCode(sCompanyTel)){
				alert(getBusinessMessage('203'));//��λ�绰����
				return false;
			}
		}
		
		//3��У���ֻ�����
		sMobileTel = getItemValue(0,getRow(),"MobileTel");//�ֻ�����
		if(typeof(sMobileTel) != "undefined" && sMobileTel != "" ){
			if(!CheckPhoneCode(sMobileTel)){
				alert(getBusinessMessage('204'));//�ֻ���������
				return false;
			}
		}
		
		//4��У���������
		sEmail = getItemValue(0,getRow(),"Email");//��������	
		if(typeof(sEmail) != "undefined" && sEmail != "" ){
			if(!CheckEMail(sEmail)){
				alert(getBusinessMessage('205'));//������������
				return false;
			}
		}		
		return true;	
	}

	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>