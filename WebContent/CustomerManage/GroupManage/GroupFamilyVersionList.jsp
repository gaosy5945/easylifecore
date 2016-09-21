<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
    String PG_TITLE = "集团家谱复核意见"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
    //获得组件参数    ：客户类型    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";

	//取得模板号
    String sTempletNo = "GroupApproveOpinionListX";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    
    //产生DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    

    String sButtons[][] = {
		//只有集团家谱变更才显示该按钮
		{"false","","Button","查看复核意见","家谱复核意见详情","viewOpinions()","","","",""},
		{"true","","Button","查看版本详情","家谱版本详情","viewGroupStemma()","","","",""}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	function viewOpinions(){
		//获得集团客户ID
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //更新后家谱版本号（新）
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //更新前家谱版本号（旧）
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ+"&EditRight=Readonly","");
		reloadSelf();
	}
	/*~[Describe=查看集团家谱信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewGroupStemma(){
		//获取业务信息
		sGroupID="<%=sGroupID%>";     //集团客户编号
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //更新后家谱版本号（新）
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //更新后家谱版本号（新）
		if(typeof(sFamilySEQ)=="undefined" || sFamilySEQ.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//var sArgs="GroupID="+ sGroupID+"&FamilySEQ="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ;
		//集团家谱信息
		//PopComp("FamilyVersionInternalList","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalList1.jsp",sArgs,"");
		//PopComp("GroupCustomerFamily","/CustomerManage/GroupManage/GroupCustomerFamily.jsp","GroupID="+sGroupID+"&RightType=ReadOnly","");
		PopComp("GroupCustomerFamily","/CustomerManage/GroupManage/GroupCustomerFamilyList.jsp","GroupID="+sGroupID+"&FamilySEQ="+sFamilySEQ+"&RightType=ReadOnly","");
		reloadSelf();
	}

    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//自动选中第一条记录
    my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>