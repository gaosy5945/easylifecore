<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 客户名单管理
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户名单管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sExternDataType = CurPage.getParameter("ExternDataType") + "";
	String listTempletNo = CurPage.getParameter("DoListTemplet") + ""; //列表模版编号
	String sSql = "";	
	String sCertId = "";
	String sViewCustomerRight = "true";
	
	if("1010".equals(sExternDataType)) sCertId = "PartyCardNum";
	else if("1020".equals(sExternDataType)) sCertId = "CardnNum";
	else if("1030".equals(sExternDataType)) sCertId = "Identity";
	else if("1040".equals(sExternDataType)) sViewCustomerRight = "false";
	else if("1050".equals(sExternDataType)) sCertId = "Merchant_Code";
	else if("1060".equals(sExternDataType)) sCertId = "Identity";
	else if("1070".equals(sExternDataType)) sViewCustomerRight = "false";
	else if("1080".equals(sExternDataType)) sCertId = "IdcardCode";
	 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆

	ASDataObject doTemp = new ASDataObject(listTempletNo);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExternDataType);//传入显示模板参数
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		   {sViewCustomerRight,"","Button","客户详情","查看客户详情","viewCustomerInfo()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo(){
		var sCertId = getItemValue(0,getRow(),"<%=sCertId%>");
		var customerID;
		var customerType;
		
		if(typeof(sCertId)!="undefined"&&sCertId!=null){
// 			var sColName = "CustomerId@CustomerName";
// 			var sTableName = "CUSTOMER_INFO";
// 			var sWhereClause = "String@CertID@"+sCertId+"@String@CertType@1";
			
// 			var sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName + ",tableName=" + sTableName + ",whereClause=" + sWhereClause);
			
			 //获得客户编号及客户类型
	        var sColName = "CustomerId@CustomerType";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertId+"@String@CertType@1";
			
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue","getColValue","colName="+sColName + ",tableName=" + sTableName + ",whereClause=" + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") {
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++){
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++){
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++){
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++){
						//设置客户编号
						if(my_array2[n] == "customerid")
							customerID = sReturnInfo[n+1];
						//设置客户名称
						if(my_array2[n] == "customertype")
							customerType = sReturnInfo[n+1];
					}
				}	
				if(typeof(customerID)=="undefined" || customerID.length==0){
					alert("本行无该客户信息！");
					return;
				}
				CustomerManage.viewCustomer(customerID,customerType);
				return;
			}
		}
		else{
			alert("请选择一条记录！");
		}
	}
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
