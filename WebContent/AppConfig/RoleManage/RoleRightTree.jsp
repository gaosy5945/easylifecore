<%@page import="com.amarsoft.app.base.util.StringHelper"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObjectManager"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><% 
	String roleID = CurPage.getParameter("RoleID");
	//定义Treeview
	List<BusinessObject> treeNodes = new ArrayList<BusinessObject>();
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(null);
	List<BusinessObject> menuList = bom.loadBusinessObjects("jbo.awe.AWE_MENU_INFO", " IsInUse='1' order by SortNo");
	for(BusinessObject menu:menuList){
		String menuID = menu.getString("MenuID");
		String menuName = menu.getString("MenuName");
		String sortNo = menu.getString("SortNo");
		if(StringX.isEmpty(sortNo)) continue;
		
		BusinessObject o=BusinessObject.createBusinessObject();
		o.setAttributeValue("ID", menuID);
		o.setAttributeValue("Name", menuName);
		o.setAttributeValue("SortNo", sortNo);
		o.setAttributeValue("Parent", "");
		o.setAttributeValue("Type", "Menu");
		treeNodes.add(o);
		String functionID = menu.getString("URLParam");
		if(StringX.isEmpty(functionID)) continue;
		functionID=StringHelper.replaceAllIgnoreCase(functionID, "SYS_FUNCTIONID=", "");
		List<BusinessObject> functionItemList = bom.loadBusinessObjects("jbo.sys.SYS_FUNCTION_LIBRARY", "FunctionID='"+functionID+"' and RightID='1' and IsInUse='1' order by FunctionID,SortNo ");
		if(functionItemList==null||functionItemList.isEmpty()) continue;
		List<String[]> parentList=new ArrayList<String[]>();
		for(BusinessObject functionItem:functionItemList){
			String itemSerialNo = functionItem.getString("SerialNo");
			String itemName = functionItem.getString("DisplayName");
			if(StringX.isEmpty(itemName)) itemName = functionItem.getString("ItemName");
			String itemSortNo = functionItem.getString("SortNo");
			if(StringX.isEmpty(itemSortNo)) continue;
			
			BusinessObject o1=BusinessObject.createBusinessObject();
			o1.setAttributeValue("ID", itemSerialNo);
			o1.setAttributeValue("Name", itemName);
			o1.setAttributeValue("SortNo", itemSortNo);
			o1.setAttributeValue("Type", "Function");
			o1.setAttributeValue("MenuID", menuID);
			String parentID=menuID;
			while(!parentList.isEmpty()){
				String[] last=parentList.get(parentList.size()-1);
				if(itemSortNo.startsWith(last[1])){
					parentID=last[0];
					break;
				}
				else{
					parentList.remove(parentList.size()-1);
				}
			}
			String[] newlast=new String[2];
			newlast[0]=itemSerialNo;newlast[1]=itemSortNo;
			parentList.add(newlast);
			
			o1.setAttributeValue("Parent", parentID);
			treeNodes.add(o1);
			
			
			//设置权限
			String roleRight=functionItem.getString("RoleRightType");
			if(!StringX.isEmpty(roleRight)){
				String[] s=roleRight.split(",");
				for(String s1:s){
					String[] s2=s1.split("\\$");
					if(!roleID.equals(s2[0])) continue;
					if(s2.length==1){
						o1.setAttributeValue("Right1", "1");
						o1.setAttributeValue("Right2", "1");
						o1.setAttributeValue("Right3", "1");
						o1.setAttributeValue("Right4", "1");
						o1.setAttributeValue("Right5", "1");
					}
					else{
						String[] orglevels=s2[1].split("@");
						for(String orglevel:orglevels){
							o1.setAttributeValue("Right"+orglevel, "1");
						}
					}
				}
			}
		}
	}
	String[][] header={
		{"Name","权限点"},
		{"Right1","一级机构"},
		{"Right2","二级机构"},
		{"Right3","三级机构"},
		{"Right4","四级机构"},
		{"Right5","五级机构"},
	};

 	String sButtons[][] = {
	   {"true","","Button","确认","确认","submitData()","","","",""},
 	};
%>
<%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
<table class='treeTable1' style="with:90%">
	<thead>
		<tr>
		<%for(int n=0;n<header.length;n++){%>
			<th name="<%=header[n][0]%>"><%=header[n][1]%></th>
		<%}%>
			<th></th>
		</tr>
	</thead>
	<tbody>
	<%
	for(int j=0;j<treeNodes.size();j++){
		BusinessObject node = treeNodes.get(j);
		String parant=node.getString("Parent");
		if(!StringX.isEmpty(parant)) parant="child-of-NODEID_"+parant;
		else parant="";
	%>
		<tr id="NODEID_<%=node.getString("ID")%>" class='<%=parant%>' nodeData=''>
		<td>
			<%=node.getString(header[0][0])%>
		</td>
		<%for(int m=1;m<header.length;m++){%>
			<td name="<%=header[m][0]%>">
				<%if("Function".equals(node.getString("Type"))){%>
				<input id="<%=node.getString("ID")+header[m][0]%>" menuID="<%=node.getString("MenuID")%>" parentID="<%=node.getString("Parent") %>" rightType="<%=header[m][0]%>" name="<%=node.getString("ID")%>" type="checkbox" style="TEXT-ALIGN: left" 
						value="<%=header[m][0].substring(5)%>" <%=("1".equals(node.getString(header[m][0]))?"CHECKED":"")%> onclick="checkRight(this)">
				<%}%>
			</td>
		<%}%>
		<td>
			<%if("Function".equals(node.getString("Type"))){%>
			<a onclick="selectAll('<%=node.getString("ID")%>',true)">全选</a>
			<a onclick="selectAll('<%=node.getString("ID")%>',false)">全不选</a>
			<%}%>
		</td>
		</tr>
	<%}%>
	</tbody>
</table>


<script type="text/javascript">
	var changedData={};
	function submitData(){
		var inputParameters={};
		inputParameters["RoleID"]="<%=roleID%>";
		inputParameters["ChangedData"]=changedData;
		var changedDataString=JSON.stringify({"InputParameter":inputParameters});
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.awe.config.role.action.RoleManager","updateRoleRight",changedDataString);
 		if(returnValue&&returnValue=="SUCCEEDED"){
			alert("授权成功！");
			return true;
 		}
 		else{
 			alert("授权失败！");
			return false;
 		}
	}
	
	function selectAll(id,flag){
		var objs = document.getElementsByName(id);
		for(var i=0;i<objs.length;i++){
			if(flag) objs[i].checked=true;
			else objs[i].checked=false;
		}
		checkRight(objs[0]);
	}
	
	function checkRight(obj){
		if(!changedData[obj.menuID])changedData[obj.menuID]={};
		
		if(!changedData[obj.menuID][obj.name]) 
			changedData[obj.menuID][obj.name]={};
		var objs = document.getElementsByName(obj.name);
		var values="";
		for(var i=0;i<objs.length;i++){
			if(objs[i].checked) values+="@"+objs[i].value;
		}
		values=values.substring(1);
		changedData[obj.menuID][obj.name]=values;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>