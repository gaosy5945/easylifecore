<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: �ͻ����������ڻ���ҵ��;
		Input Param:
				DealType��
				    03����ɷŴ��ĺ�ͬ
					04����ɷŴ��ĺ�ͬ
		Output Param:
			
		HistoryLog:
			zywei 2007/10/10 �޸�ȡ����ͬ����ʾ��
			jgao 2009-10-26 ���Ӽ������Ŷ�ȵǼǺ�ͬ�����ɼ��ų�Ա��ȵķ���
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql1="";
    String sWhereCond = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		 			
	//where���ͳһ�޸Ĵ����漰ҵ������ģ����				
	sWhereCond	= " and ManageUserID = '"+CurUser.getUserID()+"' "+						
 			                   " and (DeleteFlag = ''  or  DeleteFlag is null) ";	 			
	
	if(sDealType.equals("03")){
		//sSql1 =" and BusinessType not like '30%' and (PigeonholeDate ='' or PigeonholeDate is null) ";
	    sSql1 =" and ReinforceFlag = '000' and BusinessType not like '30%' and (PigeonholeDate =' ' or PigeonholeDate is null) ";
	}
	else if(sDealType.equals("04")){
		//sSql1 =" and BusinessType not like '30%' and (PigeonholeDate !='' and PigeonholeDate is not null) ";
	    //sSql1 =" and (ReinforceFlag = '000' and BusinessType not like '30%' and (PigeonholeDate !='' and PigeonholeDate is not null)) or ReinforceFlag = '020' ";
	    sSql1 =" and BusinessType not like '30%' and (PigeonholeDate !=' ' and PigeonholeDate is not null) ";
	}
	else if(sDealType.equals("05")){ //����ɵǼǵ����Ŷ��
		//sSql1 =" and BusinessType like '30%' and (PigeonholeDate ='' or PigeonholeDate is null) ";
	    sSql1 =" and ReinforceFlag = '000' and BusinessType like '30%' and (PigeonholeDate =' ' or PigeonholeDate is null) ";
	}
	else if(sDealType.equals("06")){ //����ɵǼǵ����Ŷ��
	    //���ӹ����������˵����ų�Ա���Ŷ��                                                                                                
	    //sSql1 =" and BusinessType like '30%' and (PigeonholeDate !=' ' and PigeonholeDate is not null) and (GroupLineID is null or GroupLineID='')";   
	    //sSql1 =" and ((ReinforceFlag='000' and BusinessType like '30%' and (PigeonholeDate !='' or PigeonholeDate is not null)) or  ReinforceFlag='120') and (GroupLineID is null or GroupLineID='')  ";
	    sSql1 =" and BusinessType like '30%' and FreezeFlag in ('1','2','3') and (PigeonholeDate !=' ' and PigeonholeDate is not null) and (GroupLineID is null or GroupLineID=' ')  ";
	}
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DealContractList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
		
	doTemp.WhereClause = doTemp.WhereClause + sWhereCond + sSql1;

	if (sDealType.equals("06") || sDealType.equals("05")) {
		doTemp.setVisible("Balance",false);
	}
	
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHTMLStyle("","ondblclick=\"javascript:parent.viewTab()\" ");//���˫���鿴���鹦��
	//���ӹ�����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)+!BusinessManage.UpdateBusiness(BusinessContract,#RelativeserialNo,UpdateBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","��ͬ����","��ͬ����","viewTab()","","","",""},
		{"false","","Button","�������","�������","viewTab()","","","",""},
		{"true","All","Button","ȡ����ͬ","ȡ����ͬ","cancelContract()","","","",""},
		{"true","","Button","��ɷŴ�","��ɷŴ�","archive()","","","",""},
		{"false","","Button","�Ǽ����","�Ǽ����","archive()","","","",""},
		{"true","","Button","�����ص�����","�����ص�����","addUserDefine()","","","",""},
		{"false","","Button","ȡ��","ȡ��","cancelarch()","","","",""},
		{"true","","Button","��������","��������","viewTab()","","","",""},
		{"true","","Button","��ӡ��ͬ<����>","��ӡ��ͬ","printContract()","","","",""},
	};

	if(sDealType.equals("04")){
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
		sButtons[6][0] ="true";//�رա�ȡ���鵵����ť
	}
	if(sDealType.equals("05")){
		sButtons[3][0] ="false";//�رա���ɷŴ�����ť
		sButtons[4][0] ="true";//�򿪡��Ǽ���ɡ���ť
		sButtons[1][0] ="true";//�򿪡�������顱��ť
		sButtons[0][0] ="false";//�򿪡���ͬ���顱��ť
	}
	if(sDealType.equals("06")){
		sButtons[2][0] ="false";//�رա�ȡ����ͬ����ť
		sButtons[3][0] ="false";//�رա���ɷŴ�����ť
		sButtons[1][0] ="true";//�򿪡�������顱��ť
		sButtons[0][0] ="false";//�򿪡���ͬ���顱��ť
		sButtons[6][0] ="true";//�رա�ȡ���鵵����ť
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	
	function task(){
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sViewID = "001";//Ĭ��Ϊ001
		var taskID = "contractTask_Y";
		if("<%=sDealType%>"=="03" || "<%=sDealType%>"=="05"){
			taskID = "contractTask_N";
		}else if("<%=sDealType%>"=="04" || "<%=sDealType%>"=="06"){
			sViewID = "003";//ֻ��
		}
		AsTaskView.commontaskView(taskID,sObjectNo,sObjectType,sViewID);		
	}
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&CustomerID=" + sCustomerID;
		 if("<%=sDealType%>"=="04" || "<%=sDealType%>"=="06"){
			 sParamString = sParamString +"&RightType=ReadOnly";
		 }
		
		AsCredit.openFunction("ContractDetail",sParamString,"");
 	 	<%--  if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ȡ���ĸ���ͼ���µĲ���
		sDealType = "<%=sDealType%>"; 
		sViewID = "001";//Ĭ��Ϊ001
		//����������Ϊ�ѵǼ���ɵ����Ŷ��ʱ���������޸����������ݣ���Ϊֻ����add by jgao1 2009-11-4
		if(sDealType == "06"){
			sViewID="003";
		}
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
		AsCredit.openImageTab(sParamString);  --%>
/* 		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); */
		
		reloadSelf();
	}

	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function addUserDefine(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('420'))){ //Ҫ�������ͬ��Ϣ�����ص��ͬ��������
			var sRvalue=PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
			alert(getBusinessMessage(sRvalue));
		}
	}

	/*~[Describe=��ɷŴ�;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		var sObjectType = "BusinessContract";
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���Ϊ���Ŷ��ҵ��
		if(sBusinessType.length>2 && sBusinessType.substring(0,1)=="3"){
			ssReturn = autoRiskScan("015","&SerialNo="+sObjectNo);
			if(ssReturn != true){
				return;
			}
			//��ȷ�ϵǼ���ñ����Ŷ����
			if(confirm("��ȷ�ϵǼ���ñ����Ŷ����?")){
				//����Ǽ������Ŷ�ȣ��ڵǼ����ʱ�����ɼ��ų�Ա�ĺ�ͬ�����ֻ�еǼ���ɵ����Ŷ�Ȳſ�������
				if(sBusinessType.length>=4 && sBusinessType.substring(0,4)=="3020"){
					sTrue = RunMethod("CreditLine","InitGroupContract",sObjectNo);
					if(sTrue != "true"){
						alert("���ɼ������Ŷ��ʧ�ܣ�");
						return;
					}
				}
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
				if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn!="failed"){					
					alert("�ñ����Ŷ���Ѿ���Ϊ��ɵǼǣ�");//�ñ����Ŷ���Ѿ���Ϊ��ɵǼǣ�
					reloadSelf();
				}
			}
		}else{
			if(confirm(getBusinessMessage('421'))) //������뽫�ñʺ�ͬ��Ϊ��ɷŴ���
			{
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
				if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn!="failed"){
					alert(getBusinessMessage('422'));//�ñʺ�ͬ�Ѿ���Ϊ��ɷŴ���
					reloadSelf();				
				}
			}
		}
	}
	
	/*~[Describe=ȡ����ͬ;InputParam=��;OutPutParam=��;]~*/
	function cancelContract(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
		    sReturn = PopPageAjax("/CreditManage/CreditPutOut/CheckContractDelActionAjax.jsp?ObjectNo="+sObjectNo,"","");
	        if (typeof(sReturn)=="undefined" || sReturn.length==0){
	            as_del('myiframe0');
	            as_save('myiframe0');  //�������ɾ������Ҫ���ô����
	        }else if(sReturn == 'Reinforce'){
	            alert(getBusinessMessage('425'));//�ú�ͬΪ���Ǻ�ͬ������ɾ����
	            return;
	        }else if(sReturn == 'Finish'){
	            alert(getBusinessMessage('426'));//�ú�ͬ�Ѿ����ս��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Pigeonhole'){
	            alert(getBusinessMessage('427'));//�ú�ͬ�Ѿ���ɷŴ��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'PutOut'){
	            alert(getBusinessMessage('428'));//�ú�ͬ�Ѿ������ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Other'){
	            alert(getBusinessMessage('429'));//�ú�ͬ�ܻ���Ϊ������Ա������ɾ����
	            return;
	        }else if(sReturn == 'Use'){
	            alert(getBusinessMessage('430'));//�����Ŷ���ѱ�ռ�ã�����ɾ����
	            return;
	        }
		}
	}
	
	/*~[Describe=ȡ���鵵;InputParam=��;]~*/
	function cancelarch(){
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //������뽫����Ϣ�鵵ȡ����
			//ȡ���鵵����
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_CONTRACT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
			}
		}
	}
	
	function imageScan(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");
		var ojectType = "BusinessContract";
		if (typeof(objectNo)=="undefined" || objectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			AsCredit.openImageScan(objectNo,ojectType);
		}
	} 
	
	/*~[Describe=��ӡ����ͬ;InputParam=��;OutPutParam=��;]~*/
	function printContract(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
		if(typeof(objectNo)=="undefined" || objectNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return ;
		}
		
		var objectType = "BusinessContract";
		var edocNo = "AAA";
		
		var param = "ObjectNo="+objectNo+",ObjectType="+objectType+",EdocNo="+edocNo+",UserID=<%=CurUser.getUserID()%>";
		var printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "getPrintSerialNo", param);
		if(printSerialNo == ""){
			printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "initEdocPrint", param);
		} else {
			if(confirm("�Ƿ��������ɵ��Ӻ�ͬ��"))
				printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "updateEdocPrint", param);
		}
		OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+printSerialNo,"_blank","");   
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>