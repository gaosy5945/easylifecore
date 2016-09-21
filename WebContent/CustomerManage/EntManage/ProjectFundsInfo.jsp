<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "项目资金来源"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sSql = "";
	ASResultSet rs ;
	String sPlanTotalCast = "";
	String sProjectCapitalScale = "";
	//获得组件参数
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFundSource  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FundSource"));
	if(sFundSource == null ) sFundSource = "";
	if(sSerialNo == null ) sSerialNo = "";

	if(sFundSource.equals("01")){
		sSql = "select PlanTotalCast,CapitalScale from PROJECT_INFO "+
		   " where ProjectNo= :ProjectNo";
		rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ProjectNo",sProjectNo));
		if(rs.next()){
			sPlanTotalCast = rs.getString("PlanTotalCast");
			sProjectCapitalScale = rs.getString("CapitalScale");
		}
		rs.getStatement().close();
	}

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ProjectFundsInfo";	
	String sTempletFilter = "  ColAttribute like '%"+sFundSource+"%' ";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表页面","goBack()","","","",""}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		setObjectValue("SelectInvest","","@INVESTORCODE@0@INVESTORNAME@1",0,0,"");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp?","_self","");
	}
	
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
		setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		return true;
	}

	//选择地区
	function getRegionCode(){
		sParaString = "CodeNo"+",AreaCode";			
		setObjectValue("SelectCode",sParaString,"@LOCATIONOFINVESTOR@0@LOCATIONOFINVESTORNAME@1",0,0,"");
	}	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			if("<%=sFundSource%>"=="010"){	//hxli 投资占比为空，置空白
				if("<%=sPlanTotalCast%>" != "null" ){
					setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					//setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
				
				if("<%=sProjectCapitalScale%>" != "null"){
					//setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
			}
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() {
		var sTableName = "PROJECT_FUNDS";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>