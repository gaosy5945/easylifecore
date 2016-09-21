<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 
<%@page import="com.amarsoft.app.alarm.*"%>
<%@page import="com.amarsoft.awe.util.ObjectConverts"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java"
	import="java.net.*,java.io.*,java.util.*,
	com.amarsoft.core.xml.*,com.amarsoft.core.util.*,com.amarsoft.rule.*,com.amarsoft.core.json.*,
	com.amarsoft.core.object.*"%>
	
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   dxu
	Tester:
	Content: ���й������չ��
	Input Param:
	Output param:
	History Log: 
	*/
	%>
<%/*~END~*/%>


<%
	ResultSet rs = null;
	String sSql = "",sDecisionTitle = "",sPath = "";
	String sApproveLevel = "",sCustomerName = "";
	String sStepSerialNo = "",sLogID = "",sTable = "",sLogType = "",sOutCome = "",sNodeID = "",sNodeName = "",sNodeOutCome = "",sNodeMessage = "";
	
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sTaskSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sRuleLogID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RuleLogID"));
	String sCallType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CallType"));
	JSONObject oRuleResult = null;
	
	String sRuleID = "";
	String sRuleType = "";
	String sSceneID = "";
	String sResult = "";
	String sStatus = "";
	String sIgnored = "";
	String sBOM = "";
	String invokeType = "";
	String invokeDesc = "";
	ArrayList alResult = new ArrayList();
	ArrayList alIgnored = new ArrayList();
	ArrayList alInvokeDesc = new ArrayList();
	
 	sDecisionTitle = "ϵͳ�Զ�������";
	sSql = "select * from RULE_LOG where ObjectType=? and ObjectNo=? order by  InvokeType ";
	PreparedStatement pstm = Sqlca.getConnection().prepareStatement(sSql);
	pstm.setString(1, sObjectType);
	pstm.setString(2, sObjectNo);
 	rs = pstm.executeQuery();
	while(rs.next())
	{
		String calltype=rs.getString("calltype");
		if(!sCallType.endsWith(calltype)){
			continue;//����callType����Ҫ�ϸ�淶���������������ѭ��
		}
		sRuleID = rs.getString("RuleID");
		sRuleType = rs.getString("RuleType");
		sResult = rs.getString("Result");
		sStatus = rs.getString("Status");
		sIgnored = rs.getString("Ignored");
		sBOM = rs.getString("INBOM");
		invokeType = rs.getString("InvokeType");
		if(invokeType == null)invokeType = "B";
		if("B".equals(invokeType)){
			sLogID = rs.getString("LogID");
		}
		invokeDesc = rs.getString("InvokeDesc");
		alResult.add(sResult);
		alIgnored.add(sIgnored);
		alInvokeDesc.add(invokeDesc);
	}
	rs.close();
	pstm.close();
%>
<script language=javascript>
/*~[Describe=ϵͳ�Զ�����;InputParam=��;OutPutParam=��;]~*/

 
	function invokeRE(sobjectNo,sobjectType){
		var sRuleID = ""; /* = RunMethod("ProductManage","SelectRuleID",objectNo);
		if(typeof(sRuleID)=="undefined"||sRuleID.length==0){
			alert("��ǰҵ���Ӧ��Ʒδ���á��Զ����߹��򡿹����������޷�����ϵͳ�Զ����߹��ܣ�");
			return;
		} */
 		var returnvalue = AsControl.RunJavaMethodTrans("com.amarsoft.app.rule.RuleInvoke","run","sceneID="+"CFRule"+",ruleID="+"CFCI002"+",ruleType="+"Rule"+",callType="+<%=sCallType%>+",objectNo="+sobjectNo+",objectType="+sobjectType);
		
		OpenComp("ShowRuleDecision","/Common/Rule/ShowRuleDecision2.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo=<%=sTaskSerialNo%>&RuleLogID=<%=sRuleLogID%>&CallType=<%=sCallType%>","_self");
 	}
 	var hasRuleID = "<%=sRuleID%>";
 	if(typeof(hasRuleID)==undefined || hasRuleID=="")
	  invokeRE("<%=sObjectNo%>","<%=sObjectType%>");
</script>
<%
	//��ֹ�������ڳ�������Ĭ��ֵΪ L 
	if(sApproveLevel==null)	sApproveLevel = "PASS";
%>
 
 
<script type="text/javascript">
var resultItems = new Array();
var resultItemNames = new Array();

function changeInputStatus(index){
	if(document.all("text_"+index).disabled){
		document.all("text_"+index).disabled = false;
	}
	else{
		document.all("text_"+index).disabled = true;
		document.all("text_"+index).value = "";
	}
}

function saveRecord(){
	var sItem = "";
	var sRemark = "";
	for(i=0;i<resultItems.length;i++){
		var check = document.all("checkbox_"+resultItems[i]).checked;
		if(check){
			sItem += "@"+resultItemNames[i];
			if(document.all("text_"+resultItems[i]).value.length==0){
				//�Ӹ��ո��ֹ����
				sRemark += "@"+document.all("text_"+resultItems[i]).value.replace(',','��')+" ";
			}else{
				sRemark += "@"+document.all("text_"+resultItems[i]).value.replace(',','��');
			}
		}
	}
	if(sItem.length>0){
		sItem = sItem.substring(1);
	}
	if(sRemark.length>0){
		sRemark = sRemark.substring(1);
	}
	var s = RunMethod("PublicMethod","SaveRuleResultIgnore","<%=sLogID%>,"+sItem+","+sRemark);
	alert(s);
}

</script>
<%/*~END~*/%>
<html>
<head>
<title>�Զ�������ҳ��</title> 
<body class="pagebackground" style="overflow-x:scroll" >
 
<table  class="list_data_tablecommon">
	<tr>
		<td align="left" nowrap>
		<div>
		  <table class="info_data_tablecommon info_group_table" width='100%'>
		  	<thead class='list_topdiv_header'>
		      	<th style="background:transparent;border:0px" >�ͻ����ֽ��</th>
		    </thead>
		  </table>
		  <table class="info_data_tablecommon info_group_table" width='100%'>
		  	 <thead class='list_topdiv_header'>
		  		<th width=5%>���</th>
			    <th >�������</th>
				<th >ָ������</th>
		      	<th >�÷�</th>
		    </thead>
		    <tbody>
		    <%
		    int i=0;
		    String resultDesc = "",result = "",checked = "",remark = "",disabled = "",resultRemark = "";
		    HashMap<String,String> map = new HashMap<String,String>();
		    String custKeys [] = { "���з��յȼ�"};
		    for(int j = 0;j < alResult.size();j++){
		    	sResult = (String)alResult.get(j);
		    	invokeDesc = (String)alInvokeDesc.get(j);
		    	sIgnored = (String)alIgnored.get(0);
		    	com.amarsoft.app.rule.RuleResultPaser rrp = new com.amarsoft.app.rule.RuleResultPaser(sResult);
			    //System.out.println(sResult);
			    ASValuePool data = rrp.paseReturn();
			    if(j == 0){
			    	HashMap<String,String> mapTemp = new HashMap<String,String>();
			    	rrp.paseResult(data,mapTemp,"");
			    	for(Iterator it = mapTemp.keySet().iterator();it.hasNext();){
			    		String keyTemp = (String)it.next();
			    		String valueTemp = mapTemp.get(keyTemp);
			    		boolean b = true;
			    		for(int k = 0;k < custKeys.length;k++){
			    			if(keyTemp.indexOf(custKeys[k])>0){
			    				map.put(" �������"+keyTemp, valueTemp);
			    				b = false;
			    			}
			    		}
			    		if(b){
			    			map.put(keyTemp, valueTemp);
			    		}
			    	}
			    }else{
			    	HashMap<String,String> mapTemp = new HashMap<String,String>();
			    	rrp.paseResult(data,mapTemp,"");
			    	for(Iterator it = mapTemp.keySet().iterator();it.hasNext();){
			    		String keyTemp = (String)it.next();
			    		String valueTemp = mapTemp.get(keyTemp);
			    		for(int k = 0;k < custKeys.length;k++){
			    			if(keyTemp.indexOf(custKeys[k])>0){
			    				map.put(" ��ͬ�����"+keyTemp, valueTemp);
			    			}
			    		}
			    	}
			    }
		    }
		    
		    ResultObject ro = null;
			 
		   
		    String resultItem = null;
		    String resultValue =null;
		    String groupname =null;
		    for(Iterator it = map.keySet().iterator(); it.hasNext();){
		    	resultItem = (String)it.next();
		    	resultValue = (String)map.get(resultItem);
 		    	if(resultItem.startsWith(".")){
		    		resultItem=resultItem.substring(1, resultItem.length());	    		
		    	}
 		    	groupname=resultItem.substring(0,resultItem.indexOf("."));
 		    	resultItem =resultItem.substring( resultItem.indexOf(".")+1,resultItem.length());
 		    	resultItem = StringFunction.replace(resultItem, "��.", "");
		    %>
		    
		    <tr>
		    	<td class="list_all_td" align="center"  vAlign="middle"><%=i+1%></td>
			    <td class="list_all_td" align="center"  vAlign="middle" width=30%><%=groupname%></td>
				<td class="list_all_td" align="center"  vAlign="middle" width=50%><%=resultItem%></td>
		      	<td class="list_all_td" align="center"  vAlign="middle" width=20%><%=resultValue%></td>
		      	 
		    </tr>
		    <%
		    	i++;
		    }
		    
		    %>
		    </tbody>
		    </table>
		    &nbsp;
		    </div>
		</td>
	</tr>
</table>
</body>
</html>

<%@	include file="/IncludeEnd.jsp"%>