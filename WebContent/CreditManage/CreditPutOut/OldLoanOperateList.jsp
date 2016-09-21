<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String orgList = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OrgList from FLOW_ORGMAP where FlowOrgMapType = '01' and OrgID = :OrgID").setParameter("OrgID", CurUser.getOrgID()));
	if(rs.next()){
		orgList = rs.getString(1);
	}
	rs.close();
	
	ASObjectModel doTemp = new ASObjectModel("OldLoanOperateList");
	doTemp.appendJboWhere(" and O.OperateOrgID in ('"+orgList.replaceAll(",","','")+"','"+CurUser.getOrgID()+"')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确定","确定","enSure()","","","",""},
			{"true","All","Button","取消","取消","self.close()","","","",""},
		};
%>
<HEAD>
<title>老个贷迁移未入账贷款放款列表</title>
</HEAD>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function enSure(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		top.returnValue ="true@"+SerialNo;
		top.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
