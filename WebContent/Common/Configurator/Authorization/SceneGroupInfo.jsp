<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "授权组别信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String sGroupID = CurPage.getParameter("GroupID");
	String sSortNo = "";
	//将空值转化成空字符串
	if(sGroupID.length()==0) {
		//---------当GroupId为空时,认为新增操作,生成排序号
		DecimalFormat format = new DecimalFormat("00");
		String sortBase = DateHelper.getCurDateByFormat("yyMMddHH");		//排序号规则yyMMddHHxx00
		ASResultSet resultset = Sqlca.getASResultSet("select count(*) as RowCount from SADRE_SCENEGROUP O where O.SORTNO like '"+sortBase+"%'");
		if(resultset.next()){
			int rowCount = resultset.getInt("RowCount");
			sSortNo = sortBase+format.format(++rowCount)+"01";
		}
		resultset.getStatement().close();
	}
		
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AuthorGroupInfo";
	//根据模板编号设置数据对象	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	String sButtons[][] = {
		{"true","","Button","保存","保存","doCreation()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script language=javascript>
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){                
        <%if (sGroupID==null || sGroupID.length()==0){%>//表示只是新增才会重新获取流水
			initSerialNo();
		<%}%>
        as_save("myiframe0",sPostEvents);
        parent.reloadSelf();
    }
	
	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation(){
		saveRecord("doReturn()");
	}
	
	function doReturn(){
		top.returnValue = getItemValue(0,0,"GROUPID");
	}
								
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增一条空记录			
			setItemValue(0,0,"SORTNO","<%=sSortNo%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "SADRE_SCENEGROUP";//表名
		var sColumnName = "GROUPID";//字段名
		var sPrefix = "";//前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		//var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>