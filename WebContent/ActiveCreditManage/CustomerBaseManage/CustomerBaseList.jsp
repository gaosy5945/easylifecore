<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	ASObjectModel doTemp = new ASObjectModel("CustomerBaseList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
   	//dwTemp.setParameter("CustomerType", customerType+"%");
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��Ⱥ�½�","��Ⱥ�½�","newCustomerBase()","","","","btn_icon_add",""},
			{"true","","Button","��Ⱥ����","��Ⱥ����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ����Ⱥ","del()","","","","btn_icon_delete",""},
			{"true","","Button","�����ϴ�/����","�����ϴ�/����","downLoad()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function newCustomerBase(){
	AsControl.PopComp("/ActiveCreditManage/CustomerBaseManage/CustomerBaseInfo.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=350px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
function viewAndEdit(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	if (typeof(CustomerBaseID)=="undefined" || CustomerBaseID.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	AsControl.PopComp("/ActiveCreditManage/CustomerBaseManage/CustomerBaseInfo.jsp","CustomerBaseID="+CustomerBaseID,"resizable=yes;dialogWidth=450px;dialogHeight=350px;center:yes;status:no;statusbar:no");
	reloadSelf();
} 
function del(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	if (typeof(CustomerBaseID)=="undefined" || CustomerBaseID.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	var flag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerApproval", "CustomerBaseID="+CustomerBaseID);
	if(flag == "1"){
		alert("�ÿ�Ⱥ�ѹ���Ԥ������������ɾ����");
		return;
	}else{
		if(confirm('ȷʵҪɾ���ÿ�Ⱥ��?')){
			as_delete(0,'');
		}
	}
}
function downLoad(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	if (typeof(CustomerBaseID)=="undefined" || CustomerBaseID.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	var DocNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseDocNo", "CustomerBaseID="+CustomerBaseID);
	AsControl.PopPage("/ActiveCreditManage/CustomerBaseManage/CustomerBaseDoc.jsp","ObjectNo="+CustomerBaseID+"&ObjectType=jbo.customer.CUSTOMER_BASE"+"&DocNo="+DocNo,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
