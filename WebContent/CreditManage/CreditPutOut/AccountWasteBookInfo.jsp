<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "业务流水信息";
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountType"));
	if(sAccountType.equals("01"))//01对应发放   02对应回收
		sAccountType = "0";
	else
		sAccountType = "1";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo="";
	String sSql = "";
	sSql = "select OccurDirection from BUSINESS_WASTEBOOK where SerialNo=:SerialNo";
	String sOccurDirection = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if(sOccurDirection == null){
		sOccurDirection=sAccountType; //1.是回收
	}
	if(sOccurDirection.equals("1")){
		sTempletNo="1_AccountWasteBookInfo";
	}else{
		sTempletNo="2_AccountWasteBookInfo";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	sSql="select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	String sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	sSql="select attribute4 from BUSINESS_TYPE where TypeNo=:TypeNo";
	String sOrigin = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	if (sOrigin == null) sOrigin = "";
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sAccountType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","保存","保存所有修改","saveRecord()","","","",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","",""}
			};

		//假如为回收且数据来源不是628
		//if (sOccurDirection.equals("1") && !sOrigin.equals("010")) {
			//sButtons[0][0] = "true";
		//}
		%>
	<%/*~END~*/%>


	<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
		<%@include file="/Resources/CodeParts/Info05.jsp"%>
	<%/*~END~*/%>


	<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
		<script type="text/javascript">
		var bIsInsert = false; //标记DW是否处于“新增状态”

		//---------------------定义按钮事件------------------------------------
		/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
		function saveRecord(sPostEvents)
		{
			if(bIsInsert){
				beforeInsert();
				bIsInsert = false;
			}

			as_save("myiframe0",sPostEvents);	
		}

		/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
		function goBack()
		{
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookList.jsp","_self","");
		}

		</script>
	<%/*~END~*/%>


	<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
		<script type="text/javascript">

		function beforeInsert()
		{		
			initSerialNo();//初始化流水号字段
		}

		/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
		function initSerialNo() 
		{
			var sTableName = "BUSINESS_WASTEBOOK";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀

			//获取流水号
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
			//将流水号置入对应字段
			setItemValue(0,getRow(),sColumnName,sSerialNo);
		}

		/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
		function initRow()
		{
			if (getRowCount(0)==0)
			{
				as_add("myiframe0");//新增记录
				bIsInsert = true;
				setItemValue(0,0,"OccurDirection","<%=sAccountType%>");
				setItemValue(0,0,"RelativeContractNo","<%=sObjectNo%>");
				setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
				setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
				setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			}
	    }

		</script>
	<%/*~END~*/%>


	<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
	<script type="text/javascript">	
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	</script>	
	<%/*~END~*/%>

	<%@ include file="/IncludeEnd.jsp"%>