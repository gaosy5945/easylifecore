<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zqliu
 * Tester:
 *
 * Content:      选择抵债资产类型
 * Input Param:
 *			    
 * Output param:
 *	AssetType：抵债资产类型	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>选择抵债资产类型</title>
<%
	//抵债资产类型
	String sAssetType="";
%>
<script type="text/javascript">

	function Get_AssetType()
	{
		var sAssetType ;
		
		//抵债资产类型
		sAssetType = document.all("AssetType").value;
		
		if(sAssetType == "")
		{
			alert(getBusinessMessage("783"));//请选择抵债资产类型！
			return;
		}
		  		
		//获取流水号
		var sAISerialNo = initSerialNo();
		var sDASerialNo = getSerialNo("NPA_DEBTASSET","SerialNo","");
		//插入刚刚产生的序列号记录，补充缺省值。
		PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAInsertActionAjax.jsp?AISerialNo="+sAISerialNo+"&AssetType="+sAssetType+"&DASerialNo="+sDASerialNo,"","");

		//返回资产类型，抵债序列号 ，和资产序列号
		self.returnValue=sAssetType+"@"+sAISerialNo+"@"+sDASerialNo;
		self.close();
	}
	
	function initSerialNo()
	{
		 //生成一个新的记录插入Asset_Info：序列号。
		var sTableName = "ASSET_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		var  sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		return sSerialNo;
	}
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
  <table align="center" width="340" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
    </tr>
	<tr> 
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >选择抵债资产分类：</td>
	<td nowarp bgcolor="#F0F1DE" > 
		<select name="AssetType" >
			<%-- <%=HTMLControls.generateDropDownSelect(Sqlca,"PDAType",sAssetType)%>  --%>
			<%=HTMLControls.generateDropDownSelect(Sqlca, "select itemno,itemname from code_library cl where isinuse='1' and cl.codeno='AssetType' and length(itemno)=5 ", 1, 2, "")%> 
		</select>
	</td>
	</tr>
    </table>
  <table align="center" width="340" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
	<td> </td>
	</tr>
    <tr>
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=new Button("确认","","Get_AssetType()","","").getHtmlText()%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=new Button("取消","","self.returnValue='';self.close()","","").getHtmlText()%></td>
    </tr>
  </table>     
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>