<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
	Author: zqliu 2014-11-18
	Tester:
	Describe: 取消恢复诉讼信息;
	Input Param:
		sObjectType：按钮类型（01：取消诉讼，02：恢复诉讼，03：查看取消诉讼）
		SerialNo: 诉讼案件流水号
		//BookType：取消还是恢复 （Cancel、Recover）
			
	Output Param:

	HistoryLog:
					 
 */
%>
<%
	//获得组件参数	
	String sTitle="";
	//获得组件参数（按钮类型、案件流水号、信息类型）
	String sObjectType = (String)CurComp.getParameter("ObjectType");
	String sBookType="";
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	//将空值转化为空字符串
	if(sObjectType==null || "Null".equalsIgnoreCase(sObjectType)) sObjectType="";
	if(sSerialNo==null || "Null".equalsIgnoreCase(sSerialNo)) sBookType="";

	if ("02".equals(sObjectType) || "02"==sObjectType)
	{
		sTitle = "恢复诉讼信息";
		 sBookType="Recover";
	}
	
	if ("01".equals(sObjectType) || "02"==sObjectType ||"03".equals(sObjectType) || "03"==sObjectType)
	{
		sTitle = "取消诉讼信息";
		 sBookType="Cancel";
	}
	

	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "LawCaseReasons";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	if ("02".equals(sObjectType) || "02"==sObjectType){
		doTemp.setVisible("EvidenceCatalog", true);//恢复诉讼理由
		doTemp.setRequired("EvidenceCatalog", true);
	}
	if ("01".equals(sObjectType) || "01"==sObjectType ||"03".equals(sObjectType) || "03"==sObjectType){
		doTemp.setVisible("RefusedReason", true);//取消诉讼理由
		doTemp.setRequired("RefusedReason", true);//
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","goBack()","","","",""}
	};
	
	if ("03".equals(sObjectType) || "03"==sObjectType){
		sButtons[0][0]="false";
	}
	sButtonPosition = "south";
	
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sLawcaseName = "";
	String sCasePhase = "";
	String sCasePhaseName = "";
	String sLawcaseType = "";
	String sLawcaseTypeName = "";
	String sOldCasePhase = "";
	sSql =  " select LawcaseName,CasePhase,getItemName('CasePhase',CasePhase) as CasePhaseName,LawcaseType,getItemName('LawCaseType',LawcaseType) as LawcaseTypeName , OldCasePhase "+
	        " from LAWCASE_INFO  where SerialNo =:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
   	rs = Sqlca.getASResultSet(so); 	   	
   	if(rs.next()){
		sLawcaseName = rs.getString("LawcaseName");
		sCasePhase = rs.getString("CasePhase");
		sCasePhaseName = rs.getString("CasePhaseName");			
		sLawcaseType = rs.getString("LawcaseType");
		sLawcaseTypeName = rs.getString("LawcaseTypeName");
		sOldCasePhase = rs.getString("OldCasePhase");
	 }		 
	 rs.getStatement().close();
	 if(sLawcaseName==null)sLawcaseName="";
	 if(sCasePhase==null)sCasePhase="";
	 if(sCasePhaseName==null)sCasePhaseName="";
	 if(sLawcaseType==null)sLawcaseType="";
	 if(sLawcaseTypeName==null)sLawcaseTypeName="";
	 if(sOldCasePhase==null)sOldCasePhase="";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert=false;
	var sSaveFlag="FALSE";
	my_load(2,0,'myiframe0');
	initRow();
	//---------------------定义按钮事件------------------------------------
		
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{

		setItemValue(0,0,"BookType","<%=sBookType%>");					
		setItemValue(0,0,"LawCaseSerialNo","<%=sSerialNo%>");
		var sDate="<%=StringFunction.getToday()%>";
		setItemValue(0,0,"UpdateDate", sDate);
		setItemValue(0,0,"LIUpdateDate",sDate);
		var sReasons = "";
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		var sObjectType = "<%=sObjectType%>";
		var sCasePhase="";
		var sMsg = "";
		//取消诉讼时，将原来的阶段保存
		if ( "01"==sObjectType || "03"==sObjectType){
			sCasePhase=getItemValue(0,getRow(),"CASEPHASE");
			setItemValue(0,0,"OLDCASEPHASE",sCasePhase);
			setItemValue(0,0,"CASEPHASE","110");
			sCasePhase="110";
			sReasons = getItemValue(0,getRow(),"REFUSEDREASON");
			sMsg = "请输入取消诉讼理由！";
		}
		//恢复诉讼时，将阶段恢复
		if ("02"==sObjectType){
			sCasePhase=getItemValue(0,getRow(),"OLDCASEPHASE");
			if(sCasePhase=="" || sCasePhase=="Null" || sCasePhase=="null") sCasePhase="010"
			setItemValue(0,0,"CASEPHASE",sCasePhase);
			sReasons = getItemValue(0,getRow(),"EVIDENCECATALOG");
			sMsg = "请输入恢复诉讼理由！";
		}
		if(sReasons=="" || sReasons=="undefined" || sReasons=="null" || sReasons==null){
			alert(sMsg);
			return;
		}
		beforeUpdate();
		as_save("myiframe0",setSaveFlag());	
		if(sSaveFlag=="TRUE"){
			var sRetrunValue1 =  RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sCasePhase+",LAWCASE_INFO,String@SerialNo@"+"<%=sSerialNo%>");
			if(sRetrunValue1=="TRUE"){
				self.returnValue="TRUE";
				self.close();
			}
		}
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function setSaveFlag()
	{
		sSaveFlag="TRUE";
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	/*~[Describe=执行新增操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段		
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//新增记录
			bIsInsert = true;	

			//台帐类型
			setItemValue(0,0,"BookType","<%=sBookType%>");					
			setItemValue(0,0,"LawCaseSerialNo","<%=sSerialNo%>");
			
			setItemValue(0,0,"LawcaseName","<%=sLawcaseName%>");					
			setItemValue(0,0,"CasePhase","<%=sCasePhase%>");
			setItemValue(0,0,"CasePhaseName","<%=sCasePhaseName%>");					
			setItemValue(0,0,"LawcaseType","<%=sLawcaseType%>");
			setItemValue(0,0,"LawcaseTypeName","<%=sLawcaseTypeName%>");					
			setItemValue(0,0,"OldCasePhase","<%=sOldCasePhase%>");
								
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//登记日期	更新日期					
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"LIUpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "LAWCASE_Book";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
