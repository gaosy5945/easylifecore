<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ��ż����ͥ��Ҫ��Ա;
		Input Param:
			--CustomerID: ��ǰ�ͻ����
			--RelativeID: �����ͻ����
			--Relationship: ������ϵ
			--EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ż����ͥ��Ҫ��Ա"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sMarriage = "";
	
	//�������������ͻ�����
	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType = CurPage.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType = "";
	//���ҳ������������ͻ���š�������ϵ
	String sRelativeCustomerID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RELATIVECUSTOMERID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sRelativeCustomerID == null) sRelativeCustomerID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "IndCustomerRelativeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//����������
	if("03".equals(sCustomerType)){
 	 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Marriage from IND_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",sCustomerID));
		while(rs.next()){
			sMarriage = rs.getString("Marriage");
		} 
		if("10".equals(sMarriage)){
			doTemp.setDDDWSql("RELATIONSHIP","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerRelationShip' and ItemNo like '20%' and IsInUse = '1' and ItemNo not in ('2000','2007','2001','2002') ");
		}else{
			doTemp.setDDDWSql("RELATIONSHIP","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerRelationShip' and ItemNo in ('2007','2001','2003','2005') and IsInUse = '1' ");
		}
		rs.getStatement().close();
	}else{
		doTemp.setDDDWSql("RELATIONSHIP","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerRelationShip' and ItemNo like '10%' and IsInUse = '1' ");
	}
	//����Ĭ��ֵ
	
	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeCustomerID == null || sRelativeCustomerID.equals(""))
	{
		doTemp.setUnit("RELATIVECUSTOMERNAME"," <input class=\"inputdate\" type=button value=\"...\" onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font>"); 
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";		// ����DW��� 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	/* dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д */

	//���ò���͸����¼������������͸���
	/* dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,,#InputUserID,#CustomerType)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");
	 */
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeCustomerID+","+sRelationShip);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ:
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		/* {(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()","","","",""},
		{(sEditRight.equals("02")?"true":"false"),"All","Button","���沢����","���������޸Ĳ�����","saveAndNewRecord()","","","",""}, */
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var isSuccess=false;//��Ǳ���ɹ�
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{

		if(bIsInsert){
			//����ǰ���м��,���ͨ�����������,���������ʾ
		    if (!RelativeCheck()) return;
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","saveSuccess()");
			return;
		}
		beforeUpdate();
		as_save("myiframe0","saveSuccess()");
	}

	function saveSuccess(){
		isSuccess=true;
	}
/* function saveAndNewRecord(){
	saveRecord();
	if(isSuccess){
		OpenPage("/CustomerManage/IndManage/IndFamilyInfo.jsp?EditRight=02","_self","");
	}
} */
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/MyCustomer/IndCustomer/IndCustomerRelativeIndDataList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var flag = false;//�жϿͻ���Ϣ���������û�����(false)���Ǵ�ϵͳ��ѡ��(true)
	
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeCustomerID");
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/IndManage/IndFamilyInfo.jsp?RelativeCustomerID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";		
		//sReturn = setObjectValue("SelectManager",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		
		//ʵ����չ���:�����û��Լ��������Ϣʱ,ֻ��տͻ�����,���Ǵ�ϵͳ�������ѯ����,����� ֤�����͡�֤������Ϳͻ������ֶ�;ʵ���ֶι�����ʾ���ܡ�add by zhuang 2010-03-30
		sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = selectObjectValue("SelectManager",sParaString,sStyle);
		sValueString = "@RelativeCustomerID@0@RelativeCustomerName@1@CertType@2@CertID@3";
		sValues = sValueString.split("@");

		var i=sValues.length;
	    i=i-1;
	    if (i%2!=0){
	    	alert("setObjectValue()���ز����趨����!\r\n��ʽΪ:@ID����@ID�ڷ��ش��е�λ��...");
	        return;
	    }else{   
	        var j=i/2,m,sColumn,iID;    
	        if(typeof(sObjectNoString)=="undefined"){
	            return; 
	        }else if(String(sObjectNoString)==String("_CANCEL_") ){
	            return;
	        }else if(String(sObjectNoString)==String("_CLEAR_")){
	        	 setItemDisabled(0,0,"CertType",false);
                 setItemDisabled(0,0,"CertId",false);
                 setItemDisabled(0,0,"RelativeCustomerName",false);
                 setItemValue(0,getRow(),"RelativeCustomerName","");
                 if(flag){
                	 setItemValue(0,getRow(),"CertType","");
                	 setItemValue(0,getRow(),"CertID","");
                 }
                 flag = false;
	        }else if(String(sObjectNoString)!=String("_NONE_") && String(sObjectNoString)!=String("undefined")){
	            sObjectNos = sObjectNoString.split("@");
	            for(m=1;m<=j;m++){
	                sColumn = sValues[2*m-1];
	                iID = parseInt(sValues[2*m],10);
	                if(sColumn!=""){
	                	setItemValue(0,0,sColumn,sObjectNos[iID]);
	                }
	                    
	            }  
	            flag = true;
	        }
/* 	        sCustomerName = getItemValue(0,0,"RelativeCustomerName");
	        if( String(sObjectNoString)!=String("_CLEAR_") && typeof(sCustomerName) != "undefined" && sCustomerName != "" ){
	        	alert("!");
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"RelativeCustomerName",true);
		    }else{
		    	alert("?");
				setItemDisabled(0,0,"CertType",false);
				setItemDisabled(0,0,"CertID",false);
				setItemDisabled(0,0,"RelativeCustomerName",false);
				setItemFocus(0,0,"CustomerName");
			} */
	    }
	}

	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
        
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //��ÿͻ�����
	        var sColName = "CustomerId@CustomerName";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeCustomerID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"RelativeCustomerName",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeCustomerID","");
				setItemValue(0,getRow(),"RelativeCustomerName","");								
			} 
		}				     
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck()
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");	//�ͻ����			
		sCertType = getItemValue(0,0,"CertType");//֤������	
		sCertID = getItemValue(0,0,"CertID");//֤�����	
		sRelationShip = getItemValue(0,0,"RelationShip");//������ϵ
		
		if (typeof(sRelationShip) != "undefined" && sRelationShip != "")
		{
			var sMessage = PopPageAjax("/CustomerManage/EntManage/RelativeCheckActionAjax.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			var messageArray = sMessage.split("@");
			var isRelationExist = messageArray[0];
			var info = messageArray[1];
			if (typeof(sMessage)=="undefined" || sMessage.length==0) {
				return false;
			}
			else if(isRelationExist == "false"){
				alert(info);
				return false;
			}
			else if(isRelationExist == "true"){
				setItemValue(0,0,"RelativeCustomerID",info);
			}
		}
		return true;
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>