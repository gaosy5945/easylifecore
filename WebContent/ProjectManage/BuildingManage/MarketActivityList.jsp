<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "01";
	String orgID = CurUser.getOrgID();
	ASObjectModel doTemp = new ASObjectModel("MarketActivityList");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(7);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"false","","Button","����","����","edit()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","","",""},
			{"false","All","Button","����","����","copySceneGroup()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		//alert("s");
		 AsControl.OpenView("/ProjectManage/BuildingManage/MarketActivityInfo.jsp","SerialNo="+"","rightdown","");
		 //reloadSelf();
	}
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		as_delete('myiframe0');
		reloadSelf();
	}
	/*��¼��ѡ��ʱ�����¼�*/
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");//getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			return;
		}else{
			AsControl.OpenView("/ProjectManage/BuildingManage/MarketActivityInfo.jsp","SerialNo="+serialNo,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
