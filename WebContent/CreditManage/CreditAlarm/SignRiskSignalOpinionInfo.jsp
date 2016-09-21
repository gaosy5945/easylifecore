<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
	Content: 签署预警信号认定意见
	Input Param:
		ObjectNo：预警信号流水号
		SignalType：预警类型（01：发起；02：解除）
	*/
	String PG_TITLE = "签署认定意见";
	//定义变量
	String sSql = "";
	//获取组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sSignalType = DataConvert.toRealString(iPostChange,CurComp.getParameter("SignalType"));
	//将空值转化为空字符串	
	if(sObjectNo == null) sObjectNo = "";
	if(sSignalType == null) sSignalType = "";

	String sHeaders[][]={     
							{"ConfirmType","核实方法"},
							{"NextCheckDate","下次预警检查日期"},
							{"NextCheckUserName","下次预警检查人"},
							{"SignalLevel","预警级别"},
							{"opinion","认定意见"},
							{"Remark","备注"},
							{"CheckOrgName","认定机构"},
							{"CheckUserName","认定人"},
							{"CheckDate","认定时间"}                  
                        };                    
	sSql =  " select SerialNo,ObjectNo,ConfirmType,NextCheckDate,NextCheckUser, "+
			" GetUserName(NextCheckUser) as NextCheckUserName,SignalLevel,Opinion, "+
			" Remark,CheckOrg,GetOrgName(CheckOrg) as CheckOrgName,CheckUser, "+
			" GetUserName(CheckUser) as CheckUserName,CheckDate "+
			" from RISKSIGNAL_OPINION "+
			" where ObjectNo = '"+sObjectNo+"' "+
			" and CheckUser = '"+CurUser.getUserID()+"' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISKSIGNAL_OPINION";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectNo,CheckUser,CheckOrg,NextCheckUser",false);
	
	//设置下拉框内容
	doTemp.setDDDWCode("ConfirmType","ConfirmType");
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
		
	//设置格式
	doTemp.setCheckFormat("NextCheckDate","3");	
	doTemp.setHTMLStyle("CheckUserName,CheckDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("Opinion,Remark"," style={height:100px;width:400px} ");
	doTemp.setEditStyle("Opinion,Remark","3");
 	doTemp.setLimit("Opinion,Remark",100);
 	doTemp.setReadOnly("CheckOrgName,CheckUserName,CheckDate",true);
 	doTemp.setRequired("ConfirmType,Opinion",true);
 	if(sSignalType.equals("02")) 	
 		doTemp.setVisible("NextCheckDate,NextCheckUserName,SignalLevel",false);
	if(sSignalType.equals("01"))
		doTemp.setRequired("NextCheckDate,NextCheckUserName",true);
  	doTemp.setUpdateable("NextCheckUserName,CheckOrgName,CheckUserName",false);
  	doTemp.setUnit("NextCheckUserName","<input type=button value=\"...\" onClick=parent.selectUser()>");		
	
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		if(bIsInsert){
			beforeInsert();
		}
		//不允许签署的意见为空白字符
		if(/^\s*$/.exec(getItemValue(0,0,"Opinion"))){
			alert("请签署认定意见！");
			setItemValue(0,0,"Opinion","");
			return;
		}
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=关闭此页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		self.close();
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"CheckUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"CheckUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"CheckOrg","<%=CurOrg.getOrgID()%>");			
			setItemValue(0,0,"CheckOrgName","<%=CurOrg.getOrgName()%>");		
			setItemValue(0,0,"CheckDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
    }
    
    /*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "RISKSIGNAL_OPINION";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
    
    /*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(){
		setObjectValue("SelectAllUser","","@NextCheckUser@0@NextCheckUserName@1",0,0,"");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>