<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	

	ASObjectModel doTemp = new ASObjectModel("CDYCCustomerInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      	     //--����Ϊ���ɷ��--
	dwTemp.ReadOnly = "0";	 //
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","��ѯ","��ѯ","query()","","","","",""},
		};
	//sASWizardHtml = "<p><font color='red' size='3'>\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n�ʻ���Ϣ</font></p>";
	
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function query(){
		var CERTTYPE = getItemValue(0,0,"CERTTYPE");
		var CERTID = getItemValue(0,0,"CERTID");
		if(typeof(CERTTYPE)=="undefined" || CERTTYPE.length==0){
			alert("֤�����Ͳ���Ϊ��");
			return;
		}else if(typeof(CERTID)=="undefined" || CERTID.length==0){
			alert("֤�����벻��Ϊ��");
			return;
		}else{
			AsControl.OpenPage("/Common/DateReport/CDYClntInfoQry.jsp","CERTTYPE="+CERTTYPE+"&CERTID="+CERTID,"frame_info1");
			//AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","PutOutDate="+putOutDate+"&AccountType="+accountType+"&AccountNo="+accountNo+"&AccountCurrency="+accountCurrency,"frame_list1","");
		}
	}
	//mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
