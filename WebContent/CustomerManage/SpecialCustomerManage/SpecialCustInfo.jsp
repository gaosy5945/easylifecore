<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ����ͻ�����ҳ��
		Input Param:
		       --SerialNO:��ˮ��
		Output param:
		History Log: 
		-- fbkang ��������ҳ��

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ͻ�����ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//�������
	
		//���ҳ�����	����������ˮ��
    	String sSerialNo = CurPage.getParameter("SerialNo");
		String specialCustomerType = CurPage.getParameter("SpecialCustomerType");
		String infoTempletNo = CurPage.getParameter("DoInfoTemplet");
    	if(sSerialNo==null) sSerialNo="";
    	if(specialCustomerType==null) specialCustomerType="";
    	if(infoTempletNo==null) infoTempletNo="";
		// ͨ��DWģ�Ͳ���ASDataObject����doTemp
		ASObjectModel doTemp = new ASObjectModel(infoTempletNo,"");
		
		if(specialCustomerType==""){
			doTemp.setReadOnly("SpecialCustomerType", false);
		}
		
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д

		//ʹ������ģ��ǰ�ġ���ʾ��׺��
		//doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		//doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
		
		//����HTMLDataWindow
		dwTemp.genHTMLObjectWindow(sSerialNo);
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
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
	
		if(bIsInsert){
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
			OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerList.jsp?SpecialCustomerType="+"<%=specialCustomerType%>","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--���»����ˮ��
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
       initSerialNo();//��ʼ����ˮ���ֶ�
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		//���ء��ͻ����롢�ͻ����ơ�֤�����͡�֤������
		if(sCertType!=""&&typeof(sCertType)!="undefined"){
			sParaString = "CertType,"+sCertType;
			setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
		}else{
			sParaString = "CertType, ";
			setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
		}
	}
	
	/*~[Describe=�õ��ͻ�����;InputParam=��;OutPutParam=��;]~*/
	var sCertType ="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID   = getItemValue(0,getRow(),"CertID");//--֤������
        //��ÿͻ�����
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		if(typeof(sCertType) != "undefined" && sCertType != ""&&typeof(sCertID) != "undefined" && sCertID != ""){
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		}else return;
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(var i = 0;i < sReturn.length;i++){
				my_array1[i] = sReturn[i];
			}
			
			for(var j = 0;j < my_array1.length;j++){
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(var m = 0;m < sReturnInfo.length;m++){
					my_array2[m] = sReturnInfo[m];
				}
				
				for(var n = 0;n < my_array2.length;n++){
					//���ÿͻ����
					if(my_array2[n] == "customerid")
						setItemValue(0,getRow(),"CustomerID",sReturnInfo[n+1]);
					//���ÿͻ�����
					if(my_array2[n] == "customername")
						setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
				}
			}			
		} 
	}
	
	/*~[Describe=ѡ����ҵͶ�򣨹�����ҵ���ͣ�;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"ATTRIBUTE1");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		//alert(sIndustryTypeInfo);
		if(sIndustryTypeInfo == "NO")
		{
			//alert(sIndustryTypeInfo);
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			//alert(sIndustryTypeInfo);
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
		/* 	setItemValue(0,getRow(),"ATTRIBUTE1",sIndustryTypeValue.substr(0,1));
			setItemValue(0,getRow(),"ATTRIBUTE2",sIndustryTypeValue.substr(0,3));
			setItemValue(0,getRow(),"ATTRIBUTE3",sIndustryTypeValue.substr(0,4)); */
			setItemValue(0,getRow(),"ATTRIBUTE1",sIndustryTypeValue.substr(0,5));
			getIndustryTypeParentName(sIndustryTypeValue,sIndustryTypeName);//��ȡ����Ͷ��Ķ����ڵ����ƣ������ô���Ͷ��
		}
	}
	//��ȡ����Ͷ��Ķ����ڵ����� 
	function getIndustryTypeParentName(sIndustryTypeValue,sIndustryTypeName){
		//��ȡ����Ͷ��Ķ����ڵ����ƣ������ô���Ͷ��
		var sTableName = "CODE_LIBRARY" ;
		var sColName = "ItemName";
		var sWhereClause = "ItemNo="+"'"+substring(sIndustryTypeValue,0,3)+"'";	
		var sIndustryTypeParentName = RunMethod("���÷���","GetColValue",sTableName + "," + sColName + "," + sWhereClause); 
		
		setItemValue(0,getRow(),"NAME1",sIndustryTypeParentName+" >> "+sIndustryTypeName);	
		
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			bIsInsert = true;
			setItemValue(0,0,"SpecialCustomerType","<%=specialCustomerType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "CUSTOMER_SPECIAL";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
