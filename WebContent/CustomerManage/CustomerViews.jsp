<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	//定义变量
	String sSql = "";	//--存放sql语句
	String sItemAttribute = "",sItemDescribe = "",sAttribute3 = "";//--客户类型	
	String sCustomerType = "";//--客户类型	
	String sTreeViewTemplet = "";//--存放custmerview页面树图的CodeNo
	ASResultSet rs = null;//--存放结果集
	int iCount = 0;//记录数
	String sBelongGroupID = "";//所属集团客户ID
	//获得组件参数	,客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//每个客户经理查看各自的客户时，条件都会关联CUSTOMER_INFO和CUSTOMER_BELONG的CustomerID,以及CUSTOMER_BELONG的UserID，具有客户经理角色的人员只能在审批阶段可以查看当前客户的信息，在其他情况下是不可以查看的。
	//非客户经理岗位的人员：从客户所属信息表中查询出本机构及其下属机构具有当前客户的信息查看权或信息维护权的记录数		
	sSql =  " select sortno||'%' from ORG_INFO where orgid=:orgid ";
	String sSortNo = Sqlca.getString(new SqlObject(sSql).setParameter("orgid",CurUser.getOrgID()));
	sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
			" where CustomerID = :CustomerID "+
			" and OrgID in (select orgid from ORG_INFO where sortno like :SortNo) "+
			" and (BelongAttribute1 = '1' "+
			" or BelongAttribute2 = '1')";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("SortNo",sSortNo));
	if(rs.next())
		iCount = rs.getInt(1);
	//关闭结果集
	rs.getStatement().close();
	
	//如果用户没有上述相关权限，则给出相应的提示
	if( iCount  <= 0){
%>
		<script type="text/javascript">
			//用户不具备当前客户查看权
			alert( getHtmlMessage("15"));				
			top.close();
		</script>
<%
	return;//tab页面无法使用self.close()关闭，改用return；
	}
	
	//取得客户类型
	sSql = "select CustomerType,BelongGroupID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		//如果是集团成员，则取得所属集团客户ID add by jgao1 2009-11-03
		sBelongGroupID  = rs.getString("BelongGroupID");
	}
	rs.getStatement().close();
	
	if(sCustomerType == null) sCustomerType = "";
	if(sBelongGroupID == null) sBelongGroupID = "";

	//取得视图模板类型	
	sSql = " select ItemDescribe,ItemAttribute,Attribute2,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	if(rs.next()){
		sItemDescribe = DataConvert.toString(rs.getString("ItemDescribe"));		//客户详情树图类型
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));//客户详情中的显示模板(仅客户群适用)
	}
	rs.getStatement().close(); 
%>
<script type="text/javascript"> 
	AsControl.OpenView("/AppMain/resources/widget/FunctionView.jsp","FunctionID=<%=sItemDescribe%>&CustomerID=<%=sCustomerID%>","_self");
</script>
<%@ include file="/IncludeEnd.jsp"%>