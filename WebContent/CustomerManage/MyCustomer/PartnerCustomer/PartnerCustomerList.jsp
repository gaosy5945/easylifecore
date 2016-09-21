<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PartnerCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	String listType = CurPage.getParameter("ListType");
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("InputOrgID", CurOrg.getOrgID());
	dwTemp.setParameter("InputUserID", CurUser.getUserID());
	dwTemp.setParameter("listType", listType);
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","合作方注册","合作方注册","add()","","","","btn_icon_add",""},
			{"true","All","Button","合作方详情","合作方详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","合作方退出","合作方退出","del()","","","","btn_icon_delete",""},
		};
	if(listType.equals("0020")) {
		sButtons[1][3] = "商户详情";
		sButtons[2][3] = "商户退出";
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
			alert("请选择一条信息！");
			return;
		}
		 CustomerManage.editCustomerPartner(sCustomerID, listType);
	}
	function del(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(0),"CustomerID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要移除该合作方吗?')){
			var sReturn = CustomerManage.selectPartnerIsDelete(sCustomerID,"<%=CurUser.getUserID()%>","<%=CurOrg.getOrgID()%>");
			if(sReturn == "PrjFull"){
				alert("该合作方已关联有效的合作项目，不允许移除！");
				return;
			}else{
				CustomerManage.deletePartner(sCustomerID,"<%=CurUser.getUserID()%>","<%=CurOrg.getOrgID()%>");
				reloadSelf();
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
