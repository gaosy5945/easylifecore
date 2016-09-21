<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";

	String sTempletNo = "SpecialCustInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	doTemp.setDefaultValue("LISTTYPE", listType);
	doTemp.setDefaultValue("INPUTUSERID", CurUser.getUserID());
	doTemp.setDefaultValue("USERName", CurUser.getUserName());
	doTemp.setDefaultValue("STATUS", "1");
	dwTemp.setParameter("SerialNo", serialNo);

	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","�ύ","�ύ","submit()","","","",""},
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function submit(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(sSerialNo == ""){
			alert("���ȱ��棬�ٽ����ύ��");
		}else{
			var todoType = "03"; //����ͻ�����
			var status = "01"; //������
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if(confirm('ȷʵҪ�ύ����������׶Ρ���?')){			
				 var sReturn = CustomerManage.updatePhaseAction(todoType, status, serialNo);
				 if(sReturn == "SUCCEED"){
					 	alert("�ύ�ɹ���");
					}else if(sReturn == "FAILED"){
						alert("�ÿͻ����ڡ��������׶Σ������ٴ��ύ��");
					}else{
						alert("�ύʧ�ܣ�");
					}
				}
			}
	}
	
	
	function pageReload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	function goBack(){
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerListNew.jsp","_self","");
	}
	function selectCustomer1(){
		AsDialog.SetGridValue("SelectCustomerList1", "", "CUSTOMERID=CUSTOMERID@CUSTOMERNAME=CUSTOMERNAME@CERTTYPE=CERTTYPE@CERTID=CERTID", "", "","1");
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{	
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";		
		
		//ʵ����չ���:�����û��Լ��������Ϣʱ,ֻ��տͻ�����,���Ǵ�ϵͳ�������ѯ����,����� ֤�����͡�֤������Ϳͻ������ֶ�;ʵ���ֶι�����ʾ���ܡ�
		sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = selectObjectValue("SelectCustomerList",sParaString,sStyle);
		sValueString = "@CustomerID@0@CustomerName@1@CertType@2@CertID@3";
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
	             setItemDisabled(0,0,"CustomerName",false);
	             setItemValue(0,getRow(),"CustomerName","");
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
		function initRow(){
			<% if(CurComp.getParameter("SerialNo") == null){%>
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"BEGINDATE","<%=StringFunction.getToday()%>");
		<% }else{%>
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		<%}%>
			
		}
		initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
