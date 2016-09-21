<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "��ȹ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo =  CurPage.getParameter("ObjectNo");
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sObjectNo == null) sObjectNo = "";

	ASObjectModel doTemp = new ASObjectModel("RelativeCreditInfo");	
	CreditObjectAction  creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sObjectType = creditObjectAction.getRealCreditObjectType();
	String customerID = creditObjectAction.creditObject.getAttribute("CustomerID").getString();
	if(creditObjectAction.getCustomerType().startsWith("01")){ //��˾�ͻ�
		doTemp.setDDDWCodeTable("LmtCatalog","3005,��˾�ۺ����Ŷ��,3040,������˾�������");
	}else if (creditObjectAction.getCustomerType().startsWith("03")){ //���˿ͻ�
		//doTemp.setDDDWCodeTable("LmtCatalog","3008,�����ۺ����Ŷ��,3040,���������Ŷ��");
		doTemp.setDDDWCodeTable("LmtCatalog","3030,���������Ŷ��");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()","","","",""},		
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}	
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if(checkLineRelative()){
			initSerialNo();
			as_save("myiframe0");
			goBack();
		}			
	}
    
    /*~[Describe=ȡ��������ȹ�����¼;InputParam=��;OutPutParam=ȡ����־;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/CreditLineRelaList.jsp","_self","");
	}

    /*~[Describe=��ȹ���У��;InputParam=��;OutPutParam=��;]~*/
	function checkLineRelative(){
		lmtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CheckCreditLineType","checkCLType","CreditObjectType=<%=sObjectType%>,ApplySerialNo=<%=sObjectNo%>,LmtCatalog="+lmtCatalog);
		if(sReturnValue == "SUCCESS"){
			return true;
		}else{
			alert(sReturnValue);
			return false;
		}
	}
	
	/*~[Describe=���ݶ�����ͣ��ҵ���Ӧ�Ķ��Э���ѡ����ͼ;InputParam=��;OutPutParam=��;]~*/
	function selectLineNo(){
		lmtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		if(typeof(lmtCatalog) == "undefined" || lmtCatalog.length == 0){
			alert("����ѡ�������ͣ�");
			return;
		}
		selectCreditLine(lmtCatalog);
	}
	
	/*~[Describe=�������Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditLine(businessType){
		var sCustomerID = "<%=customerID%>";
		var sObjectType = "<%=sObjectType%>";
		var imtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		var sParaString = "ObjectNo"+","+"<%=sObjectNo%>"+","+"ObjectType"+","+sObjectType+","+"CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>"+",BusinessType,"+businessType;
		if(imtCatalog == "3005"){  //��˾
			sReturn = setObjectValue("SelectCLContract",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");			
		}else if(imtCatalog == "3040"){  //����
			sReturn = setObjectValue("SelectCLContract2",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");
		}
		else if(imtCatalog == "3030"){ //������
			//���غ�ͬ��ˮ��,���,ҵ��Ʒ��,�ͻ�����,��ͬ���,����
			sReturn = setObjectValue("SelectCLContract1",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "CL_OCCUPY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//����һ���ռ�¼			
			//��������
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			//������
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");	
		}
    }
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>