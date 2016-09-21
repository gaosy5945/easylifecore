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
 		//var returnvalue = AsControl.RunJavaMethodTrans("com.amarsoft.app.rule.RuleInvoke","run","sceneID="+"CFRule"+",ruleID="+"CF001"+",ruleType="+"RuleFlow"+",objectNo="+sobjectNo+",objectType="+sobjectType);
		var returnvalue = AsControl.RunJavaMethodTrans("com.amarsoft.app.rule.RuleInvoke","run","sceneID="+"CFRule"+",ruleID="+"CFCP0001"+",ruleType="+"Rule"+",callType="+<%=sCallType%>+",objectNo="+sobjectNo+",objectType="+sobjectType);
		
		OpenComp("ShowRuleDecision","/Common/Rule/ShowRuleDecision.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo=<%=sTaskSerialNo%>&RuleLogID=<%=sRuleLogID%>&CallType=<%=sCallType%>","_self");
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
		document.all("text_"+index).style.display="";
	}
	else{
		document.all("text_"+index).style.display="none";
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

<table class="list_data_tablecommon">
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="listdw_out_buttonarea" valign=top>
	    </td>
	</tr>
	<tr>
		<td align="left" nowrap>
		<div>
		  <table class="info_data_tablecommon info_group_table" width='100%'>
		  	<thead class='list_topdiv_header'>
		  		<th width=5%>���</th>
		      	<th width=55% >�Զ����߽��</th>
		      	<th width=5%>����</th>
		      	<th width=43%>��ע</th>
		    </thead>
		    <tbody>
		    <%
		    int i=0;
		    String resultDesc = "",result = "",checked = "",remark = "",disabled = "",resultRemark = "";
		    HashMap<String,String> map = new HashMap<String,String>();
		    String custKeys [] = {"����","����","������","�ͻ��������","����˹������","�⼮��ʿְҵ���",
		    		"����","����","����","���⽻��","�˻�״̬","���з��յȼ�"};
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
			if(sIgnored == null || sIgnored.length() == 0){
				ro = new ResultObject();
			}
			else{
				ro = new ResultObject(sIgnored);
			}
		    ArrayList alSD = new ArrayList();
		    ArrayList alD = new ArrayList();
		    ArrayList alO = new ArrayList();
		    ArrayList alP = new ArrayList();
		    for(Iterator it = map.keySet().iterator(); it.hasNext();){
		    	resultDesc = (String)it.next();
		    	if(resultDesc.endsWith("_R")){
		    		continue;
		    	}
		    	result = (String)map.get(resultDesc);
		    	if("SD".equals(result)){
		    		alSD.add(resultDesc);
		    	}else if("D".equals(result)){
		    		alD.add(resultDesc);
		    	}else if("P".equals(result)){
		    		alP.add(resultDesc);
		    	}else{
		    		alO.add(resultDesc);
		    	}
		    }
		    String st [] = new String[alSD.size()];
		    int j = 0;
		    for(Iterator it = alSD.iterator(); it.hasNext();j++){
		    	resultDesc = (String)it.next();
		    	st[j] = resultDesc;
		    }
		    Arrays.sort(st);
		    for(j=0; j < st.length;j++){
		    	resultDesc = st[j];
		    	if(resultDesc.endsWith("_R")){
		    		continue;
		    	}
		    	result = (String)map.get(resultDesc);
		    	resultRemark = (String)map.get(resultDesc+"_R");
		    	if(resultDesc.length()>0){
		    		resultDesc = resultDesc.substring(1);
		    	}
		    	if(result == null || result.length() == 0){
		    		result = "&nbsp;";
		    	}
		    	if(resultRemark == null || resultRemark.length() == 0){
		    		resultRemark = "&nbsp;";
		    	}
		    	try{
		    		result = DataConvert.toMoney(result);
		    	}catch(Exception e){
		    	}
		    	if("P".equals(result)){
		    		result = "<font style='font-weight:bold;color:green;font-style:italic;'>Pass</font>";
		    		//continue;
		    	}
		    	if("D".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>Deviation</b></font>";
		    	}
		    	if("SD".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>SD</b></font>";
		    	}
		    	if("RETURNVALUE".equals(resultDesc))
		    		continue;
		    	resultDesc = StringFunction.replace(resultDesc, "�����.", "");
		    	if(ro.get(resultDesc, "").equals("Y")){
		    		checked = "checked";
		    		disabled = "";
		    	}else{
		    		checked = "";
		    		disabled = "disabled";
		    	}
		    	remark = ro.get(resultDesc+"_R", "");
		    %>
		    <script language="javascript">
		    	resultItems[<%=i%>] = "<%=i%>";
		    	resultItemNames[<%=i%>] = "<%=resultDesc%>";
		   	</script>
		    <tr>
		   		<td class="list_all_td" align="center"  vAlign="middle"><%=i+1%></td>
		    	<td class="list_all_td" align="center"  vAlign="middle">
		    		<table id="listTable" width='100%' >
		    			<tr>
		    				<td align="center"  vAlign="middle" width=30%><%=resultDesc%></td>
		      				<td align="center"  vAlign="middle" width=10%><%=result%></td>
		      				<td align="center"  vAlign="middle" width=30%><%=resultRemark%></td>
		    			</tr>
		    		</table>
		    	</td>
		      	<td class="list_all_td" align="center"  vAlign="middle" width=2% >
					<input type=checkbox id='checkbox_<%=i%>' name='checkbox_<%=i%>' onclick=changeInputStatus('<%=i%>') <%=checked%>>
				</td>
				<td class="list_all_td" align="center"  vAlign="middle" width=43% >
					<input type=text id='text_<%=i%>' name='text_<%=i%>' value='<%=remark%>' style='width=100%;display:none' <%=disabled%>>
				</td>
		    </tr>
		    <%
		    	i++;
		    }
		    st = new String[alD.size()];
		    j = 0;
		    for(Iterator it = alD.iterator(); it.hasNext();j++){
		    	resultDesc = (String)it.next();
		    	st[j] = resultDesc;
		    }
		    Arrays.sort(st);
		    for(j=0; j < st.length;j++){
		    	resultDesc = st[j];
		    	if(resultDesc.endsWith("_R")){
		    		continue;
		    	}
		    	result = (String)map.get(resultDesc);
		    	resultRemark = (String)map.get(resultDesc+"_R");
		    	if(resultDesc.length()>0){
		    		resultDesc = resultDesc.substring(1);
		    	}
		    	if(result == null || result.length() == 0){
		    		result = "&nbsp;";
		    	}
		    	if(resultRemark == null || resultRemark.length() == 0){
		    		resultRemark = "&nbsp;";
		    	}
		    	try{
		    		result = DataConvert.toMoney(result);
		    	}catch(Exception e){
		    	}
		    	if("P".equals(result)){
		    		result = "<font style='font-weight:bold;color:green;font-style:italic;'>Pass</font>";
		    		//continue;
		    	}
		    	if("D".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>Deviation</b></font>";
		    	}
		    	if("SD".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>SD</b></font>";
		    	}
		    	if("RETURNVALUE".equals(resultDesc))
		    		continue;
		    	resultDesc = StringFunction.replace(resultDesc, "�����.", "");
		    	if(ro.get(resultDesc, "").equals("Y")){
		    		checked = "checked";
		    		disabled = "";
		    	}else{
		    		checked = "";
		    		disabled = "disabled";
		    	}
		    	remark = ro.get(resultDesc+"_R", "");
		    %>
		    <script language="javascript">
		    	resultItems[<%=i%>] = "<%=i%>";
		    	resultItemNames[<%=i%>] = "<%=resultDesc%>";
		   	</script>
		    <tr>
		   		<td class="list_all_td" align="center"  vAlign="middle"><%=i+1%></td>
		    	<td class="list_all_td" align="center"  vAlign="middle">
		    		<table id="listTable" width='100%' >
		    			<tr>
		    				<td align="center"  vAlign="middle" width=30%><%=resultDesc%></td>
		      				<td align="center"  vAlign="middle" width=10%><%=result%></td>
		      				<td align="center"  vAlign="middle" width=30%><%=resultRemark%></td>
		    			</tr>
		    		</table>
		    	</td>
		      	<td class="list_all_td" align="center"  vAlign="middle" width=2% >
					<input type=checkbox id='checkbox_<%=i%>' name='checkbox_<%=i%>' onclick=changeInputStatus('<%=i%>') <%=checked%>>
				</td>
				<td class="list_all_td" align="center"  vAlign="middle" width=43% >
					<input type=text id='text_<%=i%>' name='text_<%=i%>' value='<%=remark%>' style='width=100%;display:none' <%=disabled%>>
				</td>
		    </tr>
		    <%
		    	i++;
		    }
		    st = new String[alO.size()];
		    j = 0;
		    for(Iterator it = alO.iterator(); it.hasNext();j++){
		    	resultDesc = (String)it.next();
		    	st[j] = resultDesc;
		    }
		    Arrays.sort(st);
		    for(j=0; j < st.length;j++){
		    	resultDesc = st[j];
		    	if(resultDesc.endsWith("_R")){
		    		continue;
		    	}
		    	result = (String)map.get(resultDesc);
		    	resultRemark = (String)map.get(resultDesc+"_R");
		    	if(resultDesc.length()>0){
		    		resultDesc = resultDesc.substring(1);
		    	}
		    	if(result == null || result.length() == 0){
		    		result = "&nbsp;";
		    	}
		    	if(resultRemark == null || resultRemark.length() == 0){
		    		continue;
		    		//resultRemark = "&nbsp;";
		    	}
		    	try{
		    		result = DataConvert.toMoney(result);
		    	}catch(Exception e){
		    	}
		    	if("P".equals(result)){
		    		result = "<font style='font-weight:bold;color:green;font-style:italic;'>Pass</font>";
		    		//continue;
		    	}
		    	if("D".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>Deviation</b></font>";
		    	}
		    	if("SD".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>SD</b></font>";
		    	}
		    	if("RETURNVALUE".equals(resultDesc))
		    		continue;
		    	resultDesc = StringFunction.replace(resultDesc, "�����.", "");
		    	if(ro.get(resultDesc, "").equals("Y")){
		    		checked = "checked";
		    		disabled = "";
		    	}else{
		    		checked = "";
		    		disabled = "disabled";
		    	}
		    	remark = ro.get(resultDesc+"_R", "");
		    %>
		    <script language="javascript">
		    	resultItems[<%=i%>] = "<%=i%>";
		    	resultItemNames[<%=i%>] = "<%=resultDesc%>";
		   	</script>
		    <tr>
		   		<td class="list_all_td" align="center"  vAlign="middle"><%=i+1%></td>
		    	<td class="list_all_td" align="center"  vAlign="middle">
		    		<table id="listTable" width='100%' >
		    			<tr>
		    				<td align="center"  vAlign="middle" width=30%><%=resultDesc%></td>
		      				<td align="center"  vAlign="middle" width=10%><%=result%></td>
		      				<td align="center"  vAlign="middle" width=30%><%=resultRemark%></td>
		    			</tr>
		    		</table>
		    	</td>
		      	<td class="list_all_td" align="center"  vAlign="middle" width=2% >
					<input type=checkbox id='checkbox_<%=i%>' name='checkbox_<%=i%>' onclick=changeInputStatus('<%=i%>') <%=checked%>>
				</td>
				<td class="list_all_td" align="center"  vAlign="middle" width=43% >
					<input type=text id='text_<%=i%>' name='text_<%=i%>' value='<%=remark%>' style='width=100%;display:none' <%=disabled%>>
				</td>
		    </tr>
		    <%
		    	i++;
		    }
		    st = new String[alP.size()];
		    j = 0;
		    for(Iterator it = alP.iterator(); it.hasNext();j++){
		    	resultDesc = (String)it.next();
		    	st[j] = resultDesc;
		    }
		    Arrays.sort(st);
		    for(j=0; j < st.length;j++){
		    	resultDesc = st[j];
		    	if(resultDesc.endsWith("_R")){
		    		continue;
		    	}
		    	result = (String)map.get(resultDesc);
		    	resultRemark = (String)map.get(resultDesc+"_R");
		    	if(resultDesc.length()>0){
		    		resultDesc = resultDesc.substring(1);
		    	}
		    	if(result == null || result.length() == 0){
		    		result = "&nbsp;";
		    	}
		    	if(resultRemark == null || resultRemark.length() == 0){
		    		continue;
		    		//resultRemark = "&nbsp;";
		    	}
		    	try{
		    		result = DataConvert.toMoney(result);
		    	}catch(Exception e){
		    	}
		    	if("P".equals(result)){
		    		result = "<font style='font-weight:bold;color:green;font-style:italic;'>Pass</font>";
		    		//continue;
		    	}
		    	if("D".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>Deviation</b></font>";
		    	}
		    	if("SD".equals(result)){
		    		result = "<font style='font-weight:bold;color:red;font-style:italic;'><b>SD</b></font>";
		    	}
		    	if("RETURNVALUE".equals(resultDesc))
		    		continue;
		    	resultDesc = StringFunction.replace(resultDesc, "�����.", "");
		    	if(ro.get(resultDesc, "").equals("Y")){
		    		checked = "checked";
		    		disabled = "";
		    	}else{
		    		checked = "";
		    		disabled = "disabled";
		    	}
		    	remark = ro.get(resultDesc+"_R", "");
		    %>
		    <script language="javascript">
		    	resultItems[<%=i%>] = "<%=i%>";
		    	resultItemNames[<%=i%>] = "<%=resultDesc%>";
		   	</script>
			<tr>
		   		<td class="list_all_td" align="center"  vAlign="middle"><%=i+1%></td>
		    	<td class="list_all_td" align="center"  vAlign="middle">
		    		<table id="listTable" width='100%' >
		    			<tr>
		    				<td align="center"  vAlign="middle" width=30%><%=resultDesc%></td>
		      				<td align="center"  vAlign="middle" width=10%><%=result%></td>
		      				<td align="center"  vAlign="middle" width=30%><%=resultRemark%></td>
		    			</tr>
		    		</table>
		    	</td>
		      	<td class="list_all_td" align="center"  vAlign="middle" width=2% >
					<input type=checkbox id='checkbox_<%=i%>' name='checkbox_<%=i%>' onclick=changeInputStatus('<%=i%>') <%=checked%>>
				</td>
				<td class="list_all_td" align="center"  vAlign="middle" width=43% >
					<input type=text id='text_<%=i%>' name='text_<%=i%>' value='<%=remark%>' style='width=100%;display:none' <%=disabled%>>
				</td>
		    </tr>
		    <%
		    	i++;
		    }
		    %>
		    <tr></tr>
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