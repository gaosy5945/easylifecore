<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zqliu
 * Tester:
 *
 * Content:      ѡ���ծ�ʲ�����
 * Input Param:
 *			    
 * Output param:
 *	AssetType����ծ�ʲ�����	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>ѡ���ծ�ʲ�����</title>
<%
	//��ծ�ʲ�����
	String sAssetType="";
%>
<script type="text/javascript">

	function Get_AssetType()
	{
		var sAssetType ;
		
		//��ծ�ʲ�����
		sAssetType = document.all("AssetType").value;
		
		if(sAssetType == "")
		{
			alert(getBusinessMessage("783"));//��ѡ���ծ�ʲ����ͣ�
			return;
		}
		  		
		//��ȡ��ˮ��
		var sAISerialNo = initSerialNo();
		var sDASerialNo = getSerialNo("NPA_DEBTASSET","SerialNo","");
		//����ող��������кż�¼������ȱʡֵ��
		PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAInsertActionAjax.jsp?AISerialNo="+sAISerialNo+"&AssetType="+sAssetType+"&DASerialNo="+sDASerialNo,"","");

		//�����ʲ����ͣ���ծ���к� �����ʲ����к�
		self.returnValue=sAssetType+"@"+sAISerialNo+"@"+sDASerialNo;
		self.close();
	}
	
	function initSerialNo()
	{
		 //����һ���µļ�¼����Asset_Info�����кš�
		var sTableName = "ASSET_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
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
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >ѡ���ծ�ʲ����ࣺ</td>
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
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=new Button("ȷ��","","Get_AssetType()","","").getHtmlText()%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=new Button("ȡ��","","self.returnValue='';self.close()","","").getHtmlText()%></td>
    </tr>
  </table>     
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>