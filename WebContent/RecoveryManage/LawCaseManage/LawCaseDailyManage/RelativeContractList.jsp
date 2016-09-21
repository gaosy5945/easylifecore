<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  zqliu
		Tester:
		Content: 案件相关合同列表
		Input Param:
				SerialNo:案件编号				  
		Output param:
				
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "案件相关合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";	
	
	//获得组件参数（案件流水号）		
	String sSerialNo =   CurComp.getParameter("SerialNo");//DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";	
   //获取合同终结类型
    String sFinishType =CurComp.getParameter("FinishType"); //DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    if(sFinishType == null) sFinishType = "";
    //获取归档日期
    String sPigeonholeDate =CurComp.getParameter("PigeonholeDate"); //DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PigeonholeDate"));   
    if( sPigeonholeDate == null) sPigeonholeDate = "";
	
%>
<%/*~END~*/%>


<%

	String sTempletNo = "RelativeContractList";//模型编号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sSerialNo);

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
			{"true","All","Button","引入关联合同","引入关联合同信息","my_relativecontract()","","","",""},
			{"true","","Button","合同详情","查看合同详情","viewAndEdit()","","","",""},
			{"true","All","Button","取消关联合同","解除案件与合同的关联关系","deleteRecord()","","","",""},
			//{"true","","Button","还款计划登记","还款计划登记","addcrs()","","","",""},
			//{"true","","Button","催收登记","催收登记","viewAndEdit()","","","",""},
			//{"true","","Button","放款记录查询","放款记录查询","viewAndEdit()","","","",""},
			//{"true","","Button","余额变动记录查询","余额变动记录查询","viewAndEdit()","","","",""},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ContractInfo;Describe=查看合同详情;]~*/%>
	<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
		
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");  
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");  
		var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");  
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			//删除案件与所选合同的关联关系
			sReturn = RunMethod("BusinessManage","DeleteRelative",sSerialNo+","+sObjectType+","+sObjectNo+",LAWCASE_RELATIVE");
			if(sReturn > -1)
			{
				alert(getBusinessMessage("751"));//该案件的关联合同删除成功！
				OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("752"));//该案件的关联合同删除失败，请重新操作！
				return;
			}			
		}
	}	

	function my_relativecontract()
	{ 
		<%-- var sURL = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractChooseList.jsp";
		var sPara = "";
		var sStyle = "";
		var dialogArgs = "";
		AsControl.PopComp(sURL, sPara, sStyle, dialogArgs);
		//获取案件关联的合同流水号	
		--%>
		var sRelativeContractNo ;	
		var sContractInfo = AsDialog.SelectGridValue('RelativeContractChooseList',"<%=CurUser.getOrgID()%>",'SERIALNO','',"true","",'','1');
		//var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_") 
		{
			sRelativeContractNo = sContractInfo.split('~');
		}
		//如果选择了合同信息，则判断该合同是否已和当前的案件建立了关联，否则建立关联关系。
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			for(var k=0;k<sRelativeContractNo.length;k++){
				sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,LAWCASE_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeContractNo[k]);
				if(typeof(sReturn) != "undefined" && sReturn != "") 
				{			
					sReturn = sReturn.split('~');
					var my_array = new Array();
					for(i = 0;i < sReturn.length;i++)
					{
						my_array[i] = sReturn[i];
					}
					
					for(j = 0;j < my_array.length;j++)
					{
						sReturnInfo = my_array[j].split('@');				
						if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
						{						
							if(sReturnInfo[0] == "objectno")
							{
								if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeContractNo[k])
								{
									alert(sRelativeContractNo[k]+getBusinessMessage("753"));//所选合同已被该案件引入,不能再次引入！
									return;
								}
							}				
						}
					}			
				}
				//新增案件与所选合同的关联关系
				sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo[k]+",LAWCASE_RELATIVE");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert(sRelativeContractNo[k]+getBusinessMessage("754"));//引入关联合同成功！
					OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
				}else {
					alert(sRelativeContractNo[k]+getBusinessMessage("755"));//引入关联合同失败，请重新操作！
					return;
				}
			}	
		}
	}

	/*~[Describe=查看合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		/* var sOBJECTNO = getItemValue(0,getRow(0),'OBJECTNO');//合同流水号
		var sCustomerID = getItemValue(0,getRow(0),'CustomerID');
		AsCredit.openFunction("ContractInfo", "ObjectNo="+sOBJECTNO+"&CustomerID="+sCustomerID);
		 */
		var serialNo = getItemValue(0,getRow(0),'OBJECTNO');
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("ContractTab", "SerialNo="+serialNo+"&rightType=ReadOnly");

		reloadSelf();
	}	
	//还款计划登记
	function addcrs(){
		var taskSerialNo = getItemValue(0,getRow(0),'TaskSerialNo');
		var objectNo = getItemValue(0,getRow(0),'SerialNo');
	 	if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
	 	}
		AsCredit.openFunction("CollRepaymentList","TaskSerialNo="+taskSerialNo+"&ObjectNo="+objectNo);
		reloadSelf();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	
	//init();
	//my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
