<%@page import="com.amarsoft.are.lang.StringX"%>
<%@page import="com.amarsoft.are.util.StringFunction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	String serialNo = CurPage.getParameter("SerialNo");//������Ŀ���
	String PSerialNo = CurPage.getParameter("PSerialNo");//�ʲ�������ˮ��

	String sTempletNo = "ProjectAssetdealInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(PSerialNo);
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","All","Button","�ݴ�","�ݴ�","saveTemp()","","","",""},
			{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	
	/**��������	 */
	function saveRecord(){
		if(ValidityCheck()){
			setItemValue(0,0,"TempSaveFlag","0");
			as_save(0);
		}
	}
	/*�ݴ�*/
	function saveTemp(){
		setItemValue(0,0,"TempSaveFlag","1");
		as_saveTmp("myiframe0");
	}
	/*�����б�*/
	function returnList(){
		OpenPage("/CustomerManage/PartnerManage/ProjectAssetdealList.jsp", "_self");
	}
	
	function ValidityCheck()
	{
		//��ǰ����
		var today = "<%=StringFunction.getToday()%>"; 
		var purchaseDate = getItemValue(0,getRow(),"PurchaseDate");//�ʲ�����ʱ��
		var saleDate = getItemValue(0,getRow(),"SaleDate");//�ʲ�����ʱ��


		if(purchaseDate>today)
		{
			alert("�ʲ�����ʱ�䲻������ ��ǰʱ�䣡");
			return false;
		}

		if(saleDate>today)
		{
			alert("�ʲ�����ʱ�䲻������ ��ǰʱ�䣡");
			return false;
		}
		return true;
	}
	/*��ʼ��*/
	function initRow(){
		var serialNo = getItemValue(0,0,"SerialNo");
		if(serialNo==""){
			setItemValue(0,0,"ProjectNo","<%=serialNo%>");
			setItemValue(0,0,"CustomerID","<%=customerID%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
