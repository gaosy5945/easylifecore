<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  zqliu
		Tester:
		Content: 查封资产列表
		Input Param:
				SerialNo:案件编号
				BookType：台帐类型				      
		Output param:
				SerialNo：查封资产编号
				AssetType：查封资产类型
				ObjectNo:对象编号或案件编号
				ObjectType:对象类型
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "查封资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
		
	//获得组件参数（案件流水号、台帐类型）	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BookType"));
	//获取合同终结类型
    String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    String sPigeonholeDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PigeonholeDate"));   

	//将空值转化为空字符串
    if( sPigeonholeDate == null) sPigeonholeDate = "";
	if(sBookType == null) sBookType = "";
	if(sSerialNo == null) sSerialNo = "";
    if(sFinishType == null) sFinishType = "";
	
%>
<%/*~END~*/%>

<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LawsuitAssetsList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","All","Button","新增","新增一条记录","newRecord()","","","",""},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","",""},
			{"true","","Button","退出查封","退出查封资产信息","quitRecord()","","","",""}
			};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{			
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?BookType=<%=sBookType%>&ObjectNo=<%=sSerialNo%>&ObjectType=LawcaseInfo&SerialNo=","right","");  
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得记录流水号、案件编号或对象编号、对象类型、查封资产类型
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sLawsuitAssetsType=getItemValue(0,getRow(),"AssetType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?PageSerialNo="+sSerialNo+"&BookType=<%=sBookType%>&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"","right","");

	}
	/*~[Describe=退出查封;InputParam=无;OutPutParam=SerialNo;]~*/
	function quitRecord()
	{
		//获得记录流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getBusinessMessage("774"))) //该查封资产真的要退出查封吗？
		{
			var sReturn = RunMethod("PublicMethod","UpdateColValue","String@AssetStatus@02,ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturn == "TRUE") //刷新页面
			{
				alert(getBusinessMessage("775"));//该查封资产已成功退出查封！
				reloadSelf();
			}else
			{
				alert(getBusinessMessage("776")); //该查封资产退出查封失败！
				return;
			}
		}
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
