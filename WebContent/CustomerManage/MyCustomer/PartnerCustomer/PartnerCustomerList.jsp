<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PartnerCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	String listType = CurPage.getParameter("ListType");
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.setParameter("listType", listType);
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","������ע��","������ע��","add()","","","","btn_icon_add",""},
			{"true","All","Button","����������","����������","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","�������˳�","�������˳�","del()","","","","btn_icon_delete",""},
		};
	if(listType.equals("0020")) {
		sButtons[1][3] = "�̻�����";
		sButtons[2][3] = "�̻��˳�";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function add(){
		var listType='<%=listType%>';
		var result = CustomerManage.newCustomer1(listType);
	 	if(result){
			result = result.split("@");
			if(result[0]=="true"){
				CustomerManage.editCustomerPartner(result[1],result[3]);
			}
		}
	 	reloadSelf();
	}
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(0),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(0),"CustomerID");
		var listType = getItemValue(0,getRow(0),"LISTTYPE");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		 CustomerManage.editCustomerPartner(sCustomerID, listType);
	}
	function del(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(0),"CustomerID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪ�Ƴ��ú�������?')){
			var sReturn = CustomerManage.selectPartnerIsDelete(sCustomerID,"<%=CurUser.getUserID()%>","<%=CurOrg.getOrgID()%>");
			if(sReturn == "PrjFull"){
				alert("�ú������ѹ�����Ч�ĺ�����Ŀ���������Ƴ���");
				return;
			}else{
				CustomerManage.deletePartner(sCustomerID,"<%=CurUser.getUserID()%>","<%=CurOrg.getOrgID()%>");
				reloadSelf();
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
