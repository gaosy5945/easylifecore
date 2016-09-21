<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = ""; 
 	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = ""; 
	String sCustomerType = CurPage.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType = ""; 
	String sRelationShipFlag = CurPage.getParameter("RelationShipFlag");
	if(sRelationShipFlag == null) sRelationShipFlag = ""; 
	String sRelativeCustomerID = CurPage.getParameter("RelativeCustomerID");
	if(sRelativeCustomerID == null) sRelativeCustomerID = "";
	String sRelationShip = CurPage.getParameter("RelationShip");
	if(sRelationShip == null) sRelationShip = "";
	String sMarriage = "";
	String sTempletNo = "EntCustomerRelativeInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	

		//����������
		if(("1001".equals(sRelationShipFlag))){//��ҵ�ͻ��еķ��˴���������
		    doTemp.setReadOnly("RELATIONSHIP", true);
		    doTemp.setDefaultValue("RELATIONSHIP", "1001");
		}else if(("03".equals(sCustomerType))&&("".equals(sRelationShipFlag))){//���˿ͻ��й�����������
	 	 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Marriage from IND_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",sCustomerID));
			while(rs.next()){
				sMarriage = rs.getString("Marriage");
			} 
			if("10".equals(sMarriage)){
				doTemp.setDDDWJbo("RelationShip","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerRelationShip' and ItemNo like '20%' and IsInUse = '1' and ItemNo not in ('2000','2007','2001','2002') ");
			}else{
				doTemp.setDDDWJbo("RelationShip","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerRelationShip' and ItemNo in ('2007','2001','2003','2005') and IsInUse = '1' ");
			}
			rs.getStatement().close();
			doTemp.setDDDWJbo("CERTTYPE","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerCertType' and ItemNo like '1%' and IsInUse = '1' ");
		}else{//���˿ͻ��й�����ҵ������
			//doTemp.setDDDWJbo("RelationShip","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerRelationShip' and ((ItemNo like '30%' and ItemNo <> '3000') or ItemNo = '9999') and IsInUse = '1' ");
			doTemp.setDefaultValue("RelationShip", "1023");
			doTemp.setReadOnly("RelationShip", true);
			doTemp.setDDDWJbo("CERTTYPE","jbo.sys.CODE_LIBRARY,itemNo,ItemName,codeno = 'CustomerCertType' and ItemNo like '2%' and ItemNo <> '2' and IsInUse = '1' ");
		}
		//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
		if(sRelativeCustomerID == null || sRelativeCustomerID.equals(""))
		{
			doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
		} else {
			doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
		}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","",""},
			};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>������ҵ��Ϣ</title>
</HEAD>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
var isSuccess=false;//��Ǳ���ɹ�
//---------------------���尴ť�¼�------------------------------------

/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){	
		var CertIDTemp = getItemValue(0,0,"CertID");
		var CertID = CertIDTemp.replace(/\s+/g,"");
		var CertType = getItemValue(0,0,"CertType");
		if(!iV_all("0")) return ;
			var sResult = CustomerManage.judgeIsExists(CertID, CertType);
			sResult=sResult.split("@");
			if(sResult[0] == "No"){//��������ͻ��ڱ���Ϊһ���¿ͻ�ʱ�������ÿͻ����������ڱ��ͻ�����
				AddCustomerInfo();
				importRelativeCustomer(); //������
			}else{//�����ͻ��Ǳ��еĴ����ͻ�
				var RelativeCustomerID = sResult[1];
				var RelativeCustomerName = sResult[2];
				var customerid = "<%=sCustomerID%>";
				var sReturn = CustomerManage.judgeIsRelative(customerid,RelativeCustomerID);//�ù����ͻ��Ƿ��ڱ��ͻ��Ĺ�������Ϣ�У������ظ�������
				sReturn=sReturn.split("@");
				if(sReturn[0] == "2"){
					alert("��Ҫ�����Ŀͻ��Ѵ��ڸÿͻ��������б��У���ȷ�ϣ�");
					return;
				}else{
					setItemValue(0,getRow(0),"RELATIVECUSTOMERID",RelativeCustomerID);
					setItemValue(0,getRow(0),"RELATIVECUSTOMERNAME",RelativeCustomerName);
					saveIframe();
					importRelativeCustomer();
				}
			}
		}
	function importRelativeCustomer(){
		var relativeCustomerid = getItemValue(0,0,"RELATIVECUSTOMERID");
		var RelationShip = getItemValue(0,0,"RelationShip");
		CustomerManage.importRelationShip("<%=sCustomerID%>",relativeCustomerid,RelationShip,"<%=CurOrg.getOrgID()%>","<%=CurUser.getUserID()%>","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function AddCustomerInfo(){
		if (!RelativeCheck()) return;
		var customerName = getItemValue(0,getRow(0),"RelativeCustomerName");
		var certType = getItemValue(0,getRow(0),"CertType");
		var certID = getItemValue(0,getRow(0),"CertID");
		var issueCountry = getItemValue(0,getRow(0),"IssueCountry");
		var customerType = "<%=sCustomerType%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputDate = "<%=StringFunction.getToday()%>";
		var sReturn = CustomerManage.checkCustomer(certID, customerName, customerType, certType);
	 	temp = sReturn.split("@");	
			if(temp[0] == "true"){
				var result = CustomerManage.createCustomerInfo(customerName, customerType, certID, certType, issueCountry, inputOrgID, inputUserID, inputDate);
				tempResult = result.split("@");
				var sCustomerID = tempResult[1];
				CustomerManage.updateCertID(sCustomerID,certType,certID);
				if(tempResult[0] == "true"){
			 		alert("�ͻ�\""+tempResult[2]+"\"�����ɹ���");
				}else{
					alert("�ͻ�\""+tempResult[2]+"\"����ʧ�ܣ�");
					return;
				}
				setItemValue(0,0,"RELATIVECUSTOMERID",sCustomerID);
				saveIframe();
				return;
		 	}else if(temp[0] == "CBEmpty"){
	 			var relativeCustomerID = temp[1];
				setItemValue(0,0,"RELATIVECUSTOMERID",relativeCustomerID);
				saveIframe();
				return;
	 		}else{
	 			var relativeCustomerID = temp[2];
				setItemValue(0,0,"RELATIVECUSTOMERID",relativeCustomerID);
				saveIframe();
				return;
	 		} 
	}
	function saveIframe(){
		as_save("myiframe0");
	}
/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
function goBack()
{
	top.close();
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
		OpenPage("/CustomerManage/MyCustomer/IndCustomer/IndCustomerRelativeInfo.jsp?RelativeCustomerID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
	}
	function selectCustomer1(){
		AsDialog.SetGridValue("SelectRelativeEntCustomer", "<%=CurUser.getUserID()%>", "RELATIVECUSTOMERNAME=CUSTOMERNAME@CertType=CERTTYPE@CertID=CERTID@@IssueCountry=ISSUECOUNTRY", "");
		var certID = getItemValue(0,0,"CertID");
		if(certID != ""){
			temp = "2";
		}
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{	//ȡ�ͻ����͵�ǰ��λ��Ȼ��ͨ�����ݿ��ѯ�ͻ�����ǰ��λ���ϵĿͻ�
		var customerType = "<%=sCustomerType%>";
		var sCustomerType = customerType.substring(0, 2);
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		sParaString = "CustomerType"+","+sCustomerType+","+"UserID"+","+"<%=CurUser.getUserID()%>";		
		//sReturn = setObjectValue("SelectManager",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		
		//ʵ����չ���:�����û��Լ��������Ϣʱ,ֻ��տͻ�����,���Ǵ�ϵͳ�������ѯ����,����� ֤�����͡�֤������Ϳͻ������ֶ�;ʵ���ֶι�����ʾ���ܡ�add by zhuang 2010-03-30
		sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = selectObjectValue("SelectManager",sParaString,sStyle);
		sValueString = "@RelativeCustomerID@0@RelativeCustomerName@1@CertType@2@CertID@3@IssueCountry@4@IssueCountryName@5";
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
	            temp = "2";
	            flag = true;
	        }
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
		initSerialNo();//��ʼ����ˮ���ֶ�
		/* bIsInsert = false; */
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{	
		var sSerialNo = "<%=sSerialNo%>";//--֤������
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){//�統ǰ�޼�¼��������һ��
			setItemValue(0,0,"CUSTOMERID","<%=sCustomerID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//as_add("myiframe0");//������¼ 
			bIsInsert = true;
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
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
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "CUSTOMER_RELATIVE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	

</script>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>
