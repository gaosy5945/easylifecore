<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "������;��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//�������
	String sCustomerID = "";   //�ͻ�����
	String sTempSaveFlag = "";  //�ݴ��־
	
	//��ÿͻ�����
	CreditObjectAction cobj=new CreditObjectAction(sObjectNo,sObjectType);
	BizObject biz=cobj.creditObject;
	if(biz!=null){
		sCustomerID = biz.getAttribute("CustomerID").getString();
	}
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sDisplayTemplet = "ApplyVehicleInfo";
	ASObjectModel doTemp = new ASObjectModel(sDisplayTemplet,"");
	//����DataWindow����	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);

	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"false","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""}
	};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("0"))
		sButtons[1][0] = "false";
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0");
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp(){
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�0����
		as_saveTmp("myiframe0");   //�ݴ�
	}		

	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit){
		var sNumstr = 1;
    	for (i=0;i<digit;i++){
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	
	//����Ƿ��Ǹ�����
	function isDigit(s){
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (s!="" && !patrn.exec(s)){
			alert(s+"���ݸ�ʽ����");
			return false;
		}
		return true;
	}

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	//���������ܼۺ��׸�����ȡ�׸�����
	function getDownPayment(){
		var totalPrice  = getItemValue(0,getRow(),"PURCHASESUM");
		var downPaymentRate = getItemValue(0,getRow(),"DownPaymentRate");
		if(parseInt(downPaymentRate)>100||parseInt(downPaymentRate)<0){
			alert("�׸�����������[0,100]�ڣ�");
			setItemValue(0,getRow(),"DownPaymentRate","");
			return;
		}
		if(typeof(totalPrice)!="undefined"&& typeof(downPaymentRate)!="undefined" &&totalPrice.length>0&&downPaymentRate.length>0){
			setItemValue(0,0,"DownPayment",toNumber(downPaymentRate)*toNumber(totalPrice)/100);
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),'CUSTOMERID',"<%=sCustomerID%>");
		}
	}
	
	initRow();	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>