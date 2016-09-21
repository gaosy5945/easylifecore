<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	

	ASObjectModel doTemp = new ASObjectModel("CDYCCustomerInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      	     //--设置为自由风格--
	dwTemp.ReadOnly = "0";	 //
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","查询","查询","query()","","","","",""},
		};
	//sASWizardHtml = "<p><font color='red' size='3'>\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n帐户信息</font></p>";
	
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function query(){
		var CERTTYPE = getItemValue(0,0,"CERTTYPE");
		var CERTID = getItemValue(0,0,"CERTID");
		if(typeof(CERTTYPE)=="undefined" || CERTTYPE.length==0){
			alert("证件类型不能为空");
			return;
		}else if(typeof(CERTID)=="undefined" || CERTID.length==0){
			alert("证件号码不能为空");
			return;
		}else{
			AsControl.OpenPage("/Common/DateReport/CDYClntInfoQry.jsp","CERTTYPE="+CERTTYPE+"&CERTID="+CERTID,"frame_info1");
			//AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","PutOutDate="+putOutDate+"&AccountType="+accountType+"&AccountNo="+accountNo+"&AccountCurrency="+accountCurrency,"frame_list1","");
		}
	}
	//mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
