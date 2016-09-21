<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: 担保类型选择框;
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String objectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	
	//根据sObjectType的不同，得到不同的关联表名
	String sSql="select BusinessType from "+JBOFactory.getBizObjectManager(objectType).getManagedClass().getName()+" where SerialNo=:SerialNo";
	String sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",objectNo));
%>

<html>
<head> 
<title>选择担保类型</title>
<script type="text/javascript">
function newGuarantyInfo()
{
		top.returnValue=document.getElementById("NewGuarantyType").value;
		top.close();
}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择担保类型：</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select id="NewGuarantyType">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and IsInUse = '1' and ItemNo like '010%' and length(SortNo) >3 order by SortNo ",1,2,"")%> 
        </select>
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newGuarantyInfo()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>