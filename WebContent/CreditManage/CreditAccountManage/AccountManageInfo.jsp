<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "账户管理详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数:账号
	String sAccount =  CurComp.getParameter("Account");
	String readOnly =  CurComp.getParameter("ReadOnly");
	if(sAccount==null) sAccount = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountManageInfo"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,sTempletFilter);
	
    if(!sAccount.equals("")){
    	doTemp.setReadOnly("Account,IsOwnBank",true);	
    }
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccount);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"y".equalsIgnoreCase(readOnly)?"true":"false","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"false","","Button","返回","返回列表页面","goBack()","","","",""}
    };
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		if(bIsInsert){
			if (!ValidityCheck()){
				return;
			}else{
				as_save("myiframe0");
			}
		}else{
			alert("账户详情不可修改");
		}
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function goBack(){
        self.close();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>")
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"AccountSource","020");
			bIsInsert = true;
		}
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回客户的相关信息、客户代码、客户名称		
		sReturn = setObjectValue("SelectOrgCustomer","","@CustomerID@0@CustomerName@1",0,0,"");
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CustomerID",false);
			setItemDisabled(0,0,"CustomerName",false);
		}else{
			//防止用户点开后，什么也不选择，直接取消，而锁住这几个区域
			sCustomerID = getItemValue(0,0,"CustomerID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}else{
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}
		}
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		sAccount = getItemValue(0,getRow(),"Account");//账号
		//检查账户的有效性
		if (sAccount.length > 0){
			var Letters = "#";
			//检查字符串中是否存在"#"字符
			if (!(sAccount.indexOf(Letters) == -1)){
				alert("输入的账号有误，请重新输入账号");
				return false;
			}
		}		
		//检查账户的唯一性
		sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckAccountChangeCustomer","checkAccountChangeCustomer","account="+sAccount);
		if(typeof(sReturn) != "undefined" && sReturn == "false"){
			alert("账户已经登记");
			return false;
		}else
			return true;
	}

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>