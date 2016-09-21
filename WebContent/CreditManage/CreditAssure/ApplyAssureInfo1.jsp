<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ҵ�����������ĵ�����Ϣ���飨һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
			ObjectNo�������ţ�������ˮ�ţ�
			SerialNo��������Ϣ���			
			GuarantyType��������ʽ
		HistoryLog:lqjiang 2013-12-20 ������Ϣ�����޸�©�����޸ģ�������У����޸ġ�
	 */
	String PG_TITLE = "����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//������������������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	//���ҳ�������������ʽ��������Ϣ���
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sGuarantyType == null) sGuarantyType = "";
	if(sSerialNo == null) sSerialNo = "";
	
	//jqcao:2013-07-05 Ϊ�������ҳ����OpenPage��ʽ���ø�ҳ��ʱ���˻ذ�ťֱ�ӹر�ҳ�棬���ܷ��ء�
	String sBackToClose = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BackToClose"));
	if(sBackToClose == null) sBackToClose = "";
	String sRightType =  CurComp.getParameter("RightType");

	//��ȡҵ��������
	String sSql = " select CustomerID from BUSINESS_APPLY where SerialNo=:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    //���ݵ�������ȡ����ʾģ���
	sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo=:ItemNo";
	String sTempletNo = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));
	//���ù�������
	String sTempletFilter = " (ColAttribute like '%BA%' ) ";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//��"������ʽ"����Ĭ��ֵΪ"һ�㵣��"
	doTemp.setDefaultValue("ContractType","010");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative("+sObjectNo+",GuarantyContract,#SerialNo,APPLY_RELATIVE)+!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"ReadOnly".equals(sRightType)?"false":"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button",( sBackToClose.equals("true") )? "�ر�":"����","�����б�ҳ��","goBack()","","","",""}
		};
	
	if( sBackToClose.equals( "true" ) ){
		sButtons[0][0] = "false";
	}
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
    var isSelect=false;//�жϿͻ��Ǵ��Ŵ�ϵͳ��ѡ�Ļ����Լ������
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		var sCertType = getItemValue(0,0,"CertType");
		var sCertID = getItemValue(0,0,"CertID");
		var GuarantorName = getItemValue(0,0,"GuarantorName");
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		
// 		changeLoanCardNoProperty(certType);
		
		/*
		Author: lqjiang 2013-12-20
		Describe: �ж��Ƿ���Ҫֻ��,����ֻ����
	    */
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != ""&& 
		typeof(GuarantorName) != "undefined" && GuarantorName != ""){
	        if(isSelect){
				setItemDisabled(0,0,"CertType",true);
		        setItemDisabled(0,0,"CertID",true);
		        setItemDisabled(0,0,"GuarantorName",true);
	        	setItemDisabled(0,0,"LoanCardNo",true);
	        }
	        
			var temp =getItemValue(0,0,"CertType").substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"LoanCardNo",true);
            	var sloancardno=getItemValue(0,0,"LoanCardNo");
            	if(sloancardno==null||sloancardno=='undefined'||sloancardno==''&&isSelect){
            		alert("�뵽�ͻ���Ϣ�����ƴ����ţ�");
            		return;
            	} 
            }else{
            	setItemValue(0,getRow(),"LoanCardNo","");  
            	setItemRequired(0,0,"LoanCardNo",false);
            }
		}
		
		as_save("myiframe0",sPostEvents);
 		changeLoanCardNoProperty(sCertType);  //�����ҳ����ʾ��ȷ
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		var BackFlag = "<%=sBackToClose%>";
		if( BackFlag == "true" ){
			self.close();
			return;
		}
		OpenPage("/CreditManage/CreditAssure/ApplyAssureList1.jsp","_self","");
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","010");//δǩ������ͬ
			setItemValue(0,0,"GuarantyCurrency","01");
			bIsInsert = true;
		}else{
            setItemDisabled(0,0,"CertType",true);
            setItemDisabled(0,0,"CertID",true);
            setItemDisabled(0,0,"GuarantorName",true);
            sLoanCardNo = getItemValue(0,0,"LoanCardNo");
            //�жϴ�����Ƿ���ֵ
            if(sLoanCardNo!= 'null' || sLoanCardNo!= ''){
            	setItemDisabled(0,0,"LoanCardNo",true);
            }
           // setItemDisabled(0,0,"LoanCardNo",true);
            var temp =getItemValue(0,0,"CertType").substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"LoanCardNo",true);
            }
            else{
            	setItemValue(0,getRow(),"LoanCardNo","");  
            	setItemRequired(0,0,"LoanCardNo",false);
            }
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "GUARANTY_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������
		var sReturn = "";
		if(sCertType!=''&&typeof(sCertType)!='undefined'){
			sParaString = "CertType,"+sCertType;
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
		}
		else{
			sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
		}
		if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		//���Ӷ�CertType��CertID��GuarantorName��LoanCardNo����ʾ����  add by zhuang 2010-04-01
		var sCertID = getItemValue(0,0,"CertID");
		if( String(sReturn)==String("_CLEAR_")||String(sReturn)=="undefined"  ){
            /* setItemDisabled(0,0,"CertType",false);
            setItemDisabled(0,0,"CertID",false);
            setItemDisabled(0,0,"GuarantorName",false);
            setItemDisabled(0,0,"LoanCardNo",false); */
            
            setItemDisabled(0,0,"CertType",false);
            setItemDisabled(0,0,"CertID",false);
            setItemDisabled(0,0,"GuarantorName",false);
            setItemDisabled(0,0,"LoanCardNo",false);
            isSelect=false;
		}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
			isSelect=true;
            setItemDisabled(0,0,"CertType",true);
            setItemDisabled(0,0,"CertID",true);
            setItemDisabled(0,0,"GuarantorName",true);
            setItemDisabled(0,0,"LoanCardNo",true);
    		var certType = getItemValue(0,0,"CertType");
            var temp = certType.substring(0,3);
            if(temp=='Ent'){
            	setItemDisabled(0,0,"LoanCardNo",true);
            	setItemRequired(0,0,"LoanCardNo",true);
            }
           else{
            	setItemValue(0,getRow(),"LoanCardNo","");  
            	setItemRequired(0,0,"LoanCardNo",false);
             	setItemDisabled(0,0,"LoanCardNo",false);
            }
            sCertType ="";
        }
	}
	
	/*~[Describe=�������������;InputParam=֤������;OutPutParam=;]~*/
	function changeLoanCardNoProperty(certType){  //added by yzheng
// 		alert(certType);
		if(certType.indexOf("Ind") != -1){  //����
        	setItemValue(0,getRow(),"LoanCardNo","");  //�������������,���
        	setItemRequired(0,0,"LoanCardNo",false);
        	setItemReadOnly(0,0,"LoanCardNo",true);
		}
        else{  //��˾
        	setItemRequired(0,0,"LoanCardNo",true);
        }
	}

	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������		
		//�����������Ϊ��Ѻ����Ѻ����֤����Լ���ձ�֤��������֤����֤��ʱ�����¼���֤����źϷ��Խ�����֤
		if(sGuarantyType == '050' || sGuarantyType == '060' || sGuarantyType.substring(0,3) == '010'){
			//���֤������Ƿ���ϱ������
			sCertType = getItemValue(0,0,"CertType");//--֤������		
			sCertID = getItemValue(0,0,"CertID");//֤������
			//У�鵣���˴�����
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�����˴�����	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				//addded by lqjjiang У������ŵ���ȷ��
				s=CheckLoanCardID(sLoanCardNo);
				if(s==false){
					alert("����������");//�õ����˵Ĵ������ѱ������ͻ�ռ�ã�							
					return false;
				}		  
				//���鵣���˴�����Ψһ��
				sGuarantorName = getItemValue(0,getRow(),"GuarantorName");//�ͻ�����	
				sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckLoanCardNo","run","CustomerID="+sGuarantorName+",LoanCardNo="+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
					alert(getBusinessMessage('419'));//�õ����˵Ĵ������ѱ������ͻ�ռ�ã�							
					return false;
				}					
			}
			
			//�������ĵ������Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡ�����˵Ŀͻ����
			if(typeof(sCertType) != "undefined" && sCertType != "" 
			&& typeof(sCertID) != "undefined" && sCertID != "")
			{
				var sGuarantorID = PopPageAjax("/PublicInfo/CheckCustomerActionAjax.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
				if (typeof(sGuarantorID)=="undefined" || sGuarantorID.length==0) {
					return false;
				}
				setItemValue(0,0,"GuarantorID",sGuarantorID);
			}			
		}
		
		//�����������Ϊ��֤����Լ���ձ�֤��������֤ʱ����Ե����˽��кϷ��Խ�����֤����֤�˷�ҵ�������ˣ�
		if(sGuarantyType == '010010' || sGuarantyType == '010020' || sGuarantyType.substring(0,3) == '010030'){
			sSerialNo = getItemValue(0,getRow(),"SerialNo");//������Ϣ��ˮ��
			sCustomerID = "<%=sCustomerID%>";	
			sReturn=RunJavaMethodTrans("com.amarsoft.app.bizmethod.BusinessManage","checkGuaranrtyContract","paras=SerialNo@@"+sSerialNo+"@~@CustomerID=@@"+sCustomerID);
 			if(typeof(sReturn) != "undefined" && sReturn != "" && parseInt(sReturn) > 0){
				alert(getBusinessMessage('502'));//�ñ�֤�˲���Ϊ�Լ������ҵ����б�֤��
				return false;
			}		
		}
		var guarantorID=getItemValue(0,0,"GuarantorID");
		var guarantyType=getItemValue(0,0,"GuarantyType");
		//������Ϊ�Լ���֤����
		if( guarantyType== "010010"){
			if("<%= sCustomerID %>" == guarantorID){
				alert("����Ϊ�Լ�����֤�������������룡");
				return false;
			}
		}
		return true;
	}

	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	var sCertType="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		changeLoanCardNoProperty(sCertType);

		if(typeof(sCertType) != "undefined" && sCertType != "" && 
			typeof(sCertID) != "undefined" && sCertID != ""){
			//��ÿͻ���š��ͻ����ƺʹ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName+",tableName="+sTableName+",whereClause="+sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != ""){
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++){
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++){
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++){
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++){
						//���ÿͻ�ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"GuarantorID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername"){	
						 setItemValue(0,getRow(),"GuarantorName",sReturnInfo[n+1]);
						 setItemReadOnly(0,0,"GuarantorName",true);//added by lqjiang
						 setItemReadOnly(0,0,"LoanCardNo",false);//added by lqjiang
						}	
						
						//���ô�����
						if(my_array2[n] == "loancardno"){
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else{
				setItemReadOnly(0,0,"LoanCardNo",false);//added by lqjiang
				setItemReadOnly(0,0,"GuarantorName",false);//added by lqjiang
				setItemValue(0,getRow(),"GuarantorID","");
				setItemValue(0,getRow(),"GuarantorName","");
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 
		}	
		 
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>