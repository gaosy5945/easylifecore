<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:gfTang 2014/04/26
		Tester:
		Content: 授信额度调整列表页面
		Input Param:
			FreezeFlag：标志（1：有效；2：冻结；3：解冻；4：终止）
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度调整"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数		
	String sFreezeFlag =  CurPage.getParameter("FreezeFlag");
	if(sFreezeFlag == null) sFreezeFlag = "";

%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义变量				
	String sTempletNo="";
	String today = DateHelper.getToday();
	Boolean isValid = false; //标志当前额度记录是否有效
	Boolean unFreeze = false;//标志是否需要解冻按钮
	Boolean stop = false;//标志是否需要终止
		
	String flagArr[] =sFreezeFlag.split(",");
	if(flagArr.length>1){
		sTempletNo = "CreditLineAdjustValidList";//所有有效记录
		isValid=true;
		unFreeze = false;
		stop = true;
	}
	if(flagArr.length==1){
		if("2".equals(flagArr[0])){//已冻结的列表
			sTempletNo = "CreditLineAdjustFreezeList";
			isValid=false;
			unFreeze=true;
			stop = true;
		}else{//已终止的列表
			sTempletNo = "CreditLineAdjustStopList";
			isValid=false;
			unFreeze = false;
			stop = false;
		}
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	 ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页

	//定义后续事件
	
	//生成HTMLDataWindow
	 dwTemp.genHTMLObjectWindow(today+","+today+","+today);//传入显示模板参数
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
 		{(isValid?"true":"false"),"","Button","冻结","冻结所选的额度记录","freezeRecord()","","","",""},
 		{(stop?"true":"false"),"","Button","终止","终止所选的额度记录","stopRecord()()","","","",""},
		{(unFreeze?"true":"false"),"","Button","解冻","解冻所选的额度记录","unfreezeRecord()","","","",""}, 
		{"true","","Button","额度详情","查看/修改详情","openWithObjectViewer()","","","",""}
		};
		
	%> 
<%/*~END~*/%>
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=冻结授信额度;InputParam=无;OutPutParam=无;]~*/
	function freezeRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getBusinessMessage('400')))//确实要冻结该笔授信额度吗？
		{
			//冻结操作
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.FreezeCreditLine","freezeCreditLine","serialNo="sSerialNo+",freezeFlag="+"2");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('401'));//冻结授信额度失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('402'));//冻结授信额度成功！
			}	
		}	
	}
	//终止授信额度
	function stopRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getBusinessMessage('406')))//确实要终止该笔授信额度吗？
		{
			//终止操作
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.FreezeCreditLine","freezeCreditLine","serialNo="+sSerialNo+",freezeFlag="+"4");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('407'));//终止授信额度失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('408'));//终止授信额度成功！
			}
		}		
	}
	
	/*~[Describe=解冻授信额度;InputParam=无;OutPutParam=无;]~*/
	function unfreezeRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getBusinessMessage('403')))//确实要解冻该笔授信额度吗？
		{
			//解冻操作
			sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.FreezeCreditLine","freezeCreditLine","serialNo="sSerialNo+",freezeFlag="+"3");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('404'));//解冻授信额度失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('405'));//解冻授信额度成功！
			}	
		}	
	}
			
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		customerID=getItemValue(0,getRow(),"CUSTOMERID");
		var isShow = "false";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
		//var sReturn = RunMethod("com.amarsoft.app.lending.bizlets.CheckRolesAction","checkRolesAction","customerID="+customerID+",userID="+"<%=CurUser.getUserID()%>");
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CustomerRoleAction","checkBelongAttributes","CustomerID="+sCustomerID+",UserID=<%=CurUser.getUserID()%>");
		if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        return;
    	}
	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
                        
		if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    
			isShow="true";
		}
		popComp("","/CreditManage/CreditLine/CreditLineInfoTab.jsp","SerialNo="+sSerialNo+"&CustomerID="+customerID+"&isShow="+isShow);
    	reloadSelf();
	}
    
	</script>
<%/*~END~*/%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
