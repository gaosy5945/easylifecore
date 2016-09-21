<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String transactionCode = (String)CurPage.getParameter("TransactionCode");
	if(transactionCode == null ){
		transactionCode = "";
	}
	ASObjectModel doTemp = new ASObjectModel("DocOperationAddDialog","");
	doTemp.setDefaultValue("DOCBELONG", "1");
	doTemp.setHtmlEvent("DOCBELONG", "onClick", "docBelongChange");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","����","saveRecord()","","","",""},	
	};
	sButtonPosition = "north";
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	function saveRecord()
	{
		as_save(0,"setReturnValue()");
	}
	
	function setReturnValue()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo"); 
		self.returnValue = serialNo;
		self.close();
	}
	
	function selectDocContract()
	{
		var docBelong = getItemValue(0,getRow(),"DOCBELONG");
		//������ʽ��0010 �½����      0015 �������     0040 �黹���
		var transactionCode = "<%=transactionCode%>";
		/*
		 *1���½���⣺
		 *   >>: ��ҵ�����Ϲ���Ϊ"���"��"����"ʱ���������ѡ���б��ҵ���ͬ��(BUSINESS_CONTRACT)�л�ȡ
		 *   >>: ��ҵ�����Ϲ���Ϊ"������Ŀ"ʱ���������ѡ���б�Ӻ�����Ŀ(PRJ_BASIC_INFO)���л�ȡ
		 */    
		if(transactionCode !=""&&("0000"==transactionCode||"0010"==transactionCode)){ 
			if("1" == docBelong) //��������
			{
				setGridValuePretreat('SelectDocContract','<%=CurUser.getOrgID()%>,<%=transactionCode%>','OBJECTTYPE=OBJECTTYPE@OBJECTNO=SERIALNO@CONTRACTNO=CONTRACTARTIFICIALNO@PACKAGENAME=CUSTOMERNAME@MANAGEORGID=EXECUTIVEORGID@MANAGEUSERID=EXECUTIVEUSERID@CONTRACTARTIFICIALNO=CONTRACTARTIFICIALNO','');
				setItemValue(0,getRow(),"ObjectType","jbo.app.BUSINESS_CONTRACT");
			} 
			else if("2" == docBelong) //��Ŀ����
			{
				setGridValuePretreat('SelectDocProject','<%=CurUser.getOrgID()%>,<%=transactionCode%>','OBJECTTYPE=OBJECTTYPE@OBJECTNO=SERIALNO@PRJECTNO=SERIALNO@PACKAGENAME=CUSTOMERNAME@MANAGEORGID=ORIGINATEORGID@CONTRACTARTIFICIALNO=AGREEMENTNO','');
				setItemValue(0,getRow(),"ObjectType","jbo.prj.PRJ_BASIC_INFO");
			}
		/*
		  2���������͹黹��⣺
		      <1>����ҵ�����Ϲ���Ϊ"���"��"����"ʱ���������ѡ���б��ҵ�����ϰ���Ϣ��(DOC_FILE_PACKAGE)��ҵ���ͬ��(BUSINESS_CONTRACT)������ȡ
		           >>:������⣺ҵ������״̬Ϊ"�����"��
		          >>:�黹��⣺ҵ������״̬Ϊ"�������ϳ���"
		  	  <2>����ҵ�����Ϲ���Ϊ"������Ŀ"ʱ���������ѡ���б��ҵ�����ϰ���Ϣ��(DOC_FILE_PACKAGE)��ȡ
		  	      >>:������⣺ҵ������״̬Ϊ"�����"��ҵ����������(ObjectType)Ϊ"jbo.prj.PRJ_BASIC_INFO"
          		  >>:�黹��⣺ҵ������״̬Ϊ"�������ϳ���"��ҵ����������(ObjectType)Ϊ"jbo.prj.PRJ_BASIC_INFO"
		 */
		}else if(transactionCode !=""&&("0015"==transactionCode||"0040"==transactionCode)){
			//����ҵ������״̬��03 �����  05 �������ϳ���
			var status = "";
			if("0015"==transactionCode){
				status = "03";
			}else if("0040"==transactionCode){
				status = "05";
			}
			if("1" == docBelong) //��������
			{ 
				status = "03";
				setGridValuePretreat('Doc2ManageLoanDiglogList','<%=CurUser.getOrgID()%>,<%=transactionCode%>,'+status,'OBJECTTYPE=OBJECTTYPE@OBJECTNO=OBJECTNO@CONTRACTNO=OBJECTNO@CUSTOMERNAME=CUSTOMERNAME@CONTRACTARTIFICIALNO=CONTRACTARTIFICIALNO@PACKAGENAME=CUSTOMERNAME','');
				setItemValue(0,getRow(),"ObjectType","jbo.app.BUSINESS_CONTRACT");
			} 
			else if("2" == docBelong) //��Ŀ����
			{
				setGridValuePretreat('Doc2ManageProDiglogList','<%=CurUser.getOrgID()%>,<%=transactionCode%>,'+status,'OBJECTTYPE=OBJECTTYPE@OBJECTNO=OBJECTNO@PRJECTNO=OBJECTNO@CONTRACTARTIFICIALNO=CONTRACTARTIFICIALNO@PACKAGENAME=CUSTOMERNAME','');
				setItemValue(0,getRow(),"ObjectType","jbo.prj.PRJ_BASIC_INFO");
			}
		}  
	}
	 
	setItemValue(0,getRow(),"TransactionCode","<%=transactionCode%>");
	
	//ҵ�����Ϲ���Ҫ�������¼�����ҵ�����Ϲ���ѡ��"������Ŀ"ʱ������ʾ"������ͬ���"��"�ͻ�����"
	function docBelongChange(){ 
		//��ȡҵ�����Ϲ�������
		var sDocBelong = getItemValue(0,getRow(0),"DOCBELONG");
		if("2"==sDocBelong){
			showItem(0,'PRJECTNO');
			hideItem(0,'CONTRACTNO');
			hideItem(0,'CUSTOMERNAME');
			setItemRequired("myiframe0","PRJECTNO",true);
			setItemRequired("myiframe0","CONTRACTNO",false);
		} else{
			hideItem(0,'PRJECTNO');
			showItem(0,'CONTRACTNO');
			showItem(0,'CUSTOMERNAME');  
			setItemRequired("myiframe0","CONTRACTNO",true);
			setItemRequired("myiframe0","PRJECTNO",false);
		}
	}
	docBelongChange();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>