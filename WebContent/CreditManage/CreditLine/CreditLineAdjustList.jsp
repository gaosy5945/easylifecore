<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:gfTang 2014/04/26
		Tester:
		Content: ���Ŷ�ȵ����б�ҳ��
		Input Param:
			FreezeFlag����־��1����Ч��2�����᣻3���ⶳ��4����ֹ��
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ�ȵ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����		
	String sFreezeFlag =  CurPage.getParameter("FreezeFlag");
	if(sFreezeFlag == null) sFreezeFlag = "";

%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�������				
	String sTempletNo="";
	String today = DateHelper.getToday();
	Boolean isValid = false; //��־��ǰ��ȼ�¼�Ƿ���Ч
	Boolean unFreeze = false;//��־�Ƿ���Ҫ�ⶳ��ť
	Boolean stop = false;//��־�Ƿ���Ҫ��ֹ
		
	String flagArr[] =sFreezeFlag.split(",");
	if(flagArr.length>1){
		sTempletNo = "CreditLineAdjustValidList";//������Ч��¼
		isValid=true;
		unFreeze = false;
		stop = true;
	}
	if(flagArr.length==1){
		if("2".equals(flagArr[0])){//�Ѷ�����б�
			sTempletNo = "CreditLineAdjustFreezeList";
			isValid=false;
			unFreeze=true;
			stop = true;
		}else{//����ֹ���б�
			sTempletNo = "CreditLineAdjustStopList";
			isValid=false;
			unFreeze = false;
			stop = false;
		}
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	 ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ

	//��������¼�
	
	//����HTMLDataWindow
	 dwTemp.genHTMLObjectWindow(today+","+today+","+today);//������ʾģ�����
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
 		{(isValid?"true":"false"),"","Button","����","������ѡ�Ķ�ȼ�¼","freezeRecord()","","","",""},
 		{(stop?"true":"false"),"","Button","��ֹ","��ֹ��ѡ�Ķ�ȼ�¼","stopRecord()()","","","",""},
		{(unFreeze?"true":"false"),"","Button","�ⶳ","�ⶳ��ѡ�Ķ�ȼ�¼","unfreezeRecord()","","","",""}, 
		{"true","","Button","�������","�鿴/�޸�����","openWithObjectViewer()","","","",""}
		};
		
	%> 
<%/*~END~*/%>
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�������Ŷ��;InputParam=��;OutPutParam=��;]~*/
	function freezeRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getBusinessMessage('400')))//ȷʵҪ����ñ����Ŷ����
		{
			//�������
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.FreezeCreditLine","freezeCreditLine","serialNo="sSerialNo+",freezeFlag="+"2");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('401'));//�������Ŷ��ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('402'));//�������Ŷ�ȳɹ���
			}	
		}	
	}
	//��ֹ���Ŷ��
	function stopRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getBusinessMessage('406')))//ȷʵҪ��ֹ�ñ����Ŷ����
		{
			//��ֹ����
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.FreezeCreditLine","freezeCreditLine","serialNo="+sSerialNo+",freezeFlag="+"4");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('407'));//��ֹ���Ŷ��ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('408'));//��ֹ���Ŷ�ȳɹ���
			}
		}		
	}
	
	/*~[Describe=�ⶳ���Ŷ��;InputParam=��;OutPutParam=��;]~*/
	function unfreezeRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getBusinessMessage('403')))//ȷʵҪ�ⶳ�ñ����Ŷ����
		{
			//�ⶳ����
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.FreezeCreditLine","freezeCreditLine","serialNo="sSerialNo+",freezeFlag="+"3");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('404'));//�ⶳ���Ŷ��ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('405'));//�ⶳ���Ŷ�ȳɹ���
			}	
		}	
	}
			
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		customerID=getItemValue(0,getRow(),"CUSTOMERID");
		var isShow = "false";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}		
		//var sReturn = RunMethod("com.amarsoft.app.lending.bizlets.CheckRolesAction","checkRolesAction","customerID="+customerID+",userID="+"<%=CurUser.getUserID()%>");
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CustomerRoleAction","checkBelongAttributes","CustomerID="+sCustomerID+",UserID=<%=CurUser.getUserID()%>");
		if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        return;
    	}
	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
                        
		if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    
			isShow="true";
		}
		popComp("","/CreditManage/CreditLine/CreditLineInfoTab.jsp","SerialNo="+sSerialNo+"&CustomerID="+customerID+"&isShow="+isShow);
    	reloadSelf();
	}
    
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
