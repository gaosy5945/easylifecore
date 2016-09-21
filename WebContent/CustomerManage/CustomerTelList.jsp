<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sCustomerID =  CurComp.getParameter("CustomerID");
	String sListType = CurPage.getParameter("ListType");
	if(sCustomerID == null) sCustomerID=""; 
	ASObjectModel doTemp = new ASObjectModel("CustomerTelList");
	
	if("0020".equals(sListType) || "0021".equals(sListType)){//对于商户门店，联系方式需要体现联系人
		doTemp.setVisible("OWNER",true);
		doTemp.setVisible("RELATIONSHIP",true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sCustomerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
			{"true","All","Button","设置最新","设置最新","setIsNew(1)","","","","",""},
			{"true","All","Button","取消最新","取消最新","setIsNew(0)","","","","",""},

		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.OpenPage("/CustomerManage/CustomerTelInfo.jsp","CustomerID=<%=sCustomerID%>","_self","");
		reloadSelf();
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.OpenPage("/CustomerManage/CustomerTelInfo.jsp","SerialNo="+serialNo,"_self","");
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
	
	function setIsNew(status){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//获得地址类型
		var sTelType = getItemValue(0,getRow(),"TelType");
		var sIsNew = getItemValue(0,getRow(),"IsNew");
		if(status == "1")
		{
			if(sIsNew == "1")
			{
				alert("该记录已是最新状态，无需设置最新！");
				return;
			}
			
		    var sReturn =  RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerTelAction","checkCustomerTel","CustomerID=<%=sCustomerID%>"+
		    		",TelType="+sTelType);
		    
		    if(sReturn == "true"){
		    	alert("该电话类型已存在一个最新的！");
		    	return;
		    }
	
		}
		
		if(status == "2"){
			if(sIsNew == "2")
			{
				alert("此记录不需要做取消最新操作！");
				return;
			}
		}
		
   	 	var sFlag = RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.CustomerTelAction","setCustomerTelIsNew","SerialNo="+sSerialNo+",Status="+status);
		
   	 	if(sFlag=="true"){
			alert("操作成功！");
			reloadSelf();
		}else{
			alert("操作失败！");
		} 

	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
