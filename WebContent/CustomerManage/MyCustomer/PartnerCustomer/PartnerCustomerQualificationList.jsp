<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	String IsBlackList = Sqlca.getString(new SqlObject("select listType from customer_list where CUSTOMERID =:CustomerID").setParameter("CustomerID",customerID));
	
	ASObjectModel doTemp = new ASObjectModel("PCQualificationList");
	//当listType取特殊黑名单，设置“是否黑名单”字段的取值为1，否则为0
	//根据listType的不同，设置不同的字段显示
	if("00".equals(listType.substring(0, 2))&&!"0001".equals(listType)&&!"0004".equals(listType)&&!"0010".equals(listType)){
		doTemp.setColumnAttribute("CERTNAME", "colheader", "经营资质");
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "经营资质有效期限");
	}else if("0004".equals(listType)){//经销商相关字段处理
		doTemp.setColumnAttribute("CERTNAME", "colheader", "经营品牌");
		doTemp.setVisible("CERTTYPE", true);
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "经营资质有效期限");
	}else if("0010".equals(listType)){//公证机构相关字段处理
		
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var listType = "<%=listType%>";
		AsControl.PopComp("/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerQualificationInfo.jsp","CustomerID=<%=customerID%>"+"&InsertFlag=1"+"&ListType="+listType,"resizable=yes;dialogWidth=550px;dialogHeight=450px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var listType = "<%=listType%>";
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.PopComp("/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerQualificationInfo.jsp","SerialNo="+serialNo+"&ListType="+listType,"resizable=yes;dialogWidth=550px;dialogHeight=450px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function del(){
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			    alert(getHtmlMessage('1'));//请选择一条信息！
			    return;
			}
			if(confirm('确实要删除吗?')){
				as_delete(0);
			}
	}
	function initRow(){
		IsBlackList="<%=IsBlackList%>";
		<%if(IsBlackList.substring(0, 2).equals("70") && IsBlackList.length()>2){%>
			setItemValue(0,0,"ISBLACKLIST","1");
		<%}else{%>
        	setItemValue(0,0,"ISBLACKLIST","0");
		<%}%>
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
