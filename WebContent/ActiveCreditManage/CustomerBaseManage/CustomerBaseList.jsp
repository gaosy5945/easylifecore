<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	ASObjectModel doTemp = new ASObjectModel("CustomerBaseList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
   	//dwTemp.setParameter("CustomerType", customerType+"%");
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","客群新建","客群新建","newCustomerBase()","","","","btn_icon_add",""},
			{"true","","Button","客群详情","客群详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除客群","del()","","","","btn_icon_delete",""},
			{"true","","Button","附件上传/下载","附件上传/下载","downLoad()","","","","",""},
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
		alert("请选择一条信息！");
		return;
	}
	AsControl.PopComp("/ActiveCreditManage/CustomerBaseManage/CustomerBaseInfo.jsp","CustomerBaseID="+CustomerBaseID,"resizable=yes;dialogWidth=450px;dialogHeight=350px;center:yes;status:no;statusbar:no");
	reloadSelf();
} 
function del(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	if (typeof(CustomerBaseID)=="undefined" || CustomerBaseID.length==0){
		alert("请选择一条信息！");
		return;
	}
	var flag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerApproval", "CustomerBaseID="+CustomerBaseID);
	if(flag == "1"){
		alert("该客群已关联预审批，不允许删除！");
		return;
	}else{
		if(confirm('确实要删除该客群吗?')){
			as_delete(0,'');
		}
	}
}
function downLoad(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	if (typeof(CustomerBaseID)=="undefined" || CustomerBaseID.length==0){
		alert("请选择一条信息！");
		return;
	}
	var DocNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseDocNo", "CustomerBaseID="+CustomerBaseID);
	AsControl.PopPage("/ActiveCreditManage/CustomerBaseManage/CustomerBaseDoc.jsp","ObjectNo="+CustomerBaseID+"&ObjectType=jbo.customer.CUSTOMER_BASE"+"&DocNo="+DocNo,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
