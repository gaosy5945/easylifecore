<%@page import="com.amarsoft.app.util.ASUserObject"%>
<%@page import="com.amarsoft.app.als.customer.common.action.GetCustomer"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%
		//获取参数  集团编号，父节点， 成员编号， 版本号 
		String sGroupID= CurPage.getParameter("GroupID");
	    String sParentMemberID = CurPage.getParameter("ParentMemberID");
	    String sMemberCustomerID = CurPage.getParameter("MemberCustomerID");
		String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
	    
		if(sGroupID == null) sGroupID = "";
		if(sParentMemberID == null) sParentMemberID = "";
		if(sMemberCustomerID == null) sMemberCustomerID = "";
		if(sRefVersionSeq == null) sRefVersionSeq = "";

		String sTempletNo = "MemberInfoViewInfo";//模板号
		ASObjectModel doTemp = new ASObjectModel(sTempletNo);
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
		dwTemp.Style = "2";//freeform
		//dwTemp.ReadOnly = "-2";//只读模式
		dwTemp.genHTMLObjectWindow(sGroupID+","+sRefVersionSeq+","+sMemberCustomerID);

		String sButtons[][] = {
	        {"true","","Button","保存","保存所有修改","doReturn()","","","",""},
	        {"true","","Button","返回","返回列表页面","goBack()","","","",""}
	        };
%>  
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script language=javascript>
	function doReturn(){
		var sShareValue = getItemValue(0,getRow(),"ShareValue");
		if(parseFloat(sShareValue)>100 || parseFloat(sShareValue)<0){
			alert("持股比例必须在[0,100]");
			return;
		}
		var sMemberCustomerID = getItemValue(0,getRow(),"MemberCustomerID");
		var sAddReason = getItemValue(0,getRow(),"ATT01");
		if(sMemberCustomerID=="" || sMemberCustomerID==""){
			alert("请选择客户！");
			return;
		}

		if(sAddReason==""){
			alert("请选择加入成员原因！");
			return;
		}
		icount = getRowCount(0);
		if(icount>0){ //更新
	 		setItemValue(0,getRow(),"REVISEFLAG","CHANGED");
			as_save("myiframe0","goBack('1')");
		}else{ //新增
			//检查成员是否属于其他集团
			var sGroupID= "<%=sGroupID%>";
			RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","forDeleteGroupmember","MemberCustomerID="+sMemberCustomerID+",GroupID="+sGroupID);
	 		var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer","MemberCustomerID="+sMemberCustomerID+",GroupID="+sGroupID);
	 		if(sReturn!="true"){
				alert(sReturn);
				return;
			}
	 		if(sShareValue==""){
	 		    alert("请输入持股比例!");
	 		    return;
	 		}
	 		setItemValue(0,getRow(),"ParentMemberID","<%=sParentMemberID%>");
	 		setItemValue(0,getRow(),"REVISEFLAG","NEW");
	 		setItemValue(0,getRow(),"GroupID","<%=sGroupID%>");
	 		setItemValue(0,getRow(),"MemberID","<%=DBKeyHelp.getSerialNo("GROUP_FAMILY_MEMBER", "MEMBERID")%>");
	 		setItemValue(0,getRow(),"VersionSeq","<%=sRefVersionSeq%>");
			as_save("myiframe0","goBack('1')");
		}
	}

	function goBack(flag){
		top.returnValue = flag;
		top.close();
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码
		var sRet = AsDialog.OpenSelector("SelectKeyMemberCustomerID","","@MemberCustomerID@0@MemberName@1@MemberCertType@3@MemberCertID@4",0,0,"");
		if(sRet == "_CANCEL_") {sRet="@@@@";}
		if(sRet) {
        	sRet = sRet.split("@");
        	setItemValue(0,getRow(),"MemberCustomerID",sRet[0]);
        	setItemValue(0,getRow(),"MemberName",sRet[1]);
        	setItemValue(0,getRow(),"MemberCertType",sRet[2]);
        	setItemValue(0,getRow(),"MemberCertID",sRet[3]);
        }
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>