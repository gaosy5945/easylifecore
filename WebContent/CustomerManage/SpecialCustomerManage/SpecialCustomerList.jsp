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
	String specialCustomerType = CurPage.getParameter("SpecialCustomerType");
	String listTempletNo = CurPage.getParameter("DoListTemplet"); //列表模版编号
	String infoTempletNo = CurPage.getParameter("DoInfoTemplet"); //列表模版编号
	String importTemplet = CurPage.getParameter("ImportTemplet");
	String sSql = "";	
	
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
	Vector vTemp = dwTemp.genHTMLDataWindow(specialCustomerType);//传入显示模板参数
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
		   {"true","","Button","新增","新增","my_add()","","","",""},
		   {"true","","Button","详情","查看黑名单详情","viewAndEdit()","","","",""},
		   {"true","","Button","客户详情","查看客户详情","viewCustomerInfo()","","","",""},
		   {"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'')","","","",""},
		   {"true","","Button","批量导入","批量导入","importData()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function my_add()
	{ 	 
	    	OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustInfo.jsp?DoInfoTemplet=<%=infoTempletNo%>","_self","");
		reloadSelf();
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
				OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustInfo.jsp?SerialNo="+sSerialNo+",DoInfoTemplet=<%=infoTempletNo%>", "_self","");
			reloadSelf();
		}
	}		
	function importData(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var parameter = "SpecialCustomerType=<%=specialCustomerType%>&clazz=jbo.import.excel.<%=importTemplet%>"; 
		var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
		var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
		if(typeof(sReturn) != "undefined" && sReturn != "")
		    {
		    	reloadSelf();
		    }
	}

	function viewCustomerInfo(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)!="undefined"&&customerID!=null){
			var re = RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.HasCustomerInfo", "hasCustOrNot", "customerID="+customerID+"");
			if(re=="SUCCEEDED"){
		    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
				//openObject("Customer",customerID,"003");
				return ;
			}
			alert("本行无该客户信息！");
		}
		else{
			alert("本行无该客户信息！");
		}
	}
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
